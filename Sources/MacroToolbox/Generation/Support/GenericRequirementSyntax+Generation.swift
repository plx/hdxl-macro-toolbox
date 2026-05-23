import SwiftSyntax

extension GenericRequirementSyntax {
  
  public static func requirement(
    that typeName: String,
    inheritsFrom otherTypeName: String
  ) -> Self {
    GenericRequirementSyntax(
      requirement: .conformanceRequirement(
        ConformanceRequirementSyntax(
          leftType: IdentifierTypeSyntax.forType(
            named: typeName
          ),
          colon: .colonToken(trailingTrivia: .space),
          rightType: IdentifierTypeSyntax.forType(
            named: otherTypeName
          )
        )
      )
    )
  }
  
}
