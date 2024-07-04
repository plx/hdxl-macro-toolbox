import Testing
@testable import MacroToolbox

@Test("`DeclarationArchetype.description` uniqueness")
func testDeclarationArchetypeDescriptionUniqueness() {
  #expect(
    DeclarationArchetype
      .allCases
      .count
    ==
    Set(
      DeclarationArchetype
        .allCases
        .lazy
        .map(\.description)
    ).count
  )
}

@Test("`DeclarationArchetype.debugDescription` uniqueness")
func testDeclarationArchetypeDebugDescriptionUniqueness() {
  #expect(
    DeclarationArchetype
      .allCases
      .count
    ==
    Set(
      DeclarationArchetype
        .allCases
        .lazy
        .map(\.debugDescription)
    ).count
  )
}

@Test("`DeclarationArchetype.caseNameWithoutLeadingDot` uniqueness")
func testDeclarationArchetypeCaseNameWithoutLeadingDotUniqueness() {
  #expect(
    DeclarationArchetype
      .allCases
      .count
    ==
    Set(
      DeclarationArchetype
        .allCases
        .lazy
        .map(\.caseNameWithoutLeadingDot)
    ).count
  )
}
