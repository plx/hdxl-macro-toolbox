# Toolbox target and source ownership

The split starts at accepted GEN-BASELINE commit `6f4e51b32340575b76f31ae66d13be7656f84b17`.
[`target-source-moves.json`](target-source-moves.json) records every whole-file move and its
original imports. These are ownership changes, with the existing declaration/generation
semantics retained.

| Source group | Owning module | Notes |
| --- | --- | --- |
| VisibilityLevel, inlinability/transparent/explicit-inline/performance policies | MacroToolboxModels | No syntax imports or stored syntax |
| DeclarationArchetype, TypeDeclarationArchetype, MacroAttachmentRequirement and pure conversions | MacroToolboxModels | Shared attachment policies |
| Argument label/position/location descriptors, LabelCriterion | MacroToolboxModels | Location storage uses package access for same-package syntax conversions; not public syntax exposure |
| ExportedSpecializationDirective, pure Support helpers | MacroToolboxModels | Standard-library values/helpers only |
| Inlinability/explicit-inline/visibility textual representations | MacroToolboxModels | Pure extension blocks separated from their former `+Syntax` files |
| All `+Syntax` conversions | MacroToolboxSyntax | Depend downward on Models |
| ConcreteDeclSyntax, ConcreteTypeDeclaration, ConcreteDataTypeDeclaration | MacroToolboxSyntax | SwiftSyntax-bearing sums; unused diagnostics/macro imports removed |
| StoredPropertyDescriptor, DataTypeFieldStructureDescriptor, PositionedLabeledExpression | MacroToolboxSyntax | Original syntax stays host-side; unused `os` import removed |
| StructMemberAnalysis, StructBindingDescriptor, WrittenDeclarationAccess, strict policy/results/findings | MacroToolboxSyntax | Complete original source inventory; no syntax-bearing data added to Models |
| Introspection and Generation | MacroToolboxSyntax | Navigation, parsing, typed declarations, builders and formatting |
| MacroExpansionFailure | MacroToolboxSyntax | Small error representation used by parsing; unused syntax/diagnostics imports removed; preserves existing error identity/name within its new module |
| MacroProtocols and remaining Diagnostics | MacroToolbox | Expansion contexts, diagnostics and orchestration above lower layers |
| Gathering declarations | MacroToolboxMacros | No ordinary dependencies besides the host plugin; no pure model parameter is currently needed |
| Gathering implementations and unfinished inlining implementation sources | MacroToolboxMacrosPlugin | Host-only; only the four published gathering macros are registered |

`MacroToolbox` re-exports Models and Syntax as a two-import umbrella. In-repository imports are
explicitly updated; external fixtures use public imports without `@testable`.

## Allowed dependency direction

- Models → Swift standard library. A future handwritten conformance may use ValueTransflection;
  no such dependency/witness is introduced by this split.
- Syntax → Models + SwiftSyntax/SwiftParser/SwiftSyntaxBuilder/SwiftBasicFormat.
- MacroToolbox → Models + Syntax + the SwiftSyntax macro/diagnostic products it uses.
- Wrapper → plugin (a macro host-tool edge), and only Models if a future public signature needs it.
- Plugin → MacroToolbox + Models + Syntax + compiler-plugin products.
- Ordinary gathering client → wrapper.
- Toolbox never depends on derivation; neither core transflection target depends on toolbox.

The syntax target retains a documented transitive diagnostic boundary: public validation and
string-construction helpers call SwiftSyntaxBuilder, whose 604.x implementation builds
SwiftDiagnostics/SwiftParserDiagnostics to construct and render parser validation errors.
There is no syntax → contextualized-macro-framework edge and no direct SwiftDiagnostics import
in the syntax module. The external fixture and build graph check this precise boundary.

`check_target_graph.py` checks manifest edges and source imports and mutation-tests each
prohibited boundary category. Existing `@inlinable` implementation storage stays visible using
package access where necessary. No SwiftSyntax type is added to model signatures.

The external TargetBoundaries fixture is independent; it is never a root dependency. Its
validator retains actual PIF graphs, compiler/linker invocations, ordinary runtime inputs,
plugin inputs, and public model module dependency scans. Full-package test imports exercise
relocated internals separately from these external public-API checks.

The `FieldAnalysisPublicTests` target imports only public Models/Syntax APIs and SwiftSyntax/SwiftParser.
It has no orchestration/plugin dependency. Its source-shape matrix is compiled as Swift and then
analyzed from that same source file; malformed/recovery fixtures remain parser-only negatives.
The graph guard inventories this consumer and rejects reverse or macro-framework dependencies.
