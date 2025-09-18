import Foundation
import SwiftGodot
import SwiftGodotBuilder
import SwiftGodotPatterns

let GRID_UNIT: Float = 16.0

struct GameView: GView {
  let store: GameStore<M,I,E>
  let tileSet: TileSet

  var grid: SoilGrid? { store.model.grid }

  init(gameStore: GameStore<M,I,E>) {
    self.store = gameStore
    guard let tileSet = Atlas.tileSets.first else { fatalError("Could not load tileset!") }
    self.tileSet = tileSet
  }

  func buildSoilGrid(_ grid: SoilGrid, _ tml: TileMapLayer) {
    for col in 0 ..< grid.size.w {
      for row in 0 ..< grid.size.h {
        if row > grid.substrate.count - 1 { continue }
        if col > grid.substrate[row].count - 1 { continue }

        let substrate = grid.substrate[row][col]
        Art.placeSubstrate(substrate, at: GridPos(x: col, y: row), in: tml)
      }
    }
  }

  func buildTrunkGrid(_ grid: SoilGrid, _ tml: TileMapLayer) {
    for col in 0 ..< grid.size.w {
      for row in 0 ..< grid.size.h {
        if row > grid.trunk.count - 1 { continue }
        if col > grid.trunk[row].count - 1 { continue }
        guard let _ = grid.trunk[row][col] else { continue }
        guard let entry = Atlas.pick(key: "trunk.thin") else { return }
        tml.setCell(coords: Vector2i(x: Int32(col), y: Int32(row)), sourceId: entry.sourceId, atlasCoords: entry.atlasCoords)
      }
    }
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
            buildSoilGrid(grid, tml)
          }

        TileMapLayer$()
          .tileSet(tileSet)
          .configure { tml in
            guard let grid else { return }
            buildTrunkGrid(grid, tml)
          }
          .onEvent { (tml, e: WorldEvent) in
            guard case let .trunkPlaced(pos, tile) = e else { return }
            guard let grid, let entry = Atlas.pick(key: "trunk.thin") else { return }

            let cells: TypedArray<Vector2i> = [pos.toVector2i()]
//            grid.neighbors4(pos).forEach { cells.append($0.toVector2i()) }
            tml.setCell(coords: pos.toVector2i(), sourceId: entry.sourceId, atlasCoords: entry.atlasCoords)
            tml.setCellsTerrainConnect(cells: cells, terrainSet: 1, terrain: 0)
          }

        for tip in store.model.state.tips {
          Sprite2D$()
            .res(\.texture, "tip.png")
            .position(store.model.grid.toWorld(tip.position))
            .onEvent { (sprite, e: WorldEvent) in
              guard case let .tipMoved(uuid, _, to) = e, let grid else { return }
              guard tip.id == uuid else { return }
              sprite.position = grid.toWorld(to)
            }
        }
      }
      .position(Vector2(0, 48 + 12))
      .onAction("up") { _ in
        store.commit(.extend(dir: .north))
      }
      .onAction("down") { _ in
        store.commit(.extend(dir: .south))
      }
      .onAction("left") { _ in
        store.commit(.extend(dir: .west))
      }
      .onAction("right") { _ in
        store.commit(.extend(dir: .east))
      }
      .onEvent { (_, e: WorldEvent) in
        print("Got event \(e)")
      }
    }
  }
}
