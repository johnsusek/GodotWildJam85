import Foundation
import SwiftGodotPatterns

// store owns the live model, applies systems in order, and emits events that your views consume

final class GameStore {
  private(set) var model: GameModel
  private var intents: [PlayerIntent] = []

  var onEvent: ((WorldEvent) -> Void)?
  var onEvents: (([WorldEvent]) -> Void)?

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

  func commit(_ intent: PlayerIntent) {
    intents.append(intent)
    pump()
  }

  func pump() {
    // gets populated from any intents processed this cycle
    // (not every frame, pump() is only called when a player intent is committed)
    var events: [WorldEvent] = []

    // At this point in execution, the model state is exactly as it was when the player
    // issued their intents

    TipsSystem.apply(intents, to: &model, populating: &events)
    SeasonSystem.apply(intents, to: &model, populating: &events)
    CursorSystem.apply(intents, to: &model, populating: &events)

    // once the systems have used the intents, we have no more use for them
    // because all side effects are now encoded in events
    intents.removeAll()

    // At this point in execution, the model state has been updated from the player's actions
    // but no side-effects (node updates, sound effects, etc) have happened yet

    // send events to listeners to handle side-effects
    if let onEvents = onEvents {
      onEvents(events)
    } else if let onEvent = onEvent {
      events.forEach(onEvent)
    }

    for event in events {
      print("Processed event:", event)
    }
  }
}
