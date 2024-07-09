import Testing
@testable import MacroToolbox

@Test("`ExplicitInlineDisposition.description` uniqueness")
func testExplicitInlineDispositionDescriptionUniqueness() {
  #expect(
    ExplicitInlineDisposition
      .allCases
      .count
    ==
    Set(
      ExplicitInlineDisposition
        .allCases
        .lazy
        .map(\.description)
    ).count
  )
}

@Test("`ExplicitInlineDisposition.debugDescription` uniqueness")
func testExplicitInlineDispositionDebugDescriptionUniqueness() {
  #expect(
    ExplicitInlineDisposition
      .allCases
      .count
    ==
    Set(
      ExplicitInlineDisposition
        .allCases
        .lazy
        .map(\.debugDescription)
    ).count
  )
}

@Test("`ExplicitInlineDisposition.caseNameWithoutLeadingDot` uniqueness")
func testExplicitInlineDispositionCaseNameWithoutLeadingDotUniqueness() {
  #expect(
    ExplicitInlineDisposition
      .allCases
      .count
    ==
    Set(
      ExplicitInlineDisposition
        .allCases
        .lazy
        .map(\.caseNameWithoutLeadingDot)
    ).count
  )
}
