// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

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

let macroLibraryDependencies: [Target.Dependency] = [
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
    .iOS(.v18),
    .macOS(.v15),
    .tvOS(.v18),
    .watchOS(.v11)
  ],
  products: [
    .library(
      name: "MacroTransflection",
      targets: [
        "MacroTransflection"
      ]
    ),
    .library(
      name: "MacroTransflectionMacroSupport",
      targets: [
        "MacroTransflectionMacroSupport"
      ]
    ),
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
      url: "https://github.com/apple/swift-syntax.git",
      from: "510.0.0"
    ),
  ],
  targets: [
    // macro-transflection:
    .target(
      name: "MacroTransflection",
      dependencies: []
    ),
    .testTarget(
      name: "MacroTransflectionTests",
      dependencies: [
        "MacroTransflection"
      ]
    ),

    // macro-transflection macro support:
    .target(
      name: "MacroTransflectionMacroSupport",
      dependencies: [
        "MacroTransflection",
        "MacroToolbox"
      ] + macroSupportDependencies
    ),
    .testTarget(
      name: "MacroTransflectionMacroSupportTests",
      dependencies: [
        "MacroTransflectionMacroSupport"
      ]
    ),

    // macro-toolbox related:
    .target(
      name: "MacroToolbox",
      dependencies: [
        "MacroTransflection"
      ] + macroSupportDependencies
    ),
    .testTarget(
      name: "MacroToolboxTests",
      dependencies: [
        "MacroToolbox"
      ]
    ),

    // macro-toolbox-macros related:
    .target(
      name: "MacroToolboxMacros",
      dependencies: [
        "MacroToolbox",
        "MacroToolboxMacrosPlugin"
      ] + macroLibraryDependencies
    ),
    .macro(
      name: "MacroToolboxMacrosPlugin",
      dependencies: [
        "MacroToolbox"
      ] + macroPluginDependencies
    ),
    .executableTarget(
      name: "MacroToolboxMacrosClient",
      dependencies: [
        "MacroToolbox",
        "MacroToolboxMacros"
      ]
    ),
  ],
  swiftLanguageVersions: [
    .v6
  ]
)
