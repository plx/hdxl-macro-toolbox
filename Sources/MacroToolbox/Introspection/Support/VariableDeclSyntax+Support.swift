import SwiftSyntax

extension VariableDeclSyntax {
  
  /// `true` iff this appears to be a stored-property variable-declaration.
  ///
  /// - warning:
  ///
  /// This method is provisional b/c it will potentially misunderstand cases like these:
  ///
  /// - `lazy var`
  /// - `@StoreInUserDefaults var foo: Foo`
  ///
  /// ...and so on. The challenge with those is less about recognizing them as it is
  /// about how to provide an API for working with them them appropriately, so *for now*
  /// this is kept as-is to see what I can learn from putting it to use.
  @inlinable
  public var isStoredProperty: Bool {
    guard 
      bindings.count == 1,
      let binding = bindings.first
    else {
      return false
    }
    
    switch binding.accessorBlock?.accessors {
    case .none:
      // if it lacks accessors, it *may* be a stored property
      return true
    case .some(.getter(_)):
      // if it only has a getter, it's a computed property
      return false
    case .some(.accessors(let accessors)):
      // if it has multiple accessors, each of them needs to be
      // comapatible with being a stored property
      return accessors.allSatisfy(\.isCompatibleWithStoredProperty)
    }      
  }
  
  @inlinable
  public var variableNameIfStoredProperty: String? {
    guard 
      isStoredProperty,
      let binding = bindings.first,
      let identifier = binding.pattern.as(IdentifierPatternSyntax.self)
    else {
      return nil
    }
    
    return identifier.identifier.trimmed.text
  }
  
}
