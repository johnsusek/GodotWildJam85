import SwiftGodot
import SwiftGodotBuilder

struct HUDView: GView {
  var season: String = "Early Spring"
  var moisture: Int
  var nutrients: Int
  var tipsLeft: Int

  var body: some GView {
    Control$ {
      Label$().text(season)
        .modulate(Color(code: "#EE1"))
        .anchors(.topLeft)
        .offsets(.topLeft)

      // Action queue
//      HBoxContainer$ {
//        Button$().text("> Extend")
//        Button$().text("> Extend")
//        Button$().text("> Branch")
//      }
//      .anchors(.bottomLeft)
//      .offset(top: -16 - 3, bottom: -2, left: 3)
//      .alignment(.begin)

      HBoxContainer$ {
        Label$().text("\(tipsLeft) Tips")
          .modulate(Color(code: "#1E1"))

        Label$().text("\(moisture) Moisture")
          .modulate(Color(code: "#11E"))

        Label$().text("\(nutrients) Nutrients")
          .modulate(Color(code: "#F18"))
      }
      .anchors(.topWide)
      .alignment(.end)
    }
  }
}
