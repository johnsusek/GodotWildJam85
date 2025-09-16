import Foundation
import SwiftGodot
import SwiftGodotBuilder
import SwiftGodotPatterns

struct TipsView: GView {
  var colony: Colony
  var grid: SoilGrid

  var body: some GView {
    Node2D$ {
      for tip in colony.tips {
        Sprite2D$()
          .res(\.texture, "tip.png")
          .position(grid.toWorld(tip.gridPosition))
      }
    }
  }
}
