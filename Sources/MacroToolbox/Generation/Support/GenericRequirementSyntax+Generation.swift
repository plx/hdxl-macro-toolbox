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
          rightType: IdentifierTypeSyntax.forType(
            named: otherTypeName
          )
        )
      )
    )
  }
  
}
