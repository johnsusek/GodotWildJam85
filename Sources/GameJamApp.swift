import SwiftGodot
import SwiftGodotBuilder
import SwiftGodotKit
import SwiftGodotPatterns
import SwiftUI

typealias M = GameModel
typealias I = PlayerIntent
typealias E = WorldEvent

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

    GodotRegistry.append(contentsOf: [GInputRelay.self, GEventRelay.self])
    GodotRegistry.flush()

    Mycolony.installActions()
    Mycolony.loadResources()

    let store = Mycolony.initStore()
    let view = GameView(gameStore: store)
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
