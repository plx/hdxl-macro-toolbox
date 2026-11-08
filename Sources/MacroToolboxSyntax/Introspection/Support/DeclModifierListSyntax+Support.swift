import MacroToolboxModels
import SwiftSyntax

extension DeclModifierListSyntax {
  
  /// First written declaration/read access, ignoring setter-only modifiers. No enclosing default
  /// or effective-access calculation is performed; strict analysis also checks duplicates.
  @inlinable
  public var visibilityLevel: VisibilityLevel? {
    firstNonNilValue(\.visibilityLevel)
  }

  @inlinable
  public var setterVisibilityLevel: VisibilityLevel? {
    firstNonNilValue(\.setterVisibilityLevel)
  }
  
}
