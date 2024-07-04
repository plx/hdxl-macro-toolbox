import Testing
@testable import MacroToolbox

@Test("`VisibilityLevel.description` uniqueness")
func testVisibilityLevelDescriptionUniqueness() {
  #expect(
    VisibilityLevel
      .allCases
      .count
    ==
    Set(
      VisibilityLevel
        .allCases
        .lazy
        .map(\.description)
    ).count
  )
}

@Test("`VisibilityLevel.debugDescription` uniqueness")
func testVisibilityLevelDebugDescriptionUniqueness() {
  #expect(
    VisibilityLevel
      .allCases
      .count
    ==
    Set(
      VisibilityLevel
        .allCases
        .lazy
        .map(\.debugDescription)
    ).count
  )
}

@Test("`VisibilityLevel.caseNameWithoutLeadingDot` uniqueness")
func testVisibilityLevelCaseNameWithoutLeadingDotUniqueness() {
  #expect(
    VisibilityLevel
      .allCases
      .count
    ==
    Set(
      VisibilityLevel
        .allCases
        .lazy
        .map(\.caseNameWithoutLeadingDot)
    ).count
  )
}

