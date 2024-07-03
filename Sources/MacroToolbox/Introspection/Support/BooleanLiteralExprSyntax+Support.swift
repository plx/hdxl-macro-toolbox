import SwiftSyntax

extension BooleanLiteralExprSyntax {
  
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
