import SwiftSyntax

extension AttributeListSyntax.Element {
  
  /// The inlinability-disposition implied by this element, if any.
  ///
  /// - seealso: ``InlinabilityDisposition``
  @inlinable
  public var inlinabilityDisposition: InlinabilityDisposition? {
    guard case .attribute(let attributeSyntax) = self else {
      return nil
    }
    
    return attributeSyntax.inlinabilityDisposition
  }
  
  /// `true` iff this element is the  `@PreferredMemberwiseInitializer` attribute.
  @inlinable
  public var isPreferredMemberwiseInitializer: Bool {
    guard case .attribute(let attributeSyntax) = self else {
      return false
    }
    
    return attributeSyntax.isPreferredMemberwiseInitializer
  }

  /// `true` iff this element is the attribute with name `name`.
  @inlinable
  public func isAttribute(named name: String) -> Bool {
    guard case .attribute(let attributeSyntax) = self else {
      return false
    }

    return attributeSyntax.hasName(name)
  }
  
}
