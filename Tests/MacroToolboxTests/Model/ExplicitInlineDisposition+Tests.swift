import Testing
import MacroToolboxTestSupport
@testable import MacroToolbox

@Test(
  "`ExplicitInlineDisposition.description` uniqueness",
  .tags(.explicitInlineDisposition)
)
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

@Test(
  "`ExplicitInlineDisposition.debugDescription` uniqueness",
  .tags(.explicitInlineDisposition)
)
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

@Test(
  "`ExplicitInlineDisposition.caseNameWithoutLeadingDot` uniqueness",
  .tags(.explicitInlineDisposition)
)
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
