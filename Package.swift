// swift-tools-version: 6.4

import PackageDescription
import CompilerPluginSupport

// MARK: Macro-Related Dependencies

let macroPluginDependencies: [Target.Dependency] = [
  .product(
    name: "SwiftSyntax",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftParser",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftSyntaxBuilder",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftSyntaxMacros",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftCompilerPlugin",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftDiagnostics",
    package: "swift-syntax"
  )
]

let syntaxDependencies: [Target.Dependency] = [
  .product(name: "SwiftSyntax", package: "swift-syntax"),
  .product(name: "SwiftParser", package: "swift-syntax"),
  .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
  .product(name: "SwiftBasicFormat", package: "swift-syntax")
]

let macroSupportDependencies: [Target.Dependency] = [
  .product(
    name: "SwiftSyntax",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftParser",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftSyntaxBuilder",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftSyntaxMacros",
    package: "swift-syntax"
  ),
  .product(
    name: "SwiftDiagnostics",
    package: "swift-syntax"
  )
]


let package = Package(
  name: "hdxl-macro-toolbox",
  platforms: [
    .iOS(.v27),
    .macOS(.v27),
    .tvOS(.v27),
    .watchOS(.v27),
    .macCatalyst(.v27),
    .visionOS(.v27)
  ],
  products: [
    .library(name: "MacroToolboxModels", targets: ["MacroToolboxModels"]),
    .library(name: "MacroToolboxSyntax", targets: ["MacroToolboxSyntax"]),
    .library(
      name: "MacroToolbox",
      targets: [
        "MacroToolbox"
      ]
    ),
    .library(
      name: "MacroToolboxMacros",
      targets: [
        "MacroToolboxMacros"
      ]
    ),
    .executable(
      name: "MacroToolboxMacrosClient",
      targets: ["MacroToolboxMacrosClient"]
    ),
  ],
  dependencies: [
    // for documentation-rendering support
    .package(
      url: "https://github.com/apple/swift-docc-plugin",
      from: "1.3.0"
    ),
    .package(
      url: "https://github.com/swiftlang/swift-syntax.git",
      from: "604.0.0"
    ),
  ],
  targets: [
    .target(name: "MacroToolboxModels", dependencies: []),
    .target(name: "MacroToolboxSyntax", dependencies: ["MacroToolboxModels"] + syntaxDependencies),
    .target(
      name: "MacroToolbox",
      dependencies: ["MacroToolboxModels", "MacroToolboxSyntax"] + macroSupportDependencies
    ),
    .testTarget(
      name: "MacroToolboxTests",
      dependencies: [
        "MacroToolboxModels",
        "MacroToolboxSyntax",
        "MacroToolbox",
        "MacroToolboxTestSupport"
      ]
    ),
    // Public API consumer: no @testable import or macro-orchestration dependency.
    .testTarget(
      name: "FieldAnalysisPublicTests",
      dependencies: [
        "MacroToolboxModels", "MacroToolboxSyntax",
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftParser", package: "swift-syntax")
      ]
    ),

    .target(
      name: "MacroToolboxMacros",
      dependencies: [
        "MacroToolboxMacrosPlugin"
      ]
    ),
    .macro(
      name: "MacroToolboxMacrosPlugin",
      dependencies: [
        "MacroToolboxModels",
        "MacroToolboxSyntax",
        "MacroToolbox"
      ] + macroPluginDependencies
    ),
    .executableTarget(
      name: "MacroToolboxMacrosClient",
      dependencies: [
        "MacroToolboxMacros"
      ]
    ),
    
    // common test-tags
    .target(
      name: "MacroToolboxTestSupport",
      dependencies: [ ]
    )
  ],
  swiftLanguageModes: [
    .v6
  ]
)
