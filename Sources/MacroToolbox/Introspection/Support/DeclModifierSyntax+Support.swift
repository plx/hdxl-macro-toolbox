import SwiftSyntax

extension DeclModifierSyntax {
  
  /// The visibility level represented by this decl-modifier (if there is one).
  @inlinable
  public var visibilityLevel: VisibilityLevel? {
    name.tokenKind.visibilityLevel
  }
  
}
