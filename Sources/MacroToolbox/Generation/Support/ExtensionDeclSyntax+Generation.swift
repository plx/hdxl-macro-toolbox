import SwiftSyntax
import SwiftSyntaxBuilder

extension ExtensionDeclSyntax {
  
  @inlinable
  public static func synthesizing(
    conformanceTo synthesizableProtocol: SynthesizableProtocol,
    for type: IdentifierTypeSyntax,
    visibility: VisibilityLevel
  ) throws -> ExtensionDeclSyntax {
    switch synthesizableProtocol {
    case .autoIdentifiable:
      try ExtensionDeclSyntax(
        """
        extension \(type) : Identifiable {
          \(raw: visibility.sourceCodeStringRepresentation) typealias ID = self
        
          \(raw: visibility.sourceCodeStringRepresentation) var id: ID { self } 
        }
        """
      ).validated()
    default:
      try ExtensionDeclSyntax(
        """
        extension \(type) : \(raw: synthesizableProtocol.associatedProtocolName) { }
        """
      ).validated()
    }
  }
  
}


