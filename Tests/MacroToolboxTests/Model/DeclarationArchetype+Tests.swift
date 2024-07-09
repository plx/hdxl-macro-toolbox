import Testing
import MacroToolboxTestSupport
@testable import MacroToolbox

@Test(
  "`DeclarationArchetype.description` uniqueness",
  .tags(.declarationArchetype)
)
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

@Test(
  "`DeclarationArchetype.debugDescription` uniqueness",
  .tags(.declarationArchetype)
)
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

@Test(
  "`DeclarationArchetype.caseNameWithoutLeadingDot` uniqueness",
  .tags(.declarationArchetype)
)
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
