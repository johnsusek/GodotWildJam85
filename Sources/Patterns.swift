import SwiftGodot

struct TileSetRegistryEntry {
  let sourceId: Int32
  let atlasCoords: Vector2i
}

class TileSetRegistry {
  var registry: [String: [TileSetRegistryEntry]] = [:]

  // iterate through tileset tilesources (AtlasSources)
  // for each tile fetch TileData and ready custom_data
  // store in registry
  func build(from tileSet: TileSet) {
    for sourceIndex in 0 ..< tileSet.getSourceCount() {
      let sourceId = tileSet.getSourceId(index: sourceIndex)

      guard let source = tileSet.getSource(sourceId: sourceId) as? TileSetAtlasSource else { continue }

      for tileIndex in 0 ..< source.getTilesCount() {
        let tileCoords = source.getTileId(index: tileIndex)

        guard let data = source.getTileData(atlasCoords: tileCoords, alternativeTile: 0),
              data.hasCustomData(layerName: "key"),
              let key = data.getCustomData(layerName: "key").to(String.self),
              !key.isEmpty else { continue }

        registry[key, default: []].append(TileSetRegistryEntry(sourceId: sourceId, atlasCoords: tileCoords))
        print("registered tileset custom data key: \(key)")
      }
    }
  }
}

public enum GodotDefer {
  @discardableResult
  public static func nextFrame(_ f: @escaping () -> Void) -> Bool {
    guard let tree = Engine.getMainLoop() as? SceneTree,
          let timer = tree.createTimer(timeSec: 0.0) else { return false }
    _ = timer.timeout.connect { f() }
    return true
  }
}
