import SwiftSyntax

extension DeclModifierSyntax {
  
  @inlinable
  public var visibilityLevel: VisibilityLevel? {
    name.tokenKind.visibilityLevel
  }
  
}
