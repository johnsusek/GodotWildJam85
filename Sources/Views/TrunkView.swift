import Foundation
import SwiftGodot
import SwiftGodotBuilder
import SwiftGodotPatterns

struct TrunkView: GView {
  var tileSet: TileSet
  var tileSetRegistry = TileSetRegistry()
  var grid: SoilGrid

  var body: some GView {
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
  }
}
