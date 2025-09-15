import Foundation
import SwiftGodot
import SwiftGodotPatterns

// Hard clock: Season, Soft clock: Evaporation (put these in HUD)

// Resource models:
// M - Moisture
// N - Nutrients
// moisture model - leak rate
// moisture is mostly global
// each water-adjacent tile produces M/turn
// each trunk tile consumes leakFactor per turn
// expansions have M/N costs; evaporation raises leakFactor globally
// when generating maps - make sure rot and water are reachable...
// nutrient model - rot tiles
// eat rot-adjacent tile produces N/turn

// Hazards: Pests, Bacteria

enum SoilSubstrate: String {
  case soil = "substrate.soil"
  case rot = "substrate.rot"
  case root = "substrate.root"
  case water = "substrate.water"
  case stone = "substrate.stone"
  case clay = "substrate.clay"
}

enum SoilHazardFlags { case none, bacteria, pest }

enum Thickness: String { case thin = "trunk.thin", thick = "trunk.thick" }

enum EnzymeTag {
  case cellulase // good on wood/rot, weak vs pests
  case laccase // good on bark/root, boosts bacteria if overused (?)
  case chitinase // controls pests, weak on dense wood
}

enum CardinalDirection: String, CaseIterable { case north, south, east, west }

enum VisibilityState { case undiscovered, remembered, visible }

enum FruitBodyState { case growing, mature }

enum PlayerActions {
  case extend(dir: CardinalDirection) // costs some M/N depending on substrate, effect: convert target tile to trunk(thin) and move tip there
  case branch(dir: CardinalDirection) // costs a little M/N turn trunk -> tip on same tile (cap via tipsPerTurn/totalTips)
  case thicken // costs N, adds HP and reduces leakfactor
  case exude(dir: CardinalDirection) // costs enzymeCharges, duration # turns, effect: digest wood/bark faster, sterilize bactera, kill pests, etc
  case fruit // at a fruiting site, spend large M/N to plant FruitBody
}

struct SoilGrid: Grid {
  var size: GridSize
  var tileSize: Float
  var substrate: [[SubstrateTile]]
  var trunk: [[TrunkTile?]]
  var discovered: [[Bool]]
  var visible: [[Bool]]
  var fruitingSites: Set<FruitBody>
}

func randomDirs() -> [GridPos] {
  // draw 3 tips in random cardinal dirs
  var dirs = CardinalDirection.allCases
  dirs.remove(at: Int.random(in: 0 ..< CardinalDirection.allCases.count))
  var vs: [GridPos] = []

  for direction in dirs {
    switch direction {
      case .east:
        vs.append(GridPos(x: 1, y: 0))
      case .north:
        vs.append(GridPos(x: 0, y: -1))
      case .west:
        vs.append(GridPos(x: -1, y: 0))
      case .south:
        vs.append(GridPos(x: 0, y: 1))
    }
  }

  return vs
}

struct Colony {
  var moisture: Int // each trunk tile adjacent to water adds per-turn, trunks consume leakFactor, weather/rain events to change (?)
  var nutrients: Int
  var enzymeCharges: Int
  var tips: [HyphaTip]
  var enzymesKnown: Set<EnzymeTag>
  var actionQueue: CommandQueue
}
