import Foundation
import SwiftGodotPatterns

struct GameModel: Codable {
  var seed: UInt
  var mapSize: GridSize
  var state: RunState
  var grid: SoilGrid
}

struct RunState: Codable {
  var turn: Int
  var tips: [HyphaTip]
  var activeTip: UUID
  var moisture: Int
}

struct Substrate: Codable {
  var kind: SoilSubstrate
  var nutrientValue: Int // for rot
  var decayTimer: Int? // for rot
  var moistureCapacity: Int // for water
}

struct HyphaTrunk: Codable {
  var builtTurn: Int
}

struct HyphaTip: Codable, Identifiable {
  var id: UUID
  var position: GridPos

  mutating func move(to: GridPos) {
    position = to
  }
}

enum SoilSubstrate: String, Codable {
  case soil = "substrate.soil"
  case rot = "substrate.rot"
  case water = "substrate.water"
  case stone = "substrate.stone"
}
