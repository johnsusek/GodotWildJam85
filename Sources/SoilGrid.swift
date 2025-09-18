import Foundation
import SwiftGodot
import SwiftGodotPatterns

struct SoilGrid: Codable, Grid {
  var size: GridSize
  var tileSize: Float
  var substrate: [[Substrate]]
  var trunk: [[HyphaTrunk?]]

  static func makeDefaultGrid() -> SoilGrid {
    var grid = SoilGrid(
      size: GridSize(w: 20, h: 12),
      tileSize: GRID_UNIT,
      substrate: [],
      trunk: [],
    )

    grid.initializeTrunk()
    grid.initializeSubstrate()

    return grid
  }

  mutating func initializeTrunk() {
    // Populate grid.trunk arrays with nils
    for row in 0 ..< size.h {
      trunk.append([])
      for _ in 0 ..< size.w {
        trunk[row].append(nil)
      }
    }
  }

  mutating func initializeSubstrate() {
    let soilTile = Substrate(kind: .soil, nutrientValue: 1, moistureCapacity: 1)
    let rotTile = Substrate(kind: .rot, nutrientValue: 20, moistureCapacity: 1)
    let stoneTile = Substrate(kind: .stone, nutrientValue: 1, moistureCapacity: 1)
    let waterTile = Substrate(kind: .water, nutrientValue: 1, moistureCapacity: 1)

    let totalCells = Double(size.w) * Double(size.h)
    let rotsPercent = 3 / totalCells
    let stonePercent = 10 / totalCells
    let waterPercent = 5 / totalCells

    for row in 0 ..< size.h {
      substrate.append([])

      for _ in 0 ..< size.w {
        var tileToPlace = soilTile

        if Double.random(in: 0 ..< 1) < rotsPercent {
          tileToPlace = rotTile
        }

        if Double.random(in: 0 ..< 1) < stonePercent {
          tileToPlace = stoneTile
        }

        if Double.random(in: 0 ..< 1) < waterPercent {
          tileToPlace = waterTile
        }

        substrate[row].append(tileToPlace)
      }
    }
  }

  mutating func placeTrunk(_ t: HyphaTrunk, at: GridPos) {
    trunk[at.y][at.x] = t
  }

  mutating func placeSubstrate(_ s: Substrate, at: GridPos) {
    substrate[at.y][at.x] = s
  }
}
