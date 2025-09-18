import Foundation
import SwiftGodot
import SwiftGodotBuilder
import SwiftGodotPatterns

enum Mycolony {
  static func initStore() -> GameStore<M,I,E> {
    let model = Mycolony.createModel()

    let store = GameStore<M,I,E>(model: model)

    store.register { TipsSystem.apply($0, to: &$1, populating: &$2) }

    return store
  }

  static func createModel() -> GameModel {
    var grid = SoilGrid.makeDefaultGrid()

    let startX = Int.random(in: 0 ..< grid.size.w)
    let startY = Int.random(in: 0 ..< grid.size.h)
    let startingPos = GridPos(x: startX, y: startY)

    let trunk = HyphaTrunk(builtTurn: 1)
    grid.placeTrunk(trunk, at: startingPos)

    let defaultTip = HyphaTip(id: UUID(), position: startingPos)

    let gameModel = GameModel(
      seed: 1,
      mapSize: GridSize(w: 20, h: 12),
      state: RunState(turn: 0, tips: [defaultTip], activeTip: defaultTip.id, moisture: 100),
      grid: grid,
    )

    return gameModel
  }
  
  static func loadResources() {
    let tileSet = ResourceLoader.load(path: "res://tileset.tres") as? TileSet
    guard let tileSet else { fatalError("Tileset couldnt be loaded!") }
    Atlas.build(from: tileSet)
  }

  static func installActions() {
    Actions {
      Action("up") {
        Key(.w)
        Key(.up)
      }
      Action("down") {
        Key(.s)
        Key(.down)
      }
      Action("left") {
        Key(.a)
        Key(.left)
      }
      Action("right") {
        Key(.d)
        Key(.right)
      }
      Action("confirm") {
        Key(.space)
        Key(.enter)
      }
      Action("end_turn") {
        Key(.e)
      }
    }.install()
  }
}
