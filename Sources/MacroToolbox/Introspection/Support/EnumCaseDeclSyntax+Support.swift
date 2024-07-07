import SwiftSyntax

extension EnumCaseDeclSyntax {
  
  @inlinable
  public var isSimpleCaseWithoutPayload: Bool {
    elements.isSimpleCaseWithoutPayload
  }
  
  @inlinable
  public func hasAttribute(named attributeName: String) -> Bool {
    attributes.containsAttribute(named: attributeName)
  }
  
  @inlinable
  public var primarySourceCodeIdentifier: TokenSyntax? {
    elements.primarySourceCodeIdentifier
  }
  
}
