import SwiftSyntax

extension AccessorDeclSyntax {
  
  @inlinable
  public var isWillSet: Bool {
    accessorSpecifier.isWillSet
  }

  @inlinable
  public var isDidSet: Bool {
    accessorSpecifier.isDidSet
  }
  
  @inlinable
  public var isGet: Bool {
    accessorSpecifier.isGet
  }

  @inlinable
  public var isSet: Bool {
    accessorSpecifier.isSet
  }

  @inlinable
  public var isModify: Bool {
    accessorSpecifier.isModify
  }
  
  @inlinable
  public var isCompatibleWithStoredProperty: Bool {
    isWillSet || isDidSet
  }

  @inlinable
  public var isIncompatibleWithStoredProperty: Bool {
    isGet || isSet || isModify
  }

}
