import SwiftSyntax

extension GenericArgumentSyntax {
  
  @inlinable
  public var simpleGenericParameterName: String? {
    guard
      let identifier = argument.as(IdentifierTypeSyntax.self),
      case .identifier = identifier.name.tokenKind,
      !identifier.name.text.isEmpty
    else {
      return nil
    }
    
    return identifier.name.text
  }
  
}
