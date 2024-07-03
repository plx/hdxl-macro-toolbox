import SwiftSyntax

extension GenericArgumentClauseSyntax {
  
  @inlinable
  public var simpleGenericParameterNames: [String]? {
    arguments.simpleGenericParameterNames
  }
}

