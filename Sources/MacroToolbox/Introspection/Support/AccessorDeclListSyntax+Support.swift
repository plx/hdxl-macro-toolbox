import SwiftSyntax

extension AccessorDeclListSyntax {
  
  /// `true` if this list of accessor-decls could be defined on a stored property.
  @inlinable
  public var isCompatibleWithStoredProperty: Bool {
    !isIncompatibleWithStoredProperty
  }

  /// `true` if this list of accessor-decls *cannot* be part of a stored-property declaration.
  @inlinable
  public var isIncompatibleWithStoredProperty: Bool {
    anySatisfy(\.isIncompatibleWithStoredProperty)
  }
  
}
