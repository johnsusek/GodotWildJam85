import Foundation
import SwiftGodot
import SwiftGodotBuilder
import SwiftGodotPatterns

let GRID_UNIT: Float = 16.0

struct GameView: GView {
  let worldRoot: WorldRoot
  let tileSet: TileSet
  let tileSetRegistry: TileSetRegistry
  let cursor = Ref<Sprite2D>()

  var body: some GView {
    Node2D$ {
        Sprite2D$()
          .centered(false)
          .position(Vector2(0, 12))
          .res(\.texture, "sky.png")

      GNode<WorldRoot> {
        SubstrateView(tileSet: tileSet, tileSetRegistry: tileSetRegistry, grid: worldRoot.grid)
        TrunkView(tileSet: tileSet, tileSetRegistry: tileSetRegistry, grid: worldRoot.grid)
//        TipsView(colony: worldRoot.colony, grid: worldRoot.grid)

        Sprite2D$()
          .res(\.texture, "cursor.png")
          .visible(false)
          .position(worldRoot.grid.toWorld(GridPos(x: 0, y: 0)))
          .ref(cursor)
      }
      .onMouse(.left, when: .released) { node, click in
        var newPos = click.position
        newPos.x -= node.position.x
        newPos.y -= node.position.y
        let coords = worldRoot.grid.toCell(newPos)

        if coords.x < 0 || coords.y < 0 || coords.x > worldRoot.grid.size.w - 1 || coords.y > worldRoot.grid.size.h - 1 { return }
        print(coords)

//          if worldRoot.grid.trunk[coords.y][coords.x] != nil {
          guard let cursor = cursor.node else { return }

          worldRoot.runState.cursorPosition = coords
          // mark ui dirty, next frame gets redrawn

          cursor.visible = true
          cursor.position = worldRoot.grid.toWorld(coords)
//          }
      }
      .position(Vector2(0, 48 + 12))

      CanvasLayer$ {
        HUDView(
          season: worldRoot.season,
          moisture: worldRoot.colony.moisture,
          nutrients: worldRoot.colony.nutrients,
          tipsLeft: worldRoot.runState.tipsLeft
        )
      }
    }
  }
}
