enum SeasonSystem {
  static func apply(_ intents: [PlayerIntent], to model: inout GameModel, populating events: inout [WorldEvent]) {
    for intent in intents {
      switch intent {
      case .endTurn:
        model.state.turn += 1
        model.state.seasonTurnsRemaining = max(0, model.state.seasonTurnsRemaining - 1)
        events.append(.turnAdvanced(model.state.turn, model.state.seasonTurnsRemaining))
      default:
        break
      }
    }
  }
}
