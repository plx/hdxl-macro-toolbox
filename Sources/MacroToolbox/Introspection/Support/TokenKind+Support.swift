import SwiftSyntax

extension TokenKind {

  /// `true` iff `self` is the prefix-minus-sign (e.g. `-1`).
  @inlinable
  public var isPrefixMinusSign: Bool {
    isPrefixOperator("-")
  }

  /// `true` iff `self` is the prefix-plus-sign (e.g. `+1`).
  @inlinable
  public var isPrefixPlusSign: Bool {
    isPrefixOperator("+")
  }

  /// `true` iff `self` is the infix-minus-sign (e.g. `1-2`).
  @inlinable
  public var isInfixMinusSign: Bool {
    isInfixOperator("-")
  }

  /// `true` iff `self` is the infix-publus-sign (e.g. `1+2`).
  @inlinable
  public var isInfixPlusSign: Bool {
    isInfixOperator("+")
  }

  /// Checks if `self` is the prefix-operator with spelling `operatorSymbol`.
  @inlinable
  public func isPrefixOperator(_ operatorSymbol: String) -> Bool {
    self == .prefixOperator(operatorSymbol)
  }

  /// Checks if `self` is the infix-operator with spelling `operatorSymbol`.
  @inlinable
  public func isInfixOperator(_ operatorSymbol: String) -> Bool {
    self == .binaryOperator(operatorSymbol)
  }

  /// Checks if `self` is the postfix-operator with spelling `operatorSymbol`.
  @inlinable
  public func isPostfixOperator(_ operatorSymbol: String) -> Bool {
    self == .postfixOperator(operatorSymbol)
  }

}

