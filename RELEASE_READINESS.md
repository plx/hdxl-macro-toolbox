# Release preparation: 0.3.0 (unpublished proposal)

## Role and imports

Import `MacroToolboxModels` for syntax-free values, `MacroToolboxSyntax` for host analysis and
typed builders, `MacroToolbox` for contextualized expansion, and `MacroToolboxTransflection` for
the optional host decoding/diagnostic bridge. `MacroToolboxMacros` is a declaration facade with a
separate host plugin. Toolbox depends downward on core; it never depends on derivation or its
consumer fixtures, including in tests. Lower-layer option witnesses remain handwritten.

## Reproducible gate and supported scope

```sh
python3 Validation/validate_public_consumers.py --output /tmp/toolbox-release-unique
```

This runs root resolve/dump-package/show-dependencies/build/test, `MacroToolboxMacrosClient`,
the [no-reverse-dependency guard and mutation checks](Validation/check_target_graph.py), and three
independent fixtures: TargetBoundaries, TypedConstructionConsumer and PublicMacroConsumer.
Public analysis retains unsupported/mixed binding information rather than discarding fields;
typed builders consume explicit validated plans. The bridge separates normal decoding failures
from implementation failures and consumes emission once. The fixtures exercise public APIs
without `@testable`, actual ordinary/host build graphs, linker inputs, isolated interfaces,
compiled macro output and precise rejection diagnostics.

[The proposed dependency patch](ReleasePreparation/dependency-requirements.patch) requires core
`0.3.0..<0.4.0`. The separate [portable consumer patch](ReleasePreparation/portable-consumers.patch)
switches fixture dependencies only after the package itself has been published. Both are unapplied.

## Environment and evidence boundaries

The supported lane is Swift **6.4**, Swift language mode **6**, SwiftSyntax **604.x**
(`604.0.0..<605.0.0`), with deployment minimum **27.0** on macOS, iOS, tvOS, watchOS,
visionOS and Mac Catalyst. `from: "604.0.0"` expresses that same SwiftSyntax major range.
The available local host at preparation is arm64 macOS 27.0.1 (26A434), Xcode 27.0
(27A266a), Apple Swift 6.4 (`swiftlang-6.4.0.34.1 clang-2100.3.34.1`), macOS SDK 27.0,
and `/Applications/Xcode.app/Contents/Developer`. Validation records the actual environment
again for every run; the selected SwiftSyntax patch is recorded from every resolved graph.

Only macOS builds and test execution are claimed. The other five platforms have manifest
minimums and installed SDK inventory; they have no claimed compilation or execution result.
The 2026-11-08 repository Actions runner inventory reported zero registered self-hosted runners
in each of the four repositories. No matching hosted image or Actions execution has been verified.
Manual workflows require an actual available runner label selection and reject another compiler
or macOS SDK. Actions execution is pending; local execution of the same commands is separate
evidence. No runner registration, default-branch change or release publication is implied.

## Expression and construction contract

The standard route lowers syntax to `TransflectionExpression`, then decodes a typed value.
Literal scalars, optionals, arrays/dictionaries, explicitly recognized members and constructor
spellings compose at the root and within fields/payloads. Numeric conversion retains the written
sign and magnitude, checks destination range and reports failures without trapping. Qualified
names are compared as complete registered spellings. Variables, interpolation, arbitrary calls,
arithmetic, semantic typealias lookup and arbitrary Swift evaluation are outside this language.
See the [core expression contract](https://github.com/plx/hdxl-macro-transflection#standard-expression-contract).

Structural records assign decoded fields directly. Explicitly selected initializers call the
real compiled initializer, preserving validation, normalization, throwing and nil rejection.
Raw-value construction decodes `RawValue` and calls `init(rawValue:)`. These are separate policies.
Generated structural and selected policies require every argument, even Optional/defaulted
parameters; explicit `nil` is a supplied value. Only handwritten decoders may register compiled
default suppliers. They never evaluate a Swift default-expression string.

Errors retain reasons, ordered value paths and underlying causes. Host adapters map those paths
to original source nodes; one terminal owner emits diagnostics. A model/runtime interface must
not import or expose SwiftSyntax or a plugin. A separate host plugin may download, build and
link SwiftSyntax. Dependency checks distinguish those two closures instead of treating any
SwiftSyntax download as a runtime dependency.

## Publication remains a separate owner action

The coordinated proposal is core **0.3.0**, Toolbox **0.3.0**, derivation **0.2.0**, then the
bounded accumulator pilot **0.1.0**, in that order. These versions were unused at preparation;
recheck tags before publication. Pre-1.0 minor bumps cover the source/API changes. Live manifests
continue to reference reachable integrated commits. Proposed version patches are review artifacts,
not active dependencies on nonexistent tags.

After the owner authorizes publication: publish core first; apply/review the Toolbox dependency
patch and validate it against the published core before tagging Toolbox; repeat for derivation;
then update downstream consumer requirements. The accumulator owner must also choose its release
branch policy explicitly. Each dependency-only publication commit is a new candidate revision
and needs validation; a source-override run does not establish compatibility for that new commit.

The [coordinated release guide](https://github.com/plx/hdxl-macro-transflection/blob/main/Validation/CoordinatedRelease/README.md)
defines the exact source-set gate and pending URL/version-only checks. Final reviewed/merged SHA
and PR links belong to the [GEN-RELEASE completion record](https://github.com/plx/hdxl-macro-transflection/issues/15),
paired with the generated `validation.json`; a moving branch name is not an exact revision set.
COW/shader macros, URI wrappers, automatic inlining, broader newtype/accumulator inventories,
and a general accumulator graph language remain outside this completed scope.
