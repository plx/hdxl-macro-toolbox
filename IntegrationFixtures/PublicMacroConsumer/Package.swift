// swift-tools-version: 6.4
import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "PublicMacroConsumer",
  platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27), .macCatalyst(.v27)],
  products: [
    .library(name: "FixtureOptionsModels", targets: ["FixtureOptionsModels"]),
    .library(name: "FixtureMacros", targets: ["FixtureMacros"]),
    .executable(name: "FixtureClient", targets: ["FixtureClient"])
  ],
  dependencies: [
    .package(path: "../.."),
    .package(url: "https://github.com/plx/hdxl-macro-transflection.git", revision: "be93e17e023b72e6c72188193ad698d8d13b7d44"),
    .package(url: "https://github.com/swiftlang/swift-syntax.git", "604.0.0"..<"605.0.0")
  ],
  targets: [
    .target(name: "FixtureOptionsModels", dependencies: [
      .product(name: "MacroToolboxModels", package: "hdxl-macro-toolbox"),
      .product(name: "ValueTransflection", package: "hdxl-macro-transflection")
    ]),
    .target(name: "FixtureMacros", dependencies: ["FixtureOptionsModels", "FixturePlugin"]),
    .macro(name: "FixturePlugin", dependencies: [
      "FixtureOptionsModels",
      .product(name: "MacroToolboxModels", package: "hdxl-macro-toolbox"),
      .product(name: "MacroToolboxSyntax", package: "hdxl-macro-toolbox"),
      .product(name: "MacroToolbox", package: "hdxl-macro-toolbox"),
      .product(name: "MacroToolboxTransflection", package: "hdxl-macro-toolbox"),
      .product(name: "SwiftSyntax", package: "swift-syntax"),
      .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
      .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
      .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      .product(name: "SwiftDiagnostics", package: "swift-syntax")
    ]),
    .target(name: "FixtureExamples", dependencies: ["FixtureMacros", "FixtureOptionsModels"]),
    .executableTarget(name: "FixtureClient", dependencies: ["FixtureExamples", "FixtureMacros", "FixtureOptionsModels"]),
    .testTarget(name: "FixtureHostTests", dependencies: [
      "FixturePlugin", "FixtureOptionsModels",
      .product(name: "MacroToolboxModels", package: "hdxl-macro-toolbox"),
      .product(name: "MacroToolboxSyntax", package: "hdxl-macro-toolbox"),
      .product(name: "MacroToolbox", package: "hdxl-macro-toolbox"),
      .product(name: "MacroToolboxTransflection", package: "hdxl-macro-toolbox"),
      .product(name: "ValueTransflection", package: "hdxl-macro-transflection"),
      .product(name: "SwiftSyntax", package: "swift-syntax"),
      .product(name: "SwiftParser", package: "swift-syntax"),
      .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
      .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
      .product(name: "SwiftDiagnostics", package: "swift-syntax")
    ])
  ],
  swiftLanguageModes: [.v6]
)
