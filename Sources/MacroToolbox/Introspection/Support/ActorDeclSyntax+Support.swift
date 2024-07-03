import SwiftSyntax

extension ActorDeclSyntax {
  
  @inlinable
  public var simpleGenericParameterNames: [String]? {
    genericParameterClause?.simpleGenericParameterNames
  }
  
}

