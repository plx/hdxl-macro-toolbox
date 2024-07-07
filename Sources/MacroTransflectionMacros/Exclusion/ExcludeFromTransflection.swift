
/// Marker-macro used to exclude declarations from participation in transflection.
///
/// For example, in this declaration:
///
/// ```swift
/// @AddSourceCodeIdentifierTransflection
/// enum TransflectableEnumeration {
///   case foo
///   case bar
///   case baz
///
///   @ExcludeFromTransflection
///   case excludedQuuz
/// }
/// ```
///
/// ...transflection support will **not** be synthesized for the`excludedQuuz`-case.
/// 
@attached(peer)
public macro ExcludeFromTransflection() = #externalMacro(
  module: "MacroTransflectionMacrosPlugin",
  type: "ExcludeFromTransflectionMacro"
)
