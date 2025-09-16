import SwiftGodot
import SwiftGodotBuilder
import SwiftGodotPatterns
import SwiftGodotKit
import SwiftUI

@main
struct GameJamApp: App {
  @State var app = GodotApp(packFile: "game.pck")

  var body: some Scene {
    Window("Game Jam App", id: "main") {
      GodotAppView()
        .environment(\.godotApp, app)
        .task {
          await startup()
        }
    }
  }

  func startup() async {
    await pollForAppInstance()
    let sceneTree = await pollForSceneTree()

    GodotRegistry.append(contentsOf: [GInputRelay.self, WorldRoot.self])
    GodotRegistry.flush()

    // These aren't in worldroot b/c they *aren't potentially needed every frame*
    // this should always separate our game classes & views/init data
    let tileSet = ResourceLoader.load(path: "res://world_tileset.tres") as? TileSet
    let tileSetRegistry = TileSetRegistry()
    guard let tileSet else { fatalError("Tileset couldnt be loaded!") }
    tileSetRegistry.build(from: tileSet)

    let worldRoot = WorldRoot()
    worldRoot.populateGrid()
    let view = GameView(worldRoot: worldRoot, tileSet: tileSet, tileSetRegistry: tileSetRegistry)
    let node = view.toNode()

    sceneTree.root?.addChild(node: node)
  }

  func pollForAppInstance() async {
    for _ in 0 ..< 300 {
      if app.instance != nil { return }
      try? await Task.sleep(nanoseconds: 200_000_000)
    }

    fatalError("No SwiftGodotKit app instance - cannot continue!")
  }
}

private func pollForSceneTree() async -> SceneTree {
  for _ in 0 ..< 300 {
    if let tree = Engine.getSceneTree() { return tree }
    try? await Task.sleep(nanoseconds: 200_000_000)
  }
  fatalError("No scene tree or scene root - cannot continue!")
}

