import Foundation
import SwiftGodotPatterns

struct FruitBody: Codable, Hashable, Identifiable {
  var id: UUID
  var gridPosition: GridPos
  var coveredTrunkCount: Int
  var plantedTurn: Int
  var maturationTurns: Int
  var state: FruitBodyState
  var scoreValue: Int
}
