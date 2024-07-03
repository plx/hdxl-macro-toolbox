import SwiftSyntax

extension AccessorDeclSyntax {
  
  @inlinable
  public var isWillSet: Bool {
    accessorSpecifier.tokenKind == .keyword(.willSet)
  }

  @inlinable
  public var isDidSet: Bool {
    accessorSpecifier.tokenKind == .keyword(.didSet)
  }
  
  @inlinable
  public var isGet: Bool {
    accessorSpecifier.tokenKind == .keyword(.get)
  }

  @inlinable
  public var isSet: Bool {
    accessorSpecifier.tokenKind == .keyword(.set)
  }

  @inlinable
  public var isModify: Bool {
    accessorSpecifier.tokenKind == .keyword(._modify)
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
