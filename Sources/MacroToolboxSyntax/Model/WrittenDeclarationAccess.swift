import MacroToolboxModels
import SwiftSyntax

/// Access modifiers written on one declaration, without enclosing-scope or module inference.
/// Every modifier is retained. Strict analysis rejects duplicate/conflicting access modifiers.
public struct WrittenDeclarationAccess: Sendable, Equatable, Hashable {
  public let modifiers: DeclModifierListSyntax

  public init(modifiers: DeclModifierListSyntax) { self.modifiers = modifiers }

  public var readModifiers: [DeclModifierSyntax] { modifiers.filter { $0.visibilityLevel != nil } }
  public var setterModifiers: [DeclModifierSyntax] { modifiers.filter { $0.setterVisibilityLevel != nil } }
  public var explicitReadAccess: VisibilityLevel? { readModifiers.first?.visibilityLevel }
  public var explicitSetterAccess: VisibilityLevel? { setterModifiers.first?.setterVisibilityLevel }

  /// Local missing-keyword default only. This is not effective access across enclosing scopes,
  /// extensions, packages, or protocol requirements. Validate modifier findings before using it.
  public var localReadAccess: VisibilityLevel { explicitReadAccess ?? .internal }
}
