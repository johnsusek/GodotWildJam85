import Foundation
import SwiftGodot
import SwiftGodotBuilder
import SwiftGodotPatterns

@Godot
final class WorldRoot: Object {
  var store: GameStore?
  let substrateMap = Ref<TileMapLayer>()
  let trunkMap = Ref<TileMapLayer>()

  convenience init(gameStore: GameStore) {
    self.init()
    store = gameStore

    print("world root ready, store is", store?.model)
    // respond to change in a change state in state described by a message like trunkPlaced
    store?.onMessage = { [weak self] message in
      print("Received message:", message)
      guard let self else { return }
      switch message {
      case let .trunkPlaced(pos, tile):
        guard let map = trunkMap.node else { return }
        Content.art.placeTrunk(tile, at: pos, in: map)
      case let .turnAdvanced(turn, seasonTurnsRemaining):
        print("turn advanced to \(turn), \(seasonTurnsRemaining) turns left in season")
      default:
        break
      }
    }
  }

  func handleMapClick(at pos: Vector2) {
    print("got click at", pos)
    guard let store else { return }
    let cell = store.model.grid.toCell(pos)
    guard let tip = store.model.colony.tips.first else { return }
    guard let dir = tip.gridPosition.direction(to: cell) else { return }
    store.dispatch(.extend(tip: tip.id, dir: dir))
  }

  func handleNextTurn() {
    store?.stepTurn()
  }
}
