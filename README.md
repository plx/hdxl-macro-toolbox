# hdxl-macro-toolbox


## Overview

## Macro-Transflection

The macro-transflection subsystem streamlines "transflecting" a macro's arguments from the invmacro's invocation  site (in your s) from the *values* between the macro-invocation site and the correspond

```swift
/// Emits a tuple with `value` repeated `repeatCount`-times.
@freestanding(expression)
macro tuple<T>(repeating value: T, count repeatCount: Int) = #externalMacro(/**/)
```  

...which would produce the following:

```
let triple = #tuple(repeating: "foo", count: 3)
// let triple = ("foo", "foo", "foo")

let octuple = #tuple(repeating: 0, count: 8)
// let octuple = (0, 0, 0, 0, 0, 0, 0, 0)
```



## Macro-Toolbox


