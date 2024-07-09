import SwiftSyntax

extension ExplicitInlineDisposition {
  
  /// Obtains the disposition's textual representation (e.g. suitable for `"\(raw: )"` interpolation).
  @inlinable
  public var sourceCodeStringRepresentation: String {
    switch self {
    case .always:
      "@inline(__always)"
    case .never:
      "@inline(never)"
    }
  }
  
}

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
    guard
      attributeSyntax.hasAtSign,
      let identifier = attributeSyntax.attributeName.as(IdentifierTypeSyntax.self),
      identifier.name.tokenKind == .identifier("inline")
    else {
      return nil
    }
    
    print("attributeSyntax.arguments: \(String(describing: attributeSyntax.arguments))")
    if case .token(let token) = attributeSyntax.arguments {
      self.init(attributeArgument: "\(token.text)")
    } else if
      case .argumentList(let arguments) = attributeSyntax.arguments,
      arguments.count == 1,
      let firstArgument = arguments.first,
      firstArgument.label == nil {
      self.init(attributeArgument: "\(firstArgument.expression)")
    } else {
      return nil
    }
              
    
    return nil
  }
  
}

