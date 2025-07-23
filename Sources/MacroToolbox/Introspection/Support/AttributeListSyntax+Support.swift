import SwiftSyntax

extension AttributeListSyntax {
  
  /// `true` iff this attribute-list contains an attribute with name `name`.
  @inlinable
  public func containsAttribute(named name: String) -> Bool {
    anySatisfy { $0.isAttribute(named: name) }
  }
  
  /// Returns the first inlinability-related attribute, if any.
  @inlinable
  public var inlinabilityDisposition: InlinabilityDisposition? {
    firstNonNilValue {
      InlinabilityDisposition(attributeListElement: $0)
    }
  }
  
  @inlinable
  public var nonConfigurationAttributes: [AttributeSyntax] {
    var result: [AttributeSyntax] = []
    for element in self {
      guard case .attribute(let attributeSyntax) = element else {
        continue
      }
      result.append(attributeSyntax)
    }
    
    return result
  }
  
}
