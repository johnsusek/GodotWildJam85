import Foundation
import SwiftGodotPatterns

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
