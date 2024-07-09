import Testing
import MacroToolboxTestSupport
@testable import MacroToolbox


@Test(
  "`VisibilityLevel.description` uniqueness",
  .tags(.visibilityLevel)
)
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

@Test(
  "`VisibilityLevel.debugDescription` uniqueness",
  .tags(.visibilityLevel)
)
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

@Test(
  "`VisibilityLevel.caseNameWithoutLeadingDot` uniqueness",
  .tags(.visibilityLevel)
)
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

