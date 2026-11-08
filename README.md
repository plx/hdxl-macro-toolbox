# hdxl-macro-toolbox

Reusable model policies, syntax utilities, and macro expansion support for Swift macro authors.
The products follow the compiler-host boundary: ordinary code shares pure models, while plugins
use syntax and expansion contexts.

## Products and imports

| Product / import | Purpose | Direct dependencies |
| --- | --- | --- |
| `MacroToolboxModels` | Visibility, inlinability, argument and attachment policies; pure helpers and handwritten visibility transflection | ValueTransflection (syntax-free) |
| `MacroToolboxSyntax` | Structural navigation, syntax-bearing descriptors, construction and formatting | Models, SwiftSyntax, SwiftParser, SwiftSyntaxBuilder, SwiftBasicFormat |
| `MacroToolbox` | Contextualized macro protocols, diagnostics and expansion orchestration | Models, Syntax, SwiftSyntax macro/diagnostic products |
| `MacroToolboxTransflection` | Optional host decoding and source-anchored diagnostic bridge | MacroToolbox, Models, Syntax, ValueTransflection, ExpansionTimeTransflection, SwiftSyntax macro/diagnostic products |
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
let analysis = declaration.analyzeDirectMembers()
let access = analysis.enclosingAccess.explicitReadAccess
let properties = try analysis.validated().bindings
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

## Direct struct-member analysis

`StructMemberAnalysis` is a complete syntactic inventory, available from
`StructDeclSyntax.analyzeDirectMembers()`. `members` retains every direct member in source order,
including nested types and conditional declarations. `bindings` contains each direct variable
binding separately, including unsupported patterns whose `identifier` is nil. Neither nested
type bodies nor conditional branches are flattened into the enclosing fields.

Each `StructBindingDescriptor` exposes its original `VariableDeclSyntax`, `PatternBindingSyntax`,
pattern/identifier token, written type, initializer expression, let/var token, type-property and
lazy flags, attributes/modifiers, accessor block and classified shape. Member and binding indices
are source ordinals. `explicitType == nil` means no annotation was written on that binding; the
analyzer never infers a type from an initializer or another binding, and a written `TypeSyntax`
is not resolved type identity. Identifier names retain source spelling, including backticks.

| Source shape | Analysis result |
| --- | --- |
| `let value: String` | Immutable instance binding with the original annotation and node |
| `var a: Int = 1, b: Int = 2` | Two ordered bindings with separate annotations and initializers |
| `var value = 1` | Initializer retained; `missingTypeAnnotation` finding |
| `var answer: Int { 42 }`, explicit `get`/`set` | `.computed` accessor shape |
| `var value: Int = 0 { didSet {} }` | `.observed` shape with original observer block |
| `static var total: Int = 0` | Type property, distinct from instance state |
| `public private(set) var value: String` | Public read access and private setter access separately |
| `lazy var value: String = ""` | Lazy modifier retained with a limitation finding |
| Attributed/wrapped binding | Every attribute retained and reported; storage semantics are not guessed |
| `#if ... #endif` | Original conditional member plus a finding; no branch is selected |
| Destructuring or unfamiliar accessors such as `_read` | Binding retained with unsupported-shape finding |
| Parser recovery/missing syntax | Malformed finding anchored in the original tree |
| `struct Nested { var child: Int }` | Nested declaration retained; `child` is not an outer binding |

`WrittenDeclarationAccess` keeps read and setter modifiers separately, including original modifier
nodes. `explicitReadAccess` and `explicitSetterAccess` report written keywords;
`localReadAccess` defaults a missing read keyword to `.internal` only. `enclosingAccess` records
what was written on the attached struct independently. These facts do not compute effective
access across enclosing scopes, extensions, packages, or protocol/conformance requirements.
Duplicate/conflicting access modifiers produce findings. Existing `modifiers.visibilityLevel`
now correctly ignores setter-only modifiers, even when `private(set)` appears first;
`setterVisibilityLevel` extracts setter access independently.

For transformations, use the strict entry point:

```swift
let analysis = declaration.analyzeDirectMembers()
let policy = StructTransformationPolicy(
  supportedAccessorShapes: [.stored],
  allowedOtherDeclarations: [.function, .initializer],
  requiresWrittenTypes: true
)
let validated = try analysis.validated(using: policy)
// Only now plan and emit members using validated.members / validated.bindings.
```

Validation throws `StructAnalysisRejection` containing **every** rejection's typed `reason`,
original `anchor`, and optional member/binding indices. It returns no partial validated list.
A caller can catch it and diagnose every finding before emitting anything. The default policy
accepts only plain stored bindings with written types and no other declarations. Computed or
observed bindings, other declaration kinds, missing annotations, attributed bindings, and lazy
bindings require explicit policy choices. Attribute/lazy opt-ins mean the caller handles those
preserved semantics; they do not establish them through analysis. Conditional branches,
macro-expanded members, unsupported patterns, unfamiliar accessors, malformed syntax, and
conflicting access cannot be waived by this API. Successful validation keeps the complete
inventory and any deliberately acknowledged limitations in `validated.analysis`.

Static/instance status is a fact, not an acceptance rule. Newtype emptiness, accumulator storage,
generated-name collisions, nested attachment restrictions, and requested API visibility remain
consumer planning decisions. This API does not perform compiler semantic validation or prove
that a declaration is legal Swift merely because its supported syntactic shapes were recognized.

The older `isStoredProperty`, `storedPropertyDescriptors`, and `DataTypeFieldStructureDescriptor`
conveniences retain their loose single-binding/filtering behavior. They can omit multi-bindings
and unsupported members and must not certify a complete transformation. `StoredPropertyDescriptor`
now exposes its original binding/declaration, name, annotation, initializer, attributes/modifiers,
and written access publicly. Its equality compares original syntax identity and the stored name:
a descriptor equals itself, a copy, and another descriptor built from the same nodes. Independent
parses of identical text need not compare equal; caches do not affect equality/hash values.
`isPlausibleMemberwiseInitializer` remains only a name/count heuristic, never authority to choose
an initializer or preserve its defaults/invariants.

[`FieldAnalysisPublicTests`](Tests/FieldAnalysisPublicTests/FieldAnalysisTests.swift) imports only
public model/syntax APIs, with no orchestration dependency or `@testable`. It analyzes the same
[accepted source file](Tests/FieldAnalysisPublicTests/AcceptedShapes.swift) compiled into the test
target; the fixture defines its wrapper and uses actor isolation for mutable static state under
Swift 6. Recovery/destructuring/conflicting-source rejection fixtures are kept separate. Tests
assert original node identities, independent access facts, all-or-nothing rejection, and equality.

## Typed construction and formatting

`MacroToolboxSyntax` exposes `SyntaxConstruction`, a small set of constructors over SwiftSyntax
nodes. It needs no contextualized macro protocol or `MacroToolbox` import. A caller first chooses
its members, bodies, access, and conformances; construction only renders those decisions.

```swift
import MacroToolboxModels
import MacroToolboxSyntax
import SwiftSyntax

let stringType = TypeSyntax(IdentifierTypeSyntax(name: .identifier("String")))
let storage = try SyntaxConstruction.storedProperty(
  name: .identifier("storedValue"), type: stringType, readAccess: .private
)
let parameter = try SyntaxConstruction.parameter(localName: .identifier("value"), type: stringType)
// Parsing source is an explicit escape hatch; malformed or extra syntax throws.
let assignment = try SyntaxSourceFragment.parse("self.storedValue = value", as: CodeBlockItemSyntax.self)
let initializer = try SyntaxConstruction.initializer(
  parameters: [parameter], body: [assignment], access: .public
)
```

The surface includes stored `let`/`var` members, read-only computed members, initializers,
functions (including caller-selected forwarding calls), calls/arguments/parameters, and
extensions with inheritance and conformance/same-type requirements. Types, expressions, bodies,
attributes, modifiers, and name tokens are typed inputs. `identifier(_:)` deliberately quotes
keywords/raw names when needed and rejects invalid identifiers. A nil external parameter name
means `_ localName`; a matching external/local name emits one token. A nil argument label is
unlabeled. Compound callees are grouped before applying a call, so `primary ?? fallback`
becomes `(primary ?? fallback)()`. Empty inheritance/requirement inputs omit their entire clause.

Lists use commas between elements and no final comma. Newly inserted commas carry one trailing
space; existing comma trivia is retained, and removing a final comma moves its trivia onto the
final element. Formatting subsequently normalizes whitespace while preserving comments. The
throwing constructors reject recovered input before punctuation normalization and validate the
built output; complete declarations/calls also undergo a verification parse and token check.
The returned value is the built tree, never the verification parse, so typed fragments are not
replaced via source-string round trips. Source nodes retain their original identity and text.

Read/declaration access and setter access are independent optional inputs. Extra modifiers and
attributes are kept as supplied. The renderer does not widen access, establish type correctness,
or decide protocol-witness or inlinability legality. Compiler checks and consumer planning still
own those decisions. The fixture's forwarding method exercises construction only; it does not
add an API to either downstream pilot.

`autoFormattedForHDXLProject`, `autoformattedEquivalent(s)`, and `withAutomaticReformatting`
now actually apply SwiftBasicFormat with two-space indentation. Contextualized macro wrappers
using them also format their generated output. Callers should update snapshots that depended on
the former no-op (for example, `func f(){}` becomes `func f() {\n}`). The formatter validates both
input and output and preserves the concrete node kind, even behind `DeclSyntax` erasure;
`formattedPreservingSyntaxKind(using:)` throws `SyntaxFormattingFailure.changedNodeKind` when
a custom formatter substitutes another kind. Missing/unexpected recovery syntax also throws.
Formatting is explicit and returns a copy; structural inspection does not format source nodes.

The existing `StoredProperty` string adapter and `DataTypeBodyBuilder` remain available.
`StoredProperty.makeSyntaxRepresentation()` now parses each complete source fragment separately,
then uses the typed constructor; malformed/extra type, attribute, or initializer syntax throws.
Migrate `typeName: source` to `type: try SyntaxSourceFragment.parse(source, as: TypeSyntax.self)`,
initializer strings to `ExprSyntax`, and attributes to `AttributeSyntax`/`AttributeListSyntax`.
For already typed inputs, pass them directly. The older string-based `forTypeNames`,
`forInheritedTypeNames`, and `requirement(that:inheritsFrom:)` conveniences still treat names as
identifier spellings; they are not fragment parsers. Use `SyntaxConstruction.inheritanceClause`,
`conformanceRequirement`, `sameTypeRequirement`, and `whereClause` for typed/compound types and
safe empty-clause omission. The low-level legacy `GenericWhereClauseSyntax(requirements:)`
continues to create a clause even when empty; migrate optional clauses to `whereClause`.

[TypedConstructionConsumer](IntegrationFixtures/TypedConstructionConsumer/README.md) builds
through public model/syntax imports, emits the actual declarations, and compiles/runs them. It
also requires the compiler to reject an insufficiently visible conformance witness and a raw
`String` supplied to a typed type parameter.

## Decoding, plans, and diagnostics

`MacroToolboxTransflection` uses the core's ordinary value route for any
`TransflectableFromTransflectionExpression`. It does not require another syntax conformance.
`decode(_:as:)` accepts an expression; `decodeArgument(at:in:as:)` accepts an attribute or
freestanding invocation. A contextualized macro calls `decodeValueArgument(at:as:)` instead.
These APIs never emit diagnostics, invoke arbitrary source code, infer initializers, or retry a
custom decoder. Constructor names, binding, defaults, and reconstruction remain core/value
witness responsibilities. `decodeAsymmetrically(_:using:)` is an explicit, separate caller choice.

```swift
import MacroToolboxModels
import MacroToolboxTransflection
import SwiftSyntax

func visibility(from argument: ExprSyntax) throws -> VisibilityLevel {
  try TransflectionMacroBridge.decode(argument, as: VisibilityLevel.self)
}
```

`VisibilityLevel` accepts leading-dot cases and the exact `VisibilityLevel` /
`MacroToolboxModels.VisibilityLevel` qualifications, with no payload. The same model type is
used in application configuration and plugin decoding. No derivation macro is needed to build it.

`StagedMacroExpansion<Input, Validated, Plan, Output>` in `MacroToolbox` takes explicit `validate`,
`plan`, and `render` closures. `prepare(input)` validates/decodes and creates the plan without
rendering; `render(plan)` receives only the completed plan. `expand(input)` composes both.
Callers own immutable plan types, attachment restrictions, access rules, and generation policy.
Create any invocation state separately for each macro-role callback; the helper has no shared cache.
The [bridge fixtures](Tests/TransflectionBridgeTests/MacroExpansionTests.swift) show the same
stages used by an ordinary `MemberMacro` and `ContextualizedMemberMacro`.

Decoding failures retain the core's typed reason, path, cause, and original source-map sidecar in
`TransflectionDecodingFailure`. `TransflectionMacroBridge.diagnostic(for:details:)` constructs a
diagnostic without emission. Its primary node is the original offending expression or label;
missing input uses the closest enclosing source with an explanatory note. A path note retains
argument/field/index context. No normalized source is reparsed to invent a location.

Choose one terminal emission owner. `TransflectionMacroBridge.withDiagnostics(in:at:details:
failureValue:_:)` emits once and returns a caller-selected fallback. A member/extension macro
usually supplies an empty declaration array. An expression macro supplies its own valid
replacement. `MacroContextProtocol.withTransflectionDiagnostics` adapts to the same boundary.
The operation may decode, validate, prepare, and render; it must not also emit its thrown failures.
`MacroDiagnosticDetails` preserves explicit position, severity, domain/ID, highlights, notes,
and fix-its. Pass fix-its only when a specific valid replacement is known; the bridge never guesses.
Caller `DiagnosticsError` metadata is retained. Unknown implementation errors use the distinct
`MacroToolboxTransflection/unexpected-implementation-error` ID, with the original error available
to an optional debug callback rather than exposing implementation file/line details to users.

### Diagnostic migration

`requireValue`, `requireCondition`, and related contextualized requirements now **defer** a
`DiagnosticsError` instead of emitting and rethrowing. Swift's macro boundary (or the explicit
bridge terminal helper) owns emission. Nested requirements preserve existing diagnostics and
bridge failures, so they cannot produce a second generic error. `record*` helpers remain explicit
emission APIs for callers that intentionally report a diagnostic and continue.

`withAutomaticRecordingForRequiredOperation` is deprecated in favor of
`withDiagnosticContextForRequiredOperation`; the compatibility wrapper now has `throws` rather
than `rethrows`, because it constructs deferred diagnostic information. Call sites should use
`try` and let one outer boundary consume the error. `MacroExpansionFailure.description` now
contains only its explanation; `debugDescription`/`prettyPrinted` retain implementation context.
A thrown SwiftSyntax `DiagnosticsError` requires an error-severity diagnostic. Use the explicit
terminal helper for warning/note failures with a caller-chosen fallback, so Swift's throwing
macro machinery does not add a synthetic “missing error” diagnostic.

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
requested value; explicitly selected asymmetric decoding is a separate capability.
`MacroToolboxTransflection` is an optional host product above that core. `VisibilityLevel` has a
handwritten normal value witness in Models, available without importing the host bridge.
Toolbox and the transflection core never depend on the downstream derivation-macros package.
Any foundational conformance needed to build the generator must be handwritten.

## Validation

Run `swift package resolve`, `swift package dump-package`,
`swift package show-dependencies --format json`, `swift build`, and `swift test`.

```sh
swiftc -swift-version 6 -typecheck -D FEATURE Tests/FieldAnalysisPublicTests/AcceptedShapes.swift
python3 Validation/check_target_graph.py --self-test
python3 IntegrationFixtures/TargetBoundaries/validate.py --output /tmp/toolbox-boundaries
python3 IntegrationFixtures/TypedConstructionConsumer/validate.py --output /tmp/toolbox-construction
```

The graph guard checks each sensitive target's allowed edges and model/syntax/wrapper imports.
Its mutation checks prove it rejects prohibited ordinary/reverse dependencies. To check an
actual transflection-core manifest too, add `--core-manifest /path/to/core-dump-package.json`;
without it the core mutation checks use a synthetic contract graph and do not claim to inspect
an external checkout.

The independent fixture compiles a model-only client before any syntax product, a syntax-only
host client using public imports, an optional bridge client, and a client exercising all four
gathering declarations. The isolated model import includes only Models and ValueTransflection. It
retains verbose compiler/linker logs, actual SwiftPM target graphs with host-tool edges separated,
runtime object/dylib inputs, and an isolated model import/dependency scan. The root package does
not depend on this fixture. Use a new output directory for each run.

## Supported development environment

Use Swift 6.4, Swift language mode 6, and SwiftSyntax 604.x. The deployment minimum is 27.0 on
macOS, iOS, tvOS, watchOS, visionOS, and Mac Catalyst. This is a single-toolchain development
baseline; older compilers and Linux are not supported by this validation contract. The fixture
runs on macOS; that does not claim execution on other deployment destinations.

## Independent public-consumer gate

```sh
python3 Validation/validate_public_consumers.py --output /tmp/toolbox-public-gate
```

Use a new output directory. This CI entry point records exact Swift/Xcode/Apple SDK and resolved
SwiftSyntax versions, runs the five root checks and target/reverse-edge mutation guard, then
builds all three external fixtures independently from clean scratch directories. Missing Swift
6.4 / Apple 27 infrastructure fails clearly; no fallback compatibility mode is used.

[PublicMacroConsumer](IntegrationFixtures/PublicMacroConsumer/README.md) is the complete small
author recipe: pure handwritten shared options → ordinary MemberMacro with optional decoding
bridge → complete public field/access analysis → immutable caller-owned plan → typed generation
→ one terminal diagnostic owner. Its wrapper has only pure-model and host-plugin dependencies.
It compiles private item storage, a read-only projection, and an initializer, then runs a separate
client against the generated public API. Its policy deliberately supports one typed seed field;
no production newtype/accumulator policy is moved into toolbox.

The gate also runs TargetBoundaries' model-only client before any host build and the existing
typed-construction compiler fixture. It records actual ordinary/host target graphs, verbose
compiler/linker evidence, isolated compiled imports, nested source-path diagnostics, and compiler
rejections for unsupported fields and name collisions. Runtime isolation means absence from the
ordinary target/link/module closure, not absence from the resolver's downloads or host builds.
