import Foundation
import SwiftGodotPatterns

enum TipsSystem {
  static func apply(_ intents: [PlayerIntent], to model: inout GameModel, populating events: inout [WorldEvent]) {
    for intent in intents {
      switch intent {
      case let .branch(tip, dir): branch(tip, dir, &model, &events)
      case let .extend(tip, dir): extend(tip, dir, &model, &events)
      default: break
      }
    }
  }

  static func branch(_ tipId: UUID, _ dir: CardinalDirection, _ model: inout GameModel, _: inout [WorldEvent]) {
    guard let tip = model.colony.tips.first(where: { $0.id == tipId }) else { return }
    let spawnOn = tip.gridPosition
    let newTip = HyphaTip(
      id: UUID(),
      gridPosition: spawnOn,
      direction: dir,
      isReady: true,
      hasGrowableNeighbor: true
    )
    model.colony.tips.append(newTip)
  }

  static func extend(_ tipId: UUID, _ direction: CardinalDirection, _ model: inout GameModel, _ events: inout [WorldEvent]) {
    guard let tipIdx = model.colony.tips.firstIndex(where: { $0.id == tipId }) else { return }
    let from = model.colony.tips[tipIdx].gridPosition
    guard let to = model.grid.neighbor(in: direction, from: from) else { return }

    // check if stone etc... if so just return

    // substract N/M...

    // put tile into grid data
    let placed = TrunkTile(
      thickness: .thin,
      integrityHp: 2,
      leakFactor: 1.0,
      enzymeTags: [],
      builtTurn: model.state.turn
    )

    model.grid.place(tile: placed, at: to)
    events.append(.trunkPlaced(to, placed))

    // move the tip
    model.colony.tips[tipIdx].gridPosition = to
    events.append(.tipMoved(tipId, from: from, to: to))
  }
}
