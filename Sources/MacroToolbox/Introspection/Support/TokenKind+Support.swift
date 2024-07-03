import SwiftSyntax

extension TokenKind {
  
  @inlinable
  public var visibilityLevel: VisibilityLevel? {
    guard case .keyword(let keyword) = self else {
      return nil
    }
    
    return keyword.visibilityLevel
  }
  
}
