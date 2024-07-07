import SwiftSyntax

extension AttributeListSyntax {
  
  @inlinable
  public func containsAttribute(named name: String) -> Bool {
    anySatisfy { $0.isAttribute(named: name) }
  }
  
}
