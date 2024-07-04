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
