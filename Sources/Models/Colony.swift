import Foundation
import SwiftGodotPatterns

struct Colony: Codable {
  var moisture: Int // each trunk tile adjacent to water adds per-turn, trunks consume leakFactor, weather/rain events to change (?)
  var nutrients: Int
  var enzymeCharges: Int
  var tips: [HyphaTip]
  var enzymesKnown: Set<EnzymeTag>

  static var defaultColony: Colony {
    Colony(
      moisture: 100,
      nutrients: 100,
      enzymeCharges: 3,
      tips: [.init(id: UUID(), gridPosition: GridPos(x: 10, y: 7), direction: .east, isReady: true, hasGrowableNeighbor: true)],
      enzymesKnown: Set<EnzymeTag>(),
    )
  }
}

// Tips auto-despawn on non-frontier tiles
// Auto-spawn a tip when creating a new dead-end trunk tile
struct HyphaTip: Codable, Identifiable {
  var id: UUID
  var gridPosition: GridPos

  var direction: CardinalDirection
  var isReady: Bool

  // at least one neighbor that is passable substrate
  // should be derived from neighbor data
  var hasGrowableNeighbor: Bool
}
