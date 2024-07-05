import SwiftSyntax

extension TokenSyntax {
  
  @inlinable
  public var keyword: Keyword? {
    guard case .keyword(let keyword) = tokenKind else {
      return nil
    }
    
    return keyword
  }
  
}

extension TokenSyntax {
  
  @inlinable
  public func isPrefixOperator(_ operatorSymbol: String) -> Bool {
    tokenKind.isPrefixOperator(operatorSymbol)
  }

  @inlinable
  public func isPostfixOperator(_ operatorSymbol: String) -> Bool {
    tokenKind.isPostfixOperator(operatorSymbol)
  }

  @inlinable
  public func isInfixOperator(_ operatorSymbol: String) -> Bool {
    tokenKind.isInfixOperator(operatorSymbol)
  }
  
  @inlinable
  public var isPrefixMinusSign: Bool {
    tokenKind.isPrefixMinusSign
  }

  @inlinable
  public var isPrefixPlusSign: Bool {
    tokenKind.isPrefixPlusSign
  }

}

extension TokenSyntax {
  
  @inlinable
  public var isWillSet: Bool {
    tokenKind == .keyword(.willSet)
  }

  @inlinable
  public var isDidSet: Bool {
    tokenKind == .keyword(.didSet)
  }
  
  @inlinable
  public var isGet: Bool {
    tokenKind == .keyword(.get)
  }

  @inlinable
  public var isSet: Bool {
    tokenKind == .keyword(.set)
  }

  @inlinable
  public var isModify: Bool {
    tokenKind == .keyword(._modify)
  }
  
}
