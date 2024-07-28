import SwiftSyntax
import SwiftSyntaxBuilder

extension SyntaxProtocol {
  
  /// Returns `self` after undergoing validation.
  @inlinable
  public func validated() throws -> Self {
    try Self(validating: self)
  }
  
}
