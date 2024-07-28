# ``MacroToolbox``

The ``MacroToolbox`` package provides tools meant to streamline writing Swift macros. 

## Overview

``MacroToolbox`` has two major subsystems: (a) the "contextualized-macro" subsystem and (b) the "macro-translection" subsystem.

### Contextualized-Macros

When writing macros I've repeatedly encountered two pain points:

1. *validating* macro usage
  - is the (attached) macro attached to a compatible declaration-type?
  - are the macro arguments valid-and-usable?
  - can we gather all the information we need for expansion?
2. *reporting* validation issues:
  - can we report validation issues in a useful way?
  - can we include enough context to be helpful? 

In my experience, at least, as macros become increasingly non-trivial:

- the macro-expansion logic, itself, tends to remain reasonably short-and-concise
- the validation-and-reporting logic tends to become an order of magnitude longer than the underyling expansion-logic

Here's a worked example trying to illustrate the dynamic.

For a simple macro, you can simply write "vanilla" macro code, forego any validation, and still get a reasonable result.

For example, if you wanted a macro that added `var typeName: String { get }` to a type, this would work:

```swift
public enum AddTypeNameMacro : ExtensionMacro {

  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    return [
      try ExtensionDeclSyntax(
        """
        extension \(type) {
          var typeName: String {
            String(reflecting: type(of: self))
          } 
        }
        """
      )
    ]
  }
} 
```

Now let's say you wanted a macro that automated the synthesis of a "case enumeration":

```swift
// given this:
@AddCaseEnumeration
enum EnumerationWithPayload<T,V,R> {
  case tee(T)
  case vee(V)
  case arr(R)
}

// you want this to get emitted:
enum EnumerationWithPayload<T,V,R> {
  enum EnumerationCase {
    case tee
    case vee
    case arr  
  }

  // "what case am I?"
  var eumerationCase: EnumerationCase {
    switch self {
    case .tee: .tee
    case .vee: .vee
    case .arr: .arr
    }
  }

  // all the bells and whistles, too:
  var isTee: Bool { is(enumerationCase: .tee) }
  var isVee: Bool { is(enumerationCase: .vee) }
  var isArr: Bool { is(enumerationCase: .arr) }
  
  func is(enumerationCase: EnumerationCase) -> Bool {
    self.enumerationCase == enumerationCase
  }
}
```

Aside from the syntax-expansion itself, you'd want to do a fair amount of validation: 

- this macro should only be attached to enumeration declarations
- this macro should at least *warn* if it's attached to an enumeration *without* any payloads

...and that's where things start to get a bit painful.
## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
