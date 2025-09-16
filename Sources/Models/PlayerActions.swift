enum PlayerActions {
  case extend(dir: CardinalDirection) // costs some M/N depending on substrate, effect: convert target tile to trunk(thin) and move tip there
  case branch(dir: CardinalDirection) // costs a little M/N turn trunk -> tip on same tile (cap via tipsPerTurn/totalTips)
  case thicken // costs N, adds HP and reduces leakfactor
  case exude(dir: CardinalDirection) // costs enzymeCharges, duration # turns, effect: digest wood/bark faster, sterilize bactera, kill pests, etc
  case fruit // at a fruiting site, spend large M/N to plant FruitBody
}
