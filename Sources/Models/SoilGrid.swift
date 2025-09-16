import Foundation
import SwiftGodot
import SwiftGodotPatterns

struct SoilGrid: Grid {
  var size: GridSize
  var tileSize: Float
  var substrate: [[SubstrateTile]]
  var trunk: [[TrunkTile?]]
  var discovered: [[Bool]]
  var visible: [[Bool]]
  var fruitingSites: Set<FruitBody>

  mutating func populate(with substrateTile: SubstrateTile) {
    // Populate grid.trunk arrays
    for row in 0 ..< size.h {
      trunk.append([])
      for _ in 0 ..< size.w {
        trunk[row].append(nil)
      }
    }

    // Populate grid.substrate arrays with soil tiles
    for row in 0 ..< size.h {
      substrate.append([])
      for _ in 0 ..< size.w {
        substrate[row].append(substrateTile)
      }
    }
  }

  mutating func place(tile: TrunkTile, at: GridPos) {
    trunk[at.y][at.x] = tile
  }
}

func randomDirs() -> [GridPos] {
  // draw 3 tips in random cardinal dirs
  var dirs = CardinalDirection.allCases
  dirs.remove(at: Int.random(in: 0 ..< CardinalDirection.allCases.count))
  var vs: [GridPos] = []

  for direction in dirs {
    switch direction {
    case .east:
      vs.append(GridPos(x: 1, y: 0))
    case .north:
      vs.append(GridPos(x: 0, y: -1))
    case .west:
      vs.append(GridPos(x: -1, y: 0))
    case .south:
      vs.append(GridPos(x: 0, y: 1))
    }
  }

  return vs
}
