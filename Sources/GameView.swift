import SwiftGodot
import SwiftGodotBuilder

struct GameView: GView {
  var body: some GView {
    Node2D$ {
      Label$()
        .text("Hey!")
    }
  }
}
