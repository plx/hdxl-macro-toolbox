import SwiftSyntax

extension GenericParameterSyntax {
  
  @inlinable
  public var simpleGenericParameterName: String? {
    guard
      eachKeyword == nil,
      case .identifier = name.tokenKind,
      !name.text.isEmpty
    else {
      return nil
    }
    
    return name.text
  }
  
}

