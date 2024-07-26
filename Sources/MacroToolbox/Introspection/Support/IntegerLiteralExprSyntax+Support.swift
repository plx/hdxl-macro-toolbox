import SwiftSyntax

extension IntegerLiteralExprSyntax {
  
  /// The concrete integer value represented by `self`, if any (as an `Int`).
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

  /// The concrete integer value represented by `self`, if any, when interpreted as a value of type `type`.
  ///
  /// - note:
  ///
  /// This exists for cases that cannot be represented as an `Int`, like e.g. very large `UInt64` literals.
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
