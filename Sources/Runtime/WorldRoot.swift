import Foundation
import SwiftGodot
import SwiftGodotBuilder
import SwiftGodotPatterns

@Godot
final class WorldRoot: Object {
  var store: GameStore?
  let substrateMap = Ref<TileMapLayer>()
  let trunkMap = Ref<TileMapLayer>()
  let cursor = Ref<Sprite2D>()

  convenience init(gameStore: GameStore) {
    self.init()
    store = gameStore
    store?.onEvent = { [weak self] event in
      self?.onEvent(event)
    }
  }

  func onEvent(_ event: WorldEvent) {
    print("Received event:", event)

    switch event {
    case let .cursorMoved(pos):
      print("Cursor moved to", pos)
      guard let store else { return }
      guard let cursorNode = cursor.node else { return }
      cursorNode.visible = true
      cursorNode.position = store.model.grid.toWorld(pos)
    case let .trunkPlaced(pos, tile):
      guard let map = trunkMap.node else { return }
      Content.art.placeTrunk(tile, at: pos, in: map)
      print("Placed trunk at", pos)
    case let .turnAdvanced(turn, seasonTurnsRemaining):
      print("turn advanced to \(turn), \(seasonTurnsRemaining) turns left in season")
    default:
      break
    }
  }

  func handleMapClick(at pos: Vector2) {
    guard let store else { return }
    let cell = store.model.grid.toCell(pos)
    store.commit(.selectCell(cell))

    guard let tip = store.model.colony.tips.first else { return }
    guard let dir = tip.gridPosition.direction(to: cell) else { return }
    store.commit(.extend(tip: tip.id, dir: dir))
  }

  func handleNextTurn() {
    store?.commit(.endTurn)
  }
}
