import SwiftSyntax

extension AccessorDeclSyntax {
  
  /// `true` if this is a `willSet`-accessor-decl.
  @inlinable
  public var isWillSet: Bool {
    accessorSpecifier.isWillSet
  }

  /// `true` if this is a `didSet`-accessor-decl.
  @inlinable
  public var isDidSet: Bool {
    accessorSpecifier.isDidSet
  }
  
  /// `true` if this is a `get`-accessor-decl.
  @inlinable
  public var isGet: Bool {
    accessorSpecifier.isGet
  }

  /// `true` if this is a `set`-accessor-decl.
  @inlinable
  public var isSet: Bool {
    accessorSpecifier.isSet
  }

  /// `true` if this is a `modify`-accessor-decl.
  @inlinable
  public var isModify: Bool {
    accessorSpecifier.isModify
  }
  
  /// `true` if this accessor-decl *could* be part of a stored-property declaration.
  @inlinable
  public var isCompatibleWithStoredProperty: Bool {
    isWillSet || isDidSet
  }

  /// `true` if this accessor-decl *could not* be part of a stored-property declaration.
  @inlinable
  public var isIncompatibleWithStoredProperty: Bool {
    isGet || isSet || isModify
  }

}
