import SwiftSyntax

extension BooleanLiteralExprSyntax {
  
  /// The `Bool` value represented by this boolean-literal syntax (if any).
  @inlinable
  public var representedBooleanLiteralValue: Bool? {
    switch literal.tokenKind {
    case .keyword(.true):
      true
    case .keyword(.false):
      false
    default:
      nil
    }
  }
  
}
