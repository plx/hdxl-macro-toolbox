import SwiftSyntax

extension DeclModifierListSyntax {
  
  /// The visibility level represented by this decl-modifier (if there is one).
  @inlinable
  public var visibilityLevel: VisibilityLevel? {
    firstNonNilValue(\.visibilityLevel)
  }
  
}
