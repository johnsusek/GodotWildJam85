import Foundation
import SwiftGodotPatterns

// events are *facts* about something that has happened, post state change
enum WorldEvent {
  case trunkPlaced(GridPos, TrunkTile)
  case tipMoved(UUID, from: GridPos, to: GridPos)
  case turnAdvanced(Int, Int)
  case cursorMoved(to: GridPos)
}
