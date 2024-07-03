import SwiftSyntax

extension VariableDeclSyntax {
  
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
      return true
    case .some(.getter(_)):
      return false
    case .some(.accessors(let accessors)):
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
