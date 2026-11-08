# Typed construction consumer

Run from the toolbox root with Swift 6.4, Swift language mode 6, SwiftSyntax 604.x, and
the Apple-27 SDK/deployment baseline:

```sh
python3 IntegrationFixtures/TypedConstructionConsumer/validate.py --output /tmp/toolbox-construction
```

The output directory must be new. The validator records toolchain/SDK versions, resolved
dependencies, commands, generated source, compiler diagnostics, and runtime output.

The independent generator imports the public `MacroToolboxModels`/`MacroToolboxSyntax` products
and SwiftSyntax/SwiftParser. It does not import orchestration or use `@testable`. Its output
contains private storage, a public initializer/projection/forwarder, and a valid public
`CustomStringConvertible` witness. Additional emitted declarations cover empty/single/multiple
parameter, argument, member, and requirement lists, escaped keyword names, optional/nested
generic types, attributes, initializers, and public-read/private-set access. Generic requirements
use valid `Sequence`/`Equatable` constraints and `T.Element == String`; the resulting method runs.

The compiler separately rejects the same conformance with an explicitly internal witness.
The renderer must retain that requested access rather than silently widen it. A second negative
probe proves an ordinary `String` cannot be supplied where construction requires `TypeSyntax`.
These are compiler checks of actual generated output, beyond parsing or snapshot comparisons.
