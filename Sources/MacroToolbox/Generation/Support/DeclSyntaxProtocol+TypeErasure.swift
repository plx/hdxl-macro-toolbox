import SwiftSyntax
import SwiftSyntaxBuilder

extension DeclSyntaxProtocol {
  
  @inlinable
  public func eraseToDeclSyntax() -> DeclSyntax {
    DeclSyntax(self)
  }

  @inlinable
  public func eraseToValidatedDeclSyntax() throws -> DeclSyntax {
    try DeclSyntax(validating: eraseToDeclSyntax())
  }

}
