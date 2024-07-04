import SwiftSyntax
import SwiftSyntaxBuilder

extension SyntaxProtocol {
  
  @inlinable
  public func validated() throws -> Self {
    try Self(validating: self)
  }
  
}
