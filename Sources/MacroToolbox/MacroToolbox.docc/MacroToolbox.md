# ``MacroToolbox``

Public models, syntax utilities, and optional expansion support for Swift macro authors.

## Products and dependency direction

`MacroToolboxModels` contains syntax-free shared policies and handwritten value witnesses. Its
only non-standard-library runtime dependency is the separate `ValueTransflection` product.
`MacroToolboxSyntax` contains original-source descriptors, structural analysis, typed builders,
and formatting; its SwiftSyntaxBuilder dependency also brings parser diagnostics on the host.
It does not depend on contextualized macro protocols.

`MacroToolbox` adds diagnostics and `StagedMacroExpansion` and re-exports the two focused modules.
`MacroToolboxTransflection` is the available optional host bridge to `ValueTransflection` and
`ExpansionTimeTransflection`. Core owns expression lowering, binding, and failure paths; toolbox
owns convenience adapters and source-anchored diagnostic presentation, not another evaluator.
The four `MacroToolboxMacros` declarations have a compiler-host plugin relationship; their
ordinary wrapper imports no syntax library. Neither foundation depends on the derivation package.

## Public author workflow

1. Define shared pure options with ordinary public constructors. Handwrite bootstrap value
   witnesses with core enum extraction and ordered binding. Use the same options in client and plugin.
2. Give the macro-declaration target only its pure options and host plugin dependencies. Put
   SwiftSyntax, diagnostics, toolbox syntax, and the optional bridge in the implementation target.
3. Adopt an ordinary SwiftSyntax `MemberMacro` or another role; contextualized refinements are
   optional. Decode normal options with `TransflectionMacroBridge.decodeArgument(at:in:as:)`.
4. Inspect `StructDeclSyntax.analyzeDirectMembers()`: all direct members/bindings, written types,
   initializers, source identities, accessor forms, and separate getter/setter access remain public.
   Call `validated(using:)` with the supported shapes. Unknown storage is reported, never omitted.
5. Prepare an immutable caller-owned plan with names, access and semantic choices.
   `StagedMacroExpansion` validates/prepares first and renders from the finished plan only.
6. Use `SyntaxConstruction` typed stored/read-only property, initializer, function and extension
   builders. Access legality, collisions and domain-specific behavior remain the caller's policy.
7. Own emission once with `TransflectionMacroBridge.withDiagnostics`, normally returning `[]`
   on a member/extension failure. Inner operations throw without emitting. Original syntax anchors,
   typed core paths/causes and caller-supplied diagnostic metadata are preserved.

An explicitly asymmetric decoder is a separate choice, never a fallback from normal decoding.
No API evaluates arbitrary caller Swift or infers semantic type identity from syntax spelling.

## Independent executable proof

`IntegrationFixtures/PublicMacroConsumer` uses public imports, handwritten visibility/item/record
options, an ordinary member macro, a pure immutable plan, and typed private storage/read-only
projection/initializer generation. Its local strict policy accepts one plain typed seed field and
rejects unsupported members and generated-name conflicts without partial output. Host tests assert
one original-source diagnostic for a nested wrong-shape item. Separate compiler rejection fixtures
cover valid but unsupported expressions/members, while an external executable verifies success.

`IntegrationFixtures/TargetBoundaries` first builds a model-only client without host objects, then
focused syntax/bridge and gathering-macro clients. `TypedConstructionConsumer` compiles and runs
generated declarations and verifies intended compiler failures.

Run `python3 Validation/validate_public_consumers.py --output <new-directory>` from the checkout.
The single CI gate records actual compiler/SDK/resolved revisions, runs root checks and graph
mutations, and builds all fixtures independently. Actual target graphs, verbose compiler/linker
commands, runtime object inputs and isolated compiled-module imports distinguish host plugin
builds from ordinary dependencies. SwiftSyntax downloads alone do not establish a runtime edge.

## Supported environment

Swift 6.4, Swift language mode 6, SwiftSyntax 604.x, and minimum 27.0 on macOS, iOS, tvOS,
watchOS, visionOS and Mac Catalyst. Validation runs on the required macOS toolchain and fails
rather than skipping unavailable infrastructure. See the repository README and fixture READMEs
for complete products, source/output subsets, unsupported-input behavior, and command recipes.
