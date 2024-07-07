import MacroTransflection
import MacroTransflectionMacros

@AddSourceCodeIdentifierTransflection
enum TransflectableEnumeration {
  case foo
  case bar
  case baz
  
  @ExcludeFromTransflection
  case excludedQuuz
}
