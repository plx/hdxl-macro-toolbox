import SwiftSyntax

extension FloatLiteralExprSyntax {
  
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
