import Foundation
import SwiftGodotPatterns

struct GameModel {
  var config: RunConfig
  var state: RunState
  var grid: SoilGrid
  var colony: Colony
  var pests: [Pest]
  var fruitBodies: Set<FruitBody> = []
  var rngSeed: UInt64
}

struct Pest: Codable, Hashable {
  var id: UUID
  var position: GridPos
  var target: GridPos?
}

enum RunOutcome: Codable { case ongoing, won, lostEvap, lostSeason, lostIntegrity }

enum Selection: Codable { case none, trunk(UUID), tip(UUID), fruitSite(UUID) }

struct RunState: Codable {
  var turn: Int
  var evaporationRate: Float
  var score: Int
  var outcome: RunOutcome
  var selection: Selection
  var cursorPosition: GridPos?
  var tipsLeft: Int
  var seasonTurnsRemaining: Int
}
