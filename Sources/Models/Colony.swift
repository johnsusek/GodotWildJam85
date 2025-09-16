import SwiftGodotPatterns

struct Colony {
  var moisture: Int // each trunk tile adjacent to water adds per-turn, trunks consume leakFactor, weather/rain events to change (?)
  var nutrients: Int
  var enzymeCharges: Int
  var tips: [HyphaTip]
  var enzymesKnown: Set<EnzymeTag>
  var actionQueue: CommandQueue
}
