import SwiftSyntax

extension AttributeSyntax {
  
  @inlinable
  public var hasAtSign: Bool {
    atSign.tokenKind == .atSign
  }
  
  @inlinable
  public var hasNoArguments: Bool {
    arguments == nil
    &&
    leftParen == nil
    &&
    rightParen == nil
  }
  
  @inlinable
  public var inlinabilityDisposition: InlinabilityDisposition? {
    switch attributeName.as(IdentifierTypeSyntax.self) {
    case .some(let identifier):
      InlinabilityDisposition(tokenSyntax: identifier.name)
    case .none:
      nil
    }
  }
  
  @inlinable
  public func hasName(_ name: String) -> Bool {
    switch attributeName.as(IdentifierTypeSyntax.self) {
    case .some(let identifier):
      identifier.name.text == name
    case .none:
      false
    }
  }
  
  @inlinable
  public var isPreferredMemberwiseInitializer: Bool {
    hasName("PreferredMemberwiseInitializer")
  }
  
  @inlinable
  public var argumentListAsLabeledExprList: LabeledExprListSyntax? {
    guard case .argumentList(let argumentList) = arguments else {
      return nil
    }
    
    return argumentList
  }
  
}
