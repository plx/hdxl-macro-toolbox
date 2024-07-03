import SwiftSyntax

extension GenericParameterClauseSyntax {
  
  @inlinable
  public var simpleGenericParameterNames: [String]? {
    parameters.simpleGenericParameterNames
  }
  
}
