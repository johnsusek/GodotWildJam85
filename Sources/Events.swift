import Foundation
import SwiftGodotPatterns

enum PlayerIntent {
  case extend(dir: CardinalDirection)
}

enum WorldEvent {
  case trunkPlaced(GridPos, HyphaTrunk)
  case tipMoved(UUID, from: GridPos, to: GridPos)
}
