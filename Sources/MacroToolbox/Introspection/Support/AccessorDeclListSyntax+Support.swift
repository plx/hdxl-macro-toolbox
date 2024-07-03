import SwiftSyntax


extension AccessorDeclListSyntax {
  
  @inlinable
  public var isCompatibleWithStoredProperty: Bool {
    !isIncompatibleWithStoredProperty
  }
  
  @inlinable
  public var isIncompatibleWithStoredProperty: Bool {
    anySatisfy(\.isIncompatibleWithStoredProperty)
  }
  
}
