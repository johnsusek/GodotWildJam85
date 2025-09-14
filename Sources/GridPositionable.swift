import Foundation
import SwiftGodot
import SwiftGodotPatterns

// GridPositionable
// Conceptual/archtecture layer above "game logic" but below "drawing logic"
// ties game logic <-> grid logic

struct SubstrateTile {
  var kind: SoilSubstrate
  var nutrientValue: Int // for rot
  var decayTimer: Int? // for rot
  var moistureCapacity: Int // for water
  var permeability: Float // movement ease
  var hazard: SoilHazardFlags
  var seenTurn: Int? // last fully visible turn
}

struct TrunkTile {
  var thickness: Thickness
  var integrityHp: Int
  var leakFactor: Float // thin leaks more, clay reduces leak, hydrophic tag reduces leak
  var enzymeTags: Set<EnzymeTag>
  var builtTurn: Int
}

// Tips auto-despawn on non-frontier tiles
// Auto-spawn a tip when creating a new dead-end trunk tile
struct HyphaTip: Identifiable {
  var id: UUID
  var gridPosition: GridPos

  var direction: CardinalDirection
  var isReady: Bool

  // at least one neighbor that is passable substrate
  // should be derived from neighbor data
  var hasGrowableNeighbor: Bool
}

struct FruitBody: Hashable, Identifiable {
  var id: UUID
  var gridPosition: GridPos
  var coveredTrunkCount: Int
  var plantedTurn: Int
  var maturationTurns: Int
  var state: FruitBodyState
  var scoreValue: Int
}

