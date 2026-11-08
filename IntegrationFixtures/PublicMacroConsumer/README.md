# Independent public macro consumer

This Swift 6.4 / language 6 / SwiftSyntax 604.x package proves the public toolbox products.
All six Apple deployment minima are 27. It is independent of the root package and has no
derivation, newtype, or accumulator dependency. Every import is ordinary public access.

## Target graph

- FixtureOptionsModels → MacroToolboxModels → ValueTransflection.
- FixtureMacros → FixtureOptionsModels, plus FixturePlugin as a compiler-host tool.
- FixturePlugin → the same FixtureOptionsModels, MacroToolboxSyntax, MacroToolbox,
  MacroToolboxTransflection, and SwiftSyntax compiler products.
- FixtureExamples → FixtureMacros + FixtureOptionsModels. The macro expands here.
- FixtureClient → the compiled examples, declarations, and options. It exercises public
  generated initializers/projections across a module boundary.
- FixtureHostTests → public host products and the plugin implementation, separately from
  every ordinary runtime target.

Resolution can fetch/build SwiftSyntax for the plugin. That does not put it in the models,
declaration wrapper, examples, or client's ordinary closure.

## Author recipe and local policy

1. Use the Models product for shared visibility policies. Define FixtureItem and FixtureOptions
   in the pure target, with public ordinary constructors. Handwrite their value witnesses using
   core enum extraction and ordered all-required argument binding; bootstrap never needs the
   downstream derivation generator.
2. Declare the macro with a FixtureOptions parameter. Its wrapper needs only its models and
   host plugin dependency.
3. Implement the ordinary SwiftSyntax MemberMacro protocol. Enter one
   TransflectionMacroBridge.withDiagnostics boundary, returning an empty declaration list
   on failure. Inner stages throw without also diagnosing.
4. Validate the original struct using analyzeDirectMembers()/validated(), inspect every binding
   and every existing name, then decode options through decodeArgument(at:in:as:).
5. Prepare the immutable, syntax-free FixturePlan. It records names, storage/member access,
   seed name, and decoded items. StagedMacroExpansion separates this from rendering.
6. Render only that plan using SyntaxConstruction.storedProperty, readOnlyProperty, and
   initializer. The renderer cannot re-read the invocation or declaration.

The deliberately narrow fixture accepts a top-level nongeneric struct without inheritance or
other type attributes, exactly one plain uninitialized stored let seed: Int (or Swift.Int),
and no other members. Written type/member access is internal, package, or public; requested
generated access cannot exceed type access. All other field/storage forms, existing initializers,
and collisions with _fixtureItems/fixtureItems are rejected before any rendering. These are
fixture policies, not rules embedded in toolbox's general analysis or builders.

The generated members are a private immutable item array, read-only fixtureItems projection,
and init(seed:) at the requested access. There is no accumulation algorithm, string wrapper,
conformance generation, or requested/implied-result policy. Empty item arrays work.

Public analysis tests separately cover compiler-valid multi-binding declarations, explicit
types/initializers, source identity/order, static/computed facts, legacy descriptor getters,
and independent public read/private setter access. Supporting analysis does not imply that the
fixture macro accepts all these shapes.

## Diagnostics and compiled evidence

Host expansion tests pass a nested integer where FixtureItem is expected, assert one diagnostic
on the original 42 with the macro-argument/items/index path, and assert no generated members.
Swift's argument type checker rejects that integer before a real plugin can expand it, so the
compiler-level nested failure instead uses a type-correct runtimeItem reference: the bounded
decoder intentionally cannot evaluate caller variables. That check requires one macro diagnostic
at the original reference and a path note. Lazy/wrapped members and name conflicts likewise
have separate compiler rejection fixtures. The wrapper support itself is valid Swift.

The successful external executable constructs PublicExample(seed: 7), checks the preserved seed
and projection, and exercises empty options. It is compiled and executed, not just snapshotted.

## Validation

From the repository root:

    python3 Validation/validate_public_consumers.py --output /tmp/toolbox-public-gate

Choose a new directory. This single CI gate records exact compiler/Xcode/SDK versions and
resolved revisions, runs all five root package checks and target/reverse-edge mutations, then
builds TargetBoundaries (including its model-only client first), TypedConstructionConsumer,
and this package independently from clean scratch paths.

For this fixture alone:

    python3 IntegrationFixtures/PublicMacroConsumer/validate.py --output /tmp/public-macro-check

Evidence includes verbose compiler/link logs, six public host tests, runtime assertions,
one-primary-error compiler rejections, actual SwiftPM target/host-tool closures, runtime link
objects and dylibs, and an isolated importer with only the five ordinary compiled modules and
a fresh module cache. Completion is recorded only after every gate passes. Missing toolchains,
SDKs, modules, or plugins are failures, never successful expected-input rejections.
