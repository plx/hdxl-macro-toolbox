// swift-tools-version: 6.4
import PackageDescription

let package = Package(
  name: "TypedConstructionConsumer",
  platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27), .macCatalyst(.v27)],
  products: [.executable(name: "Generate", targets: ["Generate"])],
  dependencies: [
    .package(path: "../.."),
    .package(url: "https://github.com/swiftlang/swift-syntax.git", "604.0.0"..<"605.0.0")
  ],
  targets: [.executableTarget(name: "Generate", dependencies: [
    .product(name: "MacroToolboxModels", package: "hdxl-macro-toolbox"),
    .product(name: "MacroToolboxSyntax", package: "hdxl-macro-toolbox"),
    .product(name: "SwiftSyntax", package: "swift-syntax"),
    .product(name: "SwiftParser", package: "swift-syntax")
  ])],
  swiftLanguageModes: [.v6]
)
