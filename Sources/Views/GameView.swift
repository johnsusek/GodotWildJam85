import Foundation
import SwiftGodot
import SwiftGodotBuilder
import SwiftGodotPatterns

let GRID_UNIT: Float = 16.0

struct GameView: GView {
  let gameStore: GameStore
  let tileSet: TileSet
  let cursor = Ref<Sprite2D>()
  let worldRoot: WorldRoot

  var grid: SoilGrid? { gameStore.model.grid }

  init(gameStore: GameStore, tileSet: TileSet) {
    self.gameStore = gameStore
    self.tileSet = tileSet
    worldRoot = WorldRoot(gameStore: gameStore)
  }

  var body: some GView {
    Node2D$ {
      Sprite2D$()
        .centered(false)
        .position(Vector2(0, 12))
        .res(\.texture, "sky.png")

      GNode<Node2D> {
        TileMapLayer$()
          .tileSet(tileSet)
          .configure { tml in
            guard let grid else { return }
            for col in 0 ..< grid.size.w {
              for row in 0 ..< grid.size.h {
                if row > grid.substrate.count - 1 { continue }
                if col > grid.substrate[row].count - 1 { continue }
                let substrate = grid.substrate[row][col]
                Content.art.placeSubstrate(substrate, at: GridPos(x: col, y: row), in: tml)
              }
            }
          }
          .ref(worldRoot.substrateMap)

        TileMapLayer$()
          .tileSet(tileSet)
          .configure { tml in
            guard let grid else { return }
            for col in 0 ..< grid.size.w {
              for row in 0 ..< grid.size.h {
                if row > grid.trunk.count - 1 { continue }
                if col > grid.trunk[row].count - 1 { continue }
                guard let trunk = grid.trunk[row][col] else { continue }
                Content.art.placeTrunk(trunk, at: GridPos(x: col, y: row), in: tml)
              }
            }
          }
          .ref(worldRoot.trunkMap)

//        TipsView(colony: worldRoot.colony, grid: worldRoot.grid)

        // Sprite2D$()
        //   .res(\.texture, "cursor.png")
        //   .visible(false)
        //   .position(worldRoot.grid.toWorld(GridPos(x: 0, y: 0)))
        //   .ref(cursor)
      }
      .onMouse(.left, when: .released) { node, click in
        var newPos = click.position
        newPos.x -= node.position.x
        newPos.y -= node.position.y
        worldRoot.handleMapClick(at: newPos)
      }
      .position(Vector2(0, 48 + 12))

      CanvasLayer$ {
        Button$().text("Next Turn")
          .anchors(.bottomRight)
          .offsets(.bottomRight, margin: 2)
          .on(\.pressed) { _ in
            worldRoot.handleNextTurn()
          }

        HUDView(
          moisture: gameStore.model.colony.moisture,
          nutrients: gameStore.model.colony.nutrients,
          tipsLeft: gameStore.model.state.tipsLeft ?? 0
        )
      }
    }
  }
}
