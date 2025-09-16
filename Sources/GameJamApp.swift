import SwiftGodot
import SwiftGodotBuilder
import SwiftGodotKit
import SwiftGodotPatterns
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
    guard let tileSet else { fatalError("Tileset couldnt be loaded!") }
    Atlas.build(from: tileSet)

    let gameModel = GameModel(
      config: RunConfig.defaultConfig,
      state: RunState(turn: 1, evaporationRate: 1, score: 0, outcome: .ongoing, selection: .none, tipsLeft: 0, seasonTurnsRemaining: 30),
      grid: SoilGrid.makeDefaultGrid(),
      colony: Colony.defaultColony,
      pests: [],
      rngSeed: UInt64(Date().timeIntervalSince1970)
    )
    let gameStore = GameStore(model: gameModel)

    let view = GameView(gameStore: gameStore, tileSet: tileSet)
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
