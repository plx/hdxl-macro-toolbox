# hdxl-macro-toolbox

A "science experiment" repo containing some attempts at improving the macro-writing experience.

So far somewhat unsatisfactory--feels like it addresses real pain points, but in a not-fully-satisfying way,

## Subcomponent Overview

### Macro-Transflection

The macro-transflection subsystem streamlines "transflecting" a macro's argument *values* across the "boundary" between:

- their use in your own code's source
- their use during macro expansion

In other words, the starting point is a macro invocation like this:

```swift
@AddLogging(style: .foo)
func bar(baz: Baz) -> Whatever { }
```

...wherein `.foo` is a case within some `enum LogStyle`.

Out of the box, when `@AddLogging` is expanded, it only has access to syntax: it knows `.foo` is the syntax of an enumeration case, etc., but that's all it knows--the connection to `enum LogStyle` is absent. The utilities in the macro-transflaction component exist to streamline "recovering" these actual values while expanding the macro itself.

## Supported development environment

Use Swift 6.4, Swift language mode 6, and SwiftSyntax 604.x. The deployment
minimum is 27.0 on macOS, iOS, tvOS, watchOS, visionOS, and Mac Catalyst.
This is a single-toolchain development baseline; older compilers and Linux
are not supported by this validation contract. Compiler-host plugins build
SwiftSyntax separately from ordinary runtime model code.
