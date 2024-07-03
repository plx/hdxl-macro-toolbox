import SwiftSyntax

extension IntegerLiteralExprSyntax {
  
  @inlinable
  public var representedIntegerLiteralValue: Int? {
    guard
      case .integerLiteral(let stringRepresentation) = literal.tokenKind,
      let integerValue = Int(stringRepresentation)
    else {
      return nil
    }
    
    return integerValue
  }
  
}
