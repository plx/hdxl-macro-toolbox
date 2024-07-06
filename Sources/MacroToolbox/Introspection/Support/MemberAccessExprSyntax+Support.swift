import SwiftSyntax

extension MemberAccessExprSyntax {
  
  @inlinable
  public func isCompatibleWithTypeLevelPropertyAccess<T>(
    forBaseType baseType: T.Type
  ) -> Bool {
    guard let base else {
      return true
    }
    
    guard let baseTypeExpression = base.as(DeclReferenceExprSyntax.self) else {
      return false
    }
    
    guard baseTypeExpression.argumentNames == nil else {
      return false
    }
    
    guard case .identifier(let baseTypeIdentifier) = baseTypeExpression.baseName.tokenKind else {
      return false
    }
    
    return (
      baseTypeIdentifier == String(describing: baseType)
      ||
      baseTypeIdentifier == String(reflecting: baseType)
    )
  }

  @inlinable
  public func isCompatibleWithTypeLevelPropertyAccess(
    forBaseTypeNames baseTypeNames: Set<String>
  ) -> Bool {
    guard let base else {
      return true
    }
    
    guard let baseTypeExpression = base.as(DeclReferenceExprSyntax.self) else {
      return false
    }
    
    guard baseTypeExpression.argumentNames == nil else {
      return false
    }
    
    guard case .identifier(let baseTypeIdentifier) = baseTypeExpression.baseName.tokenKind else {
      return false
    }
    
    return baseTypeNames.contains(baseTypeIdentifier)
  }

  @inlinable
  public var isExplicitNone: Bool {
    guard
      declName.argumentNames == nil,
      period.tokenKind == .period,
      case .identifier(let identifier) = declName.baseName.tokenKind,
      identifier == "none"
    else {
      return false
    }
    
    return true
  }
  
}
