import SwiftSyntax

extension IdentifierTypeSyntax {
  
  public static func forType(
    named name: String
  ) -> Self {
    Self(
      name: .identifier(name)
    )
  }
  
}
