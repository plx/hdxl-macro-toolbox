import SwiftSyntax

extension StructDeclSyntax {
  
  @inlinable
  public var simpleGenericParameterNames: [String]? {
    genericParameterClause?.simpleGenericParameterNames
  }
  
}

