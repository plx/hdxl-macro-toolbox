// swift-tools-version: 6.4
import PackageDescription

let package = Package(
  name: "ToolboxTargetBoundaries",
  platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27), .macCatalyst(.v27)],
  products: [
    .executable(name: "ModelsOnly", targets: ["ModelsOnly"]),
    .executable(name: "BridgeOnly", targets: ["BridgeOnly"]),
    .executable(name: "SyntaxOnly", targets: ["SyntaxOnly"]),
    .executable(name: "GatheringClient", targets: ["GatheringClient"])
  ],
  dependencies: [
    .package(path: "../.."),
    .package(url: "https://github.com/plx/hdxl-macro-transflection.git", revision: "e28d2bb2fb8e957d8c5b4ac36a10d4d8c406e16e"),
    .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "604.0.0")
  ],
  targets: [
    .executableTarget(name: "ModelsOnly", dependencies: [
      .product(name: "MacroToolboxModels", package: "hdxl-macro-toolbox"),
      .product(name: "ValueTransflection", package: "hdxl-macro-transflection")
    ]),
    .executableTarget(name: "BridgeOnly", dependencies: [
      .product(name: "MacroToolboxTransflection", package: "hdxl-macro-toolbox"),
      .product(name: "MacroToolboxModels", package: "hdxl-macro-toolbox"),
      .product(name: "MacroToolboxSyntax", package: "hdxl-macro-toolbox"),
      .product(name: "SwiftSyntax", package: "swift-syntax")
    ]),
    .executableTarget(name: "SyntaxOnly", dependencies: [
      .product(name: "MacroToolboxModels", package: "hdxl-macro-toolbox"),
      .product(name: "MacroToolboxSyntax", package: "hdxl-macro-toolbox"),
      .product(name: "SwiftSyntax", package: "swift-syntax")
    ]),
    .executableTarget(name: "GatheringClient", dependencies: [.product(name: "MacroToolboxMacros", package: "hdxl-macro-toolbox")])
  ],
  swiftLanguageModes: [.v6]
)
