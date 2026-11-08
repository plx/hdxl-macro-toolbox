# hdxl-macro-toolbox

Reusable model policies, syntax utilities, and macro expansion support for Swift macro authors.
The products follow the compiler-host boundary: ordinary code shares pure models, while plugins
use syntax and expansion contexts.

## Products and imports

| Product / import | Purpose | Direct dependencies |
| --- | --- | --- |
| `MacroToolboxModels` | Visibility, inlinability, argument and attachment policies; pure helpers | Swift standard library only |
| `MacroToolboxSyntax` | Structural navigation, syntax-bearing descriptors, construction and formatting | Models, SwiftSyntax, SwiftParser, SwiftSyntaxBuilder, SwiftBasicFormat |
| `MacroToolbox` | Contextualized macro protocols, diagnostics and expansion orchestration | Models, Syntax, SwiftSyntax macro/diagnostic products |
| `MacroToolboxMacros` | Four public gathering macro declarations | Compiler-host plugin only; signatures use standard-library types |

Use `.product(name: "MacroToolboxModels", package: "hdxl-macro-toolbox")` for an application or
shared configuration target. The same models can be imported by a plugin. Do not make the model
target depend on the host toolbox just because a plugin consumes its values.

```swift
import MacroToolboxModels

struct Options {
  var memberVisibility: VisibilityLevel
  var arguments: [ArgumentLocationDescriptor]
}
```

A host consumer can use structural/generation utilities without adopting contextualized macros:

```swift
import MacroToolboxModels
import MacroToolboxSyntax
import SwiftSyntax

let declaration = try StructDeclSyntax.onlyParsed(from: "public struct Example { var count: Int }")
let access = declaration.modifiers.visibilityLevel
let properties = declaration.storedPropertyDescriptors
```

`MacroToolboxSyntax` has no dependency on `MacroToolbox`, `SwiftSyntaxMacros`, or
`SwiftCompilerPlugin`. Its existing public `validated()`, `eraseToValidated*()`, and string-based
construction APIs use SwiftSyntaxBuilder's parsing and validation behavior. **SwiftDiagnostics
and SwiftParserDiagnostics are therefore present transitively through SwiftSyntaxBuilder**;
validation failures retain its diagnostic text. This is a host syntax API boundary, not a model
or declaration-wrapper dependency. Syntax consumers need no macro expansion context.

For contextualized expansion and diagnostic reporting, import `MacroToolbox`. It remains the
supported umbrella and re-exports the Models and Syntax modules. Focused imports are preferred
when the larger framework is unnecessary. Moved symbols now have their focused module identity;
module-qualified references such as `MacroToolbox.VisibilityLevel` should migrate to
`MacroToolboxModels.VisibilityLevel`. No per-symbol forwarding layer is provided.

## Gathering macros

Ordinary clients import only `MacroToolboxMacros`:

```swift
import MacroToolboxMacros
let add: (Int, Int) -> Int = { $0 + $1 }
let values = #gatherEvaluations(yielding: Int.self, arguments: (2, 3), functions: [add])
```

`gatherEvaluations`, `gatherEvaluationsWithFlattening`, `gatherThrowingEvaluations`, and
`gatherThrowingEvaluationsWithFlattening` each resolve to a registered implementation. The
plugin legitimately builds the syntax and orchestration libraries for the compiler host; the
ordinary wrapper/client does not compile or link them into its runtime closure. Package
resolution/downloading SwiftSyntax alone is not evidence of runtime leakage. Unfinished
automatic-inlining macros remain unpublished.

## Ownership and bootstrap

See the checked-in [target inventory](Validation/TargetInventory.md) and
[source move inventory](Validation/target-source-moves.json). Pure textual representations stay
with models; `+Syntax` conversions and source-bearing descriptors belong to Syntax. Existing
analysis/generation behavior is preserved by the split.

Transflection lives in the separate
[`hdxl-macro-transflection`](https://github.com/plx/hdxl-macro-transflection) package. The normal
route converts supported syntax to its syntax-free representation and then constructs the
requested value; explicitly selected asymmetric decoding is a separate capability. The future
`MacroToolboxTransflection` bridge and handwritten option witnesses are tracked by
[TB-04](https://github.com/plx/hdxl-macro-toolbox/issues/8); no placeholder product is added here.
Toolbox and the transflection core never depend on the downstream derivation-macros package.
Any foundational conformance needed to build the generator must be handwritten.

## Validation

Run `swift package resolve`, `swift package dump-package`,
`swift package show-dependencies --format json`, `swift build`, and `swift test`.

```sh
python3 Validation/check_target_graph.py --self-test
python3 IntegrationFixtures/TargetBoundaries/validate.py --output /tmp/toolbox-boundaries
```

The graph guard checks each sensitive target's allowed edges and model/syntax/wrapper imports.
Its mutation checks prove it rejects prohibited ordinary/reverse dependencies. To check an
actual transflection-core manifest too, add `--core-manifest /path/to/core-dump-package.json`;
without it the core mutation checks use a synthetic contract graph and do not claim to inspect
an external checkout.

The independent fixture compiles a model-only client before any syntax product, a syntax-only
host client using public imports, and a client exercising all four gathering declarations. It
retains verbose compiler/linker logs, actual SwiftPM target graphs with host-tool edges separated,
runtime object/dylib inputs, and an isolated model import/dependency scan. The root package does
not depend on this fixture. Use a new output directory for each run.

## Supported development environment

Use Swift 6.4, Swift language mode 6, and SwiftSyntax 604.x. The deployment minimum is 27.0 on
macOS, iOS, tvOS, watchOS, visionOS, and Mac Catalyst. This is a single-toolchain development
baseline; older compilers and Linux are not supported by this validation contract. The fixture
runs on macOS; that does not claim execution on other deployment destinations.
