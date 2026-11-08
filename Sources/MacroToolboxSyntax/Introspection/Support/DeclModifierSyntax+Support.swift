import MacroToolboxModels
import SwiftSyntax

extension DeclModifierSyntax {
  
  /// Written declaration/read access. Setter-only modifiers such as `private(set)` return nil.
  @inlinable
  public var visibilityLevel: VisibilityLevel? {
    detail == nil ? name.tokenKind.visibilityLevel : nil
  }

  /// Written setter access, independent of declaration/read access.
  @inlinable
  public var setterVisibilityLevel: VisibilityLevel? {
    detail?.detail.text == "set" ? name.tokenKind.visibilityLevel : nil
  }
  
}
