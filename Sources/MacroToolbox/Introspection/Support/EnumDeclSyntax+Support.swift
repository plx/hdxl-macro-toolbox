import SwiftSyntax

extension EnumDeclSyntax {
  
  @inlinable
  public var simpleGenericParameterNames: [String]? {
    genericParameterClause?.simpleGenericParameterNames
  }
  
}

