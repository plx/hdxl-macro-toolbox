# Migration for the proposed 0.3.0 release

These are pre-1.0 source changes. The candidate is not a published version.

- Import the product that owns the API: pure values are in `MacroToolboxModels`, field/access
  analysis and builders in `MacroToolboxSyntax`, contextual macro protocols in `MacroToolbox`,
  and decoding/diagnostic integration in `MacroToolboxTransflection`.
- Move qualified references such as `MacroToolbox.VisibilityLevel` to their owning model module.
  Do not add host syntax products to an ordinary shared options target merely for convenience.
- Validate unsupported field/access findings explicitly, construct a pure consumer plan, and
  render through typed builders. A parseable raw string is not proof of supported attachment shape.
- At the terminal bridge boundary, consume/emits errors once; do not diagnose and rethrow the
  same failure. Use handwritten option witnesses in lower foundations to avoid a derivation cycle.

See [release readiness](RELEASE_READINESS.md) for the expression language, three construction
policies, required-argument rules, exact environment and pending publication checks.
