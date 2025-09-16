import Foundation
import SwiftGodotPatterns

// messages to views about what changed
enum WorldMessage {
  case trunkPlaced(GridPos, TrunkTile)
  case tipMoved(UUID, from: GridPos, to: GridPos)
  case turnAdvanced(Int, Int)
}

enum PlayerAction {
  case extend(tip: UUID, dir: CardinalDirection) // costs some M/N depending on substrate, effect: convert target tile to trunk(thin) and move tip there
  case branch(tip: UUID, dir: CardinalDirection) // costs a little M/N turn trunk -> tip on same tile (cap via tipsPerTurn/totalTips)
  case thicken(pos: GridPos) // costs N, adds HP and reduces leakfactor
  case exude(pos: GridPos, enzyme: EnzymeTag, duration: Int) // costs enzymeCharges, duration # turns, effect: digest wood/bark faster, sterilize bactera, kill pests, etc
  case fruit(pos: GridPos) // at a fruiting site, spend large M/N to plant FruitBody
}

// actions + model -> new state
enum ActionSystem {
  static func apply(_ actions: [PlayerAction], _ model: inout GameModel, _ messages: inout [WorldMessage]) {
    for action in actions {
      switch action {
      case let .branch(tip, dir): branch(tip, dir, &model, &messages)
      case let .extend(tip, dir): extend(tip, dir, &model, &messages)
      default: break
      }
    }
  }

  static func branch(_ tipId: UUID, _ dir: CardinalDirection, _ model: inout GameModel, _: inout [WorldMessage]) {
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

  static func extend(_ tipId: UUID, _ direction: CardinalDirection, _ model: inout GameModel, _ messages: inout [WorldMessage]) {
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

    // prepare a Message for anyone who cares abt this
    // (this is typically where imperative code would intermingle
    //  node/view updates with data and the beginning of unmaintainability)
    // this is *core* to writing SGB games properly, any data updates with side-effects
    // are turned into messages we just call (later) with onMessage, and
    // anyone who cares can subscribe to that - we don't have to track that in here
    messages.append(.trunkPlaced(to, placed))

    // move the tip
    model.colony.tips[tipIdx].gridPosition = to
    messages.append(.tipMoved(tipId, from: from, to: to))
  }
}
