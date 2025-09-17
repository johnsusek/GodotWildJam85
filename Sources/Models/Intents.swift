import Foundation
import SwiftGodotPatterns

enum PlayerIntent {
  case endTurn
  case selectCell(GridPos) // highlight cell, show possible actions
  case extend(tip: UUID, dir: CardinalDirection) // costs some M/N depending on substrate, effect: convert target tile to trunk(thin) and move tip there
  case branch(tip: UUID, dir: CardinalDirection) // costs a little M/N turn trunk -> tip on same tile (cap via tipsPerTurn/totalTips)
  case thicken(pos: GridPos) // costs N, adds HP and reduces leakfactor
  case exude(pos: GridPos, enzyme: EnzymeTag, duration: Int) // costs enzymeCharges, duration # turns, effect: digest wood/bark faster, sterilize bactera, kill pests, etc
  case fruit(pos: GridPos) // at a fruiting site, spend large M/N to plant FruitBody
}
