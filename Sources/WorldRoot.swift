import Foundation
import SwiftGodot
import SwiftGodotBuilder
import SwiftGodotPatterns
import SwiftGodotKit

enum RunOutcome: Codable { case ongoing, won, lostEvap, lostSeason, lostIntegrity }

enum Selection: Codable { case none, trunk(UUID), tip(UUID), fruitSite(UUID) }

struct RunState: Codable {
  var turn: Int
  var evaporationRate: Float
  var score: Int
  var outcome: RunOutcome
  var selection: Selection
  var cursorPosition: GridPos?
  var tipsLeft: Int
}

@Godot
final class WorldRoot: Node2D {
  var runState = RunState(turn: 1, evaporationRate: 1, score: 0, outcome: .ongoing, selection: .none, tipsLeft: 0)
  let cursor = Ref<Sprite2D>()

  let colony: Colony = .init(
    moisture: 100,
    nutrients: 100,
    enzymeCharges: 3,
    tips: [.init(id: UUID(), gridPosition: GridPos(x: 10, y: 7), direction: .east, isReady: true, hasGrowableNeighbor: true)],
    enzymesKnown: Set<EnzymeTag>(),
    actionQueue: CommandQueue()
  )

  let season = "Early Spring" // derive from seasonTurnsRemaining

  var grid = SoilGrid(
    size: GridSize(w: 20, h: 12),
    tileSize: GRID_UNIT,
    substrate: [],
    trunk: [],
    discovered: [],
    visible: [],
    fruitingSites: Set<FruitBody>()
  )

  let startingTile = TrunkTile(
    thickness: .thin,
    integrityHp: 100,
    leakFactor: 0.01,
    enzymeTags: Set<EnzymeTag>(),
    builtTurn: 0
  )

  override func _ready() {
    print(cursor.node)
  }

  public func populateGrid() {
    let soilTile = SubstrateTile(
      kind: .soil,
      nutrientValue: 1,
      moistureCapacity: 1,
      permeability: 1,
      hazard: nil,
      seenTurn: nil
    )

    grid.populate(with: soilTile)
    grid.place(tile: startingTile, at: GridPos(x: 10, y: 7))
  }

  public func nextTurn() {
    runState.turn += 1
  }

}
