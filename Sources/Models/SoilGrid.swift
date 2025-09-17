import Foundation
import SwiftGodot
import SwiftGodotPatterns

struct SoilGrid: Codable, Grid {
  var size: GridSize
  var tileSize: Float
  var substrate: [[SubstrateTile]]
  var trunk: [[TrunkTile?]]
  var discovered: [[Bool]]
  var visible: [[Bool]]
  var fruitingSites: Set<FruitBody>

  static func makeDefaultGrid() -> SoilGrid {
    var grid = SoilGrid(
      size: GridSize(w: 20, h: 12),
      tileSize: GRID_UNIT,
      substrate: [],
      trunk: [],
      discovered: [],
      visible: [],
      fruitingSites: Set<FruitBody>()
    )

    let soilTile = SubstrateTile(
      kind: .soil,
      nutrientValue: 1,
      moistureCapacity: 1,
      permeability: 1,
      hazard: nil,
      seenTurn: nil
    )

    grid.populate(with: soilTile)

    return grid
  }

  mutating func populate(with substrateTile: SubstrateTile) {
    // Populate grid.trunk arrays
    for row in 0 ..< size.h {
      trunk.append([])
      for _ in 0 ..< size.w {
        trunk[row].append(nil)
      }
    }

    // Populate grid.substrate arrays with soil tiles
    for row in 0 ..< size.h {
      substrate.append([])
      for _ in 0 ..< size.w {
        substrate[row].append(substrateTile)
      }
    }
  }

  mutating func place(tile: TrunkTile, at: GridPos) {
    trunk[at.y][at.x] = tile
  }
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

struct FruitBody: Codable, Hashable, Identifiable {
  var id: UUID
  var gridPosition: GridPos
  var coveredTrunkCount: Int
  var plantedTurn: Int
  var maturationTurns: Int
  var state: FruitBodyState
  var scoreValue: Int
}

struct SubstrateTile: Codable {
  var kind: SoilSubstrate
  var nutrientValue: Int // for rot
  var decayTimer: Int? // for rot
  var moistureCapacity: Int // for water
  var permeability: Float // movement ease
  var hazard: Set<SoilHazardFlags>?
  var seenTurn: Int? // last fully visible turn
}

struct TrunkTile: Codable {
  var thickness: Thickness
  var integrityHp: Int
  var leakFactor: Float // thin leaks more, clay reduces leak, hydrophic tag reduces leak
  var enzymeTags: Set<EnzymeTag>
  var builtTurn: Int
}
