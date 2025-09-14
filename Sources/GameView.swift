import Foundation
import SwiftGodot
import SwiftGodotBuilder
import SwiftGodotPatterns

struct GameView: GView {
  var colony: Colony
  var tileSet: TileSet?
  var tileSetRegistry = TileSetRegistry()

  let soilTile = SubstrateTile(
    kind: .soil,
    nutrientValue: 1,
    moistureCapacity: 1,
    permeability: 1,
    hazard: SoilHazardFlags.none,
    seenTurn: nil
  )

  var grid = SoilGrid(
    size: GridSize(w: 20, h: 15),
    tileSize: 16,
    substrate: [],
    trunk: [],
    discovered: [],
    visible: [],
    fruitingSites: Set<FruitBody>()
  )

  init() {
    colony = .init(
      moisture: 100,
      nutrients: 100,
      enzymeCharges: 3,
      tips: [],
      enzymesKnown: Set<EnzymeTag>(),
      actionQueue: CommandQueue()
    )


    tileSet = ResourceLoader.load(path: "res://world_tileset.tres") as? TileSet

    if let tileSet {
      tileSetRegistry.build(from: tileSet)
    }

    // Populate grid.substrate arrays
    for row in 0 ..< grid.size.h {
      grid.substrate.append([])
      for _ in 0 ..< grid.size.w {
        grid.substrate[row].append(soilTile)
      }
    }

    // Populate grid.trunk arrays
    for row in 0 ..< grid.size.h {
      grid.trunk.append([])
      for _ in 0 ..< grid.size.w {
        grid.trunk[row].append(nil)
      }
    }

    // Put a starting tile somewhere...
    let startingTile = TrunkTile(
      thickness: .thin,
      integrityHp: 100,
      leakFactor: 0.01,
      enzymeTags: Set<EnzymeTag>(),
      builtTurn: 0
    )

    grid.trunk[7][10] = startingTile

    // Add tips
    colony.tips = [
      .init(id: UUID(), gridPosition: GridPos(x: 10, y: 7), direction: .east, isReady: true, hasGrowableNeighbor: true)
    ]
  }

  var body: some GView {
    return Node2D$ {
      // draw soil tiles
      TileMapLayer$()
        .tileSet(tileSet)
        .configure { tml in
          for col in 0 ..< grid.size.w {
            for row in 0 ..< grid.size.h {
              if row > grid.substrate.count - 1 { continue }
              if col > grid.substrate[row].count - 1 { continue }

              let substrate = grid.substrate[row][col]

              guard let atlasCoordsForType = tileSetRegistry.registry[substrate.kind.rawValue] else { continue }
              guard let firstTile = atlasCoordsForType.first else { return }

              let coords = Vector2i(x: Int32(col), y: Int32(row))

              tml.setCell(
                coords: coords,
                sourceId: firstTile.sourceId,
                atlasCoords: firstTile.atlasCoords
              )
            }
          }
        }

      // draw trunk tiles
      TileMapLayer$()
        .tileSet(tileSet)
        .configure { tml in
          for col in 0 ..< grid.size.w {
            for row in 0 ..< grid.size.h {
              if row > grid.trunk.count - 1 { continue }
              if col > grid.trunk[row].count - 1 { continue }
              guard let trunk = grid.trunk[row][col] else { continue }
              guard let atlasCoordsForType = tileSetRegistry.registry[trunk.thickness.rawValue] else { continue }
              guard let firstTile = atlasCoordsForType.first else { return }

              let coords = Vector2i(x: Int32(col), y: Int32(row))

              tml.setCell(coords: coords, sourceId: firstTile.sourceId, atlasCoords: firstTile.atlasCoords)
            }
          }
        }

      // draw tips
      for tip in colony.tips {
        Sprite2D$()
          .res(\.texture, "n.png")
          .position(grid.toWorld(tip.gridPosition))
      }
    }
  }
}
