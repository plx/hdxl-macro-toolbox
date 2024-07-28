import SwiftSyntax

extension IdentifierTypeSyntax {
  
  /// Shortand to get to `IdentifierTypeSyntax` for the type named `name`.
  public static func forType(named name: String) -> Self {
    Self(
      name: .identifier(name)
    )
  }
  
}
