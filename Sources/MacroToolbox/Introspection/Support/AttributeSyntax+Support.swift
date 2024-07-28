import SwiftSyntax

extension AttributeSyntax {
  
  /// `true` iff `self` begins with an `@` sign.
  @inlinable
  public var hasAtSign: Bool {
    atSign.tokenKind == .atSign
  }
  
  /// `true` iff this is an argumentless attribute.
  @inlinable
  public var hasNoArguments: Bool {
    arguments == nil
    &&
    leftParen == nil
    &&
    rightParen == nil
  }
  
  /// The ``InlinabilityDisposition`` implied-by this attribute, if any.
  @inlinable
  public var inlinabilityDisposition: InlinabilityDisposition? {
    switch attributeName.as(IdentifierTypeSyntax.self) {
    case .some(let identifier):
      InlinabilityDisposition(tokenSyntax: identifier.name)
    case .none:
      nil
    }
  }
  
  /// `true` iff this attribute is named `name`.
  @inlinable
  public func hasName(_ name: String) -> Bool {
    switch attributeName.as(IdentifierTypeSyntax.self) {
    case .some(let identifier):
      identifier.name.text == name
    case .none:
      false
    }
  }
  
  /// `true` iff this is the `@PreferredMemberwiseInitializer` attribute.
  @inlinable
  public var isPreferredMemberwiseInitializer: Bool {
    hasName("PreferredMemberwiseInitializer")
  }
  
  /// Convenience to extract self's arguments as a `LabeledExprListSyntax` (when possible to do so).
  @inlinable
  public var argumentListAsLabeledExprList: LabeledExprListSyntax? {
    guard case .argumentList(let argumentList) = arguments else {
      return nil
    }
    
    return argumentList
  }
  
}
