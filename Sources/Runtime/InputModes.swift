import Foundation
import SwiftGodotPatterns

enum UIMode: String { case idle, selecting, targeting, confirming }

final class InputModes {
  let machine = StateMachine()
  var selection: Selection = .none
  var pending: PlayerIntent?

  init() {
    machine.add(UIMode.idle, .init())
  }
}
