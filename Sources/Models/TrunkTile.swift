struct TrunkTile {
  var thickness: Thickness
  var integrityHp: Int
  var leakFactor: Float // thin leaks more, clay reduces leak, hydrophic tag reduces leak
  var enzymeTags: Set<EnzymeTag>
  var builtTurn: Int
}
