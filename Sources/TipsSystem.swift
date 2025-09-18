import Foundation
import SwiftGodotPatterns

enum TipsSystem {
  static func apply(_ intents: [PlayerIntent], to model: inout GameModel, populating events: inout [WorldEvent]) {
    for intent in intents {
      switch intent {
      case let .extend(dir): extend(dir, &model, &events)
      }
    }
  }

  static func extend(_ direction: CardinalDirection, _ model: inout GameModel, _ events: inout [WorldEvent]) {
    guard let tipIdx = model.state.tips.firstIndex(where: { $0.id == model.state.activeTip }) else { return }

    // get the tip's position
    let from = model.state.tips[tipIdx].position

    // calc new pos
    guard let to = model.grid.neighbor(in: direction, from: from) else { return }

    // put trunk into data structure at new pos
    let trunk = HyphaTrunk(builtTurn: model.state.turn)
    model.grid.placeTrunk(trunk, at: to)

    // when a trunk extends, the tip moves with it
    model.state.tips[tipIdx].move(to: to)

    // send event so visuals know
    events.append(.trunkPlaced(to, trunk))
    events.append(.tipMoved(model.state.tips[tipIdx].id, from: from, to: to))
  }
}
