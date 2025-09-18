import SwiftGodot
import SwiftGodotPatterns

enum Art {
  static func placeSubstrate(_ t: Substrate, at p: GridPos, in map: TileMapLayer) {
    guard let entry = Atlas.pick(key: t.kind.rawValue) else { return }
    map.setCell(
      coords: p.toVector2i(),
      sourceId: entry.sourceId,
      atlasCoords: entry.atlasCoords
    )
  }
}

struct AtlasEntry {
  let sourceId: Int32
  let atlasCoords: Vector2i
}

class Atlas {
  static var registry: [String: [AtlasEntry]] = [:]
  static var tileSets: Set<TileSet> = []

  // iterate through tileset tilesources (AtlasSources)
  // for each tile fetch TileData and ready custom_data
  // store in registry
  static func build(from tileSet: TileSet) {
    tileSets.insert(tileSet)

    for sourceIndex in 0 ..< tileSet.getSourceCount() {
      let sourceId = tileSet.getSourceId(index: sourceIndex)

      guard let source = tileSet.getSource(sourceId: sourceId) as? TileSetAtlasSource else { continue }

      for tileIndex in 0 ..< source.getTilesCount() {
        let tileCoords = source.getTileId(index: tileIndex)

        guard let data = source.getTileData(atlasCoords: tileCoords, alternativeTile: 0),
              data.hasCustomData(layerName: "key"),
              let key = data.getCustomData(layerName: "key").to(String.self),
              !key.isEmpty else { continue }

        registry[key, default: []].append(AtlasEntry(sourceId: sourceId, atlasCoords: tileCoords))
      }
    }
  }

  static func pick(key: String) -> AtlasEntry? {
    guard let atlasCoordsForType = registry[key] else { return nil }
    return atlasCoordsForType.randomElement()
  }
}
