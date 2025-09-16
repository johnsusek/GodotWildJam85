import Foundation
import SwiftGodotPatterns

// store owns the live model, applies systems in order, and emits messages that your views consume

final class GameStore {
  private(set) var model: GameModel
  private var pending: [PlayerAction] = []

  var onMessage: ((WorldMessage) -> Void)?
  var onManyMessages: (([WorldMessage]) -> Void)?

  init(model: GameModel) {
    self.model = model

    if let tip = model.colony.tips.first {
      let startingTile = TrunkTile(
        thickness: .thin,
        integrityHp: 100,
        leakFactor: 1,
        enzymeTags: [],
        builtTurn: model.state.turn
      )

      self.model.grid.place(tile: startingTile, at: tip.gridPosition)
    }
  }

  // think vuex/pinia/redux store..
  func dispatch(_ action: PlayerAction) {
    print("Dispatching action:", action)
    pending.append(action)
  }

  func stepTurn() {
    var messages: [WorldMessage] = []

    //
    // At this point in execution, the model state is exactly as it was when the player
    // issued their actions
    //

    // each system might use the players' actions differently, and update the model diferently
    // we don't care, just hand it to them:
    // player input actions + data model -> new data model + messages
    ActionSystem.apply(pending, &model, &messages)

    // once the systems have used the actions, we have no more use for them
    // because all side effects are now encoded in the messages
    pending.removeAll()

    // move this into a SeasonSystem or something
    model.state.turn += 1
    model.state.seasonTurnsRemaining = max(0, model.state.seasonTurnsRemaining - 1)
    messages.append(.turnAdvanced(model.state.turn, model.state.seasonTurnsRemaining))

    //
    // At this point in execution, the model state has been updated from the player's actions
    // but no side-effects (node updates, sound effects, etc) have happened yet
    //

    // Here is where onMessage is actually called - still a manual player
    // action like any other imperative code, (in this case they clicked Next Turn),
    // but shuttled through codable data updates
    if let onManyMessages = onManyMessages {
      onManyMessages(messages)
    } else if let onMessage = onMessage {
      messages.forEach(onMessage)
    }

    for message in messages {
      print("Processed message:", message)
    }
  }
}
