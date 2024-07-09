import Testing
import MacroToolboxTestSupport
@testable import MacroToolbox

@Test(
  "`InlinabilityDisposition.description` uniqueness",
  .tags(.inlinabilityDisposition)
)
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

@Test(
  "`InlinabilityDisposition.debugDescription` uniqueness",
  .tags(.inlinabilityDisposition)
)
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

@Test(
  "`InlinabilityDisposition.caseNameWithoutLeadingDot` uniqueness",
  .tags(.inlinabilityDisposition)
)
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
