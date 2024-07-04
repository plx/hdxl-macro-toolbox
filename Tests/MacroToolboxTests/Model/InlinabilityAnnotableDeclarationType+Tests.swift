import Testing
@testable import MacroToolbox

@Test("`InlinabilityAnnotableDeclarationType.description` uniqueness")
func testInlinabilityAnnotableDeclarationTypeDescriptionUniqueness() {
  #expect(
    InlinabilityAnnotableDeclarationType
      .allCases
      .count
    ==
    Set(
      InlinabilityAnnotableDeclarationType
        .allCases
        .lazy
        .map(\.description)
    ).count
  )
}

@Test("`InlinabilityAnnotableDeclarationType.debugDescription` uniqueness")
func testInlinabilityAnnotableDeclarationTypeDebugDescriptionUniqueness() {
  #expect(
    InlinabilityAnnotableDeclarationType
      .allCases
      .count
    ==
    Set(
      InlinabilityAnnotableDeclarationType
        .allCases
        .lazy
        .map(\.debugDescription)
    ).count
  )
}

@Test("`InlinabilityAnnotableDeclarationType.caseNameWithoutLeadingDot` uniqueness")
func testInlinabilityAnnotableDeclarationTypeCaseNameWithoutLeadingDotUniqueness() {
  #expect(
    InlinabilityAnnotableDeclarationType
      .allCases
      .count
    ==
    Set(
      InlinabilityAnnotableDeclarationType
        .allCases
        .lazy
        .map(\.caseNameWithoutLeadingDot)
    ).count
  )
}
