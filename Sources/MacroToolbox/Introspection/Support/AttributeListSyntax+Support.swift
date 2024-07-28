import SwiftSyntax

extension AttributeListSyntax {
  
  /// `true` iff this attribute-list contains an attribute with name `name`.
  @inlinable
  public func containsAttribute(named name: String) -> Bool {
    anySatisfy { $0.isAttribute(named: name) }
  }
  
}
