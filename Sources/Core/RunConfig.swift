import Foundation
import SwiftGodot
import SwiftGodotPatterns

struct RunConfig: Codable {
  // map
  var seed: UInt
  var mapSize: GridSize

  // initial values
  var moisture: Int
  var nutrients: Int
  var enzymeCharges: Int

  // difficulty knobs
  var tipsPerTurn: Int
  var seasonTurnLimit: Int
  var rotDecayEveryNTurns: Int
  var everyNRotHarvested: Int

  // evaporation ramp up
  var startRate: Float
  var step: Float
  var stepEveryNTurns: Int

  // enemies
  var pestEveryNTurns: Int
  var maxPests: Int

  // visibility
  var sightRadius: Int
  var memoryEnabled: Bool

  static let defaultConfig = RunConfig(
    seed: 1,
    mapSize: GridSize(w: 20, h: 12),
    moisture: 100,
    nutrients: 100,
    enzymeCharges: 0,
    tipsPerTurn: 3,
    seasonTurnLimit: 50,
    rotDecayEveryNTurns: 3,
    everyNRotHarvested: 1,
    startRate: 1,
    step: 1,
    stepEveryNTurns: 2,
    pestEveryNTurns: 0,
    maxPests: 0,
    sightRadius: 3,
    memoryEnabled: true
  )
}
