import SwiftSyntax

extension TokenKind {
  
  @inlinable
  public var isPrefixMinusSign: Bool {
    isPrefixOperator("-")
  }

  @inlinable
  public var isPrefixPlusSign: Bool {
    isPrefixOperator("+")
  }

  @inlinable
  public var isInfixMinusSign: Bool {
    isInfixOperator("-")
  }

  @inlinable
  public var isInfixPlusSign: Bool {
    isInfixOperator("+")
  }

  @inlinable
  public func isPrefixOperator(_ operatorSymbol: String) -> Bool {
    self == .prefixOperator(operatorSymbol)
  }

  @inlinable
  public func isInfixOperator(_ operatorSymbol: String) -> Bool {
    self == .binaryOperator(operatorSymbol)
  }

  @inlinable
  public func isPostfixOperator(_ operatorSymbol: String) -> Bool {
    self == .postfixOperator(operatorSymbol)
  }

}

