import Testing
@testable import MacroToolbox

@Test(
  "`DeclarationArchetype.caseNameWithoutLeadingDot` uniqueness."
)
func testDeclarationArchetypeCaseNameWithoutLeadingDotUniqueness() {
  #expect(
    Set(DeclarationArchetype
      .allCases
      .map(\.caseNameWithoutLeadingDot)
    ).count
    ==
    DeclarationArchetype.allCases.count
  )
}

