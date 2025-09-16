import Foundation
import SwiftGodot
import SwiftGodotBuilder
import SwiftGodotPatterns

struct SubstrateView: GView {
  var tileSet: TileSet
  var tileSetRegistry = TileSetRegistry()
  var grid: SoilGrid
  
  var body: some GView {
    TileMapLayer$()
      .tileSet(tileSet)
      .configure { tml in
        for col in 0 ..< grid.size.w {
          for row in 0 ..< grid.size.h {
            if row > grid.substrate.count - 1 { continue }
            if col > grid.substrate[row].count - 1 { continue }
    
            let substrate = grid.substrate[row][col]
    
            guard let atlasCoordsForType = tileSetRegistry.registry[substrate.kind.rawValue] else { continue }
            guard let randomTile = atlasCoordsForType.randomElement() else { return }

            let coords = Vector2i(x: Int32(col), y: Int32(row))
    
            tml.setCell(
              coords: coords,
              sourceId: randomTile.sourceId,
              atlasCoords: randomTile.atlasCoords
            )
          }
        }
      }

  }
}
