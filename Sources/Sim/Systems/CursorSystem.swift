enum CursorSystem {
  static func apply(_ intents: [PlayerIntent], to _: inout GameModel, populating events: inout [WorldEvent]) {
    for intent in intents {
      switch intent {
      case let .selectCell(pos):
        events.append(.cursorMoved(to: pos))
      default:
        break
      }
    }
  }
}
