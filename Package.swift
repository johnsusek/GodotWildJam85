// swift-tools-version: 5.9
// This is just for vscode syntax highlighting/autocompletion

import PackageDescription

let package = Package(
  name: "MyGame",
  platforms: [.macOS(.v14)],
  products: [
    .library(name: "MyGame", targets: ["MyGame"]),
  ],

  dependencies: [
    .package(url: "https://github.com/migueldeicaza/SwiftGodot", revision: "20d2d7a35d2ad392ec556219ea004da14ab7c1d4"),
    .package(url: "https://github.com/migueldeicaza/SwiftGodotKit", revision: "7d7edf2f7701ef0328aece07399ba878241c62f0"),
    .package(path: "../../SwiftGodotPatterns"),
    .package(path: "../../SwiftGodotBuilder"),
  ],

  targets: [
    .target(
      name: "MyGame",
      dependencies: ["SwiftGodot", "SwiftGodotKit", "SwiftGodotBuilder", "SwiftGodotPatterns"],
    ),
  ]
)
