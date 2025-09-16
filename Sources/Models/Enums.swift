// Hard clock: Season, Soft clock: Evaporation (put these in HUD)

// Resource models:
// M - Moisture
// N - Nutrients
// moisture model - leak rate
// moisture is mostly global
// each water-adjacent tile produces M/turn
// each trunk tile consumes leakFactor per turn
// expansions have M/N costs; evaporation raises leakFactor globally
// nutrient model - rot tiles
// eat rot-adjacent tile produces N/turn

enum SoilSubstrate: String {
  case soil = "substrate.soil"
  case rot = "substrate.rot"
  case root = "substrate.root"
  case water = "substrate.water"
  case stone = "substrate.stone"
  case clay = "substrate.clay"
}

enum SoilHazardFlags { case none, bacteria, pest }

enum VisibilityState { case undiscovered, remembered, visible }

enum FruitBodyState { case growing, mature }

enum Thickness: String {
  case thin = "trunk.thin"
  case thick = "trunk.thick"
}

enum EnzymeTag {
  case cellulase // good on wood/rot, weak vs pests
  case laccase // good on bark/root, boosts bacteria if overused (?)
  case chitinase // controls pests, weak on dense wood
}

enum CardinalDirection: String, CaseIterable { case north, south, east, west }

