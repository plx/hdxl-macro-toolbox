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

  @inlinable
  public func representedValue<T>(
    ofType type: T.Type
  ) -> T? where T: FixedWidthInteger {
    guard
      case .integerLiteral(let stringRepresentation) = literal.tokenKind,
      let integerValue = T(stringRepresentation)
    else {
      return nil
    }
    
    return integerValue
  }

}
