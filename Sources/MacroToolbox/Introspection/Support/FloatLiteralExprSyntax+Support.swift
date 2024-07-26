import SwiftSyntax

extension FloatLiteralExprSyntax {
  
  /// This is the floating-point's represented value, if any, represented as a `Double`.
  @inlinable
  public var representedFloatLiteralValue: Double? {
    guard
      case .floatLiteral(let stringRepresentation) = literal.tokenKind,
      let floatValue = Double(stringRepresentation)
    else {
      return nil
    }
    
    return floatValue
  }
  
}
