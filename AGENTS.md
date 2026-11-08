# Agent Guide to `hdxl-macro-toolbox`

## Supported development environment

Use Swift 6.4, Swift language mode 6, and SwiftSyntax 604.x. The deployment
minimum is 27.0 on macOS, iOS, tvOS, watchOS, visionOS, and Mac Catalyst.
This is a single-toolchain development baseline; older compilers and Linux
are not supported by this validation contract. Compiler-host plugins build
SwiftSyntax separately from ordinary runtime model code.

Run `swift package resolve`, `swift package dump-package`,
`swift package show-dependencies --format json`, `swift build`, and `swift test`
with the supported macOS toolchain. Preserve the syntax-free value layer and
never add a dependency from a lower foundation package to derivation.

`python3 Validation/validate_public_consumers.py --output <new-directory>` is the complete
public-consumer gate: five root checks, reverse-edge/target graph mutations, and independent
TargetBoundaries, TypedConstructionConsumer, and PublicMacroConsumer fixtures. Run it for
public API or boundary changes. The fixtures must remain downstream packages, with ordinary
public imports and handwritten option witnesses; never add them to the root target graph.
