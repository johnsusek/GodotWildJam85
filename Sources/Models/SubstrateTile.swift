struct SubstrateTile: Codable {
  var kind: SoilSubstrate
  var nutrientValue: Int // for rot
  var decayTimer: Int? // for rot
  var moistureCapacity: Int // for water
  var permeability: Float // movement ease
  var hazard: Set<SoilHazardFlags>?
  var seenTurn: Int? // last fully visible turn
}
