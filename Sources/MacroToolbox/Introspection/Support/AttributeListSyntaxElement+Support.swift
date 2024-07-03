import SwiftSyntax

extension AttributeListSyntax.Element {
  
  @inlinable
  public var inlinabilityDisposition: InlinabilityDisposition? {
    guard case .attribute(let attributeSyntax) = self else {
      return nil
    }
    
    return attributeSyntax.inlinabilityDisposition
  }
  
  @inlinable
  public var isPreferredMemberwiseInitializer: Bool {
    guard case .attribute(let attributeSyntax) = self else {
      return false
    }
    
    return attributeSyntax.isPreferredMemberwiseInitializer
  }
  
}
