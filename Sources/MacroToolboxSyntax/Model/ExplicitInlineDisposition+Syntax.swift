import MacroToolboxModels
import SwiftSyntax



extension ExplicitInlineDisposition {
  
  @inlinable
  package init?(attributeArgument: String) {
    switch attributeArgument {
    case "__always":
      self = .always
    case "never":
      self = .never
    default:
      return nil
    }
  }
    
  @inlinable
  public init?(attributeSyntax: AttributeSyntax) {
    switch "\(attributeSyntax._syntaxNode)" {
    case "@inline(__always)":
      self = .always
    case "@inline(never)":
      self = .never
    default:
      return nil
    }
  }
  
}
