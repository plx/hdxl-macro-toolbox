import Testing
@testable import MacroToolbox

@Test("`InlinabilityDisposition.description` uniqueness")
func testInlinabilityDispositionDescriptionUniqueness() {
  #expect(
    InlinabilityDisposition
      .allCases
      .count
    ==
    Set(
      InlinabilityDisposition
        .allCases
        .lazy
        .map(\.description)
    ).count
  )
}

@Test("`InlinabilityDisposition.debugDescription` uniqueness")
func testInlinabilityDispositionDebugDescriptionUniqueness() {
  #expect(
    InlinabilityDisposition
      .allCases
      .count
    ==
    Set(
      InlinabilityDisposition
        .allCases
        .lazy
        .map(\.debugDescription)
    ).count
  )
}

@Test("`InlinabilityDisposition.caseNameWithoutLeadingDot` uniqueness")
func testInlinabilityDispositionCaseNameWithoutLeadingDotUniqueness() {
  #expect(
    InlinabilityDisposition
      .allCases
      .count
    ==
    Set(
      InlinabilityDisposition
        .allCases
        .lazy
        .map(\.caseNameWithoutLeadingDot)
    ).count
  )
}
