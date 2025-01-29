import SwiftSyntax
import SwiftSyntaxBuilder

extension InlinabilityDisposition {

  /// Obtains the disposition's textual representation (e.g. suitable for `"\(raw: )"` interpolation).
  @inlinable
  public var sourceCodeStringRepresentation: String {
    switch self {
    case .usableFromInline:
      "@usableFromInline"
    case .inlinable:
      "@inlinable"
    }
  }
  
}

extension InlinabilityDisposition {
  
  @inlinable
  public init?(tokenSyntax: TokenSyntax) {
    switch tokenSyntax.text {
    case "usableFromInline":
      self = .usableFromInline
    case "inlinable":
      self = .inlinable
    default:
      return nil
    }
  }

  @inlinable
  public init?(attributeSyntax: AttributeSyntax) {
    guard 
      attributeSyntax.hasAtSign,
      attributeSyntax.hasNoArguments,
      let identifier = attributeSyntax.attributeName.as(IdentifierTypeSyntax.self)
    else {
      return nil
    }
    
    self.init(tokenSyntax: identifier.name)
  }

  @inlinable
  public init?(attributeListElement: AttributeListSyntax.Element) {
    guard let attributeSyntax = attributeListElement.attributeSyntax else {
      return nil
    }
    
    self.init(
      attributeSyntax: attributeSyntax
    )
  }
  
  @inlinable
  public var attributeSyntax: AttributeSyntax {
    switch self {
    case .usableFromInline:
      "@usableFromInline"
    case .inlinable:
      "@inlinable"
    }
  }

}
