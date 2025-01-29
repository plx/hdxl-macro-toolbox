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
