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

@Test(
  "`VisibilityLevel` ordering and privacy tier semantics",
  .tags(.visibilityLevel)
)
func testVisibilityLevelOrderingAndPrivacyTierSemantics() {
  // Hand-written examples: access levels are ordered from most restrictive to
  // least restrictive by their raw value, and only Swift's private tier is
  // classified as private-tier visibility.
  #expect(VisibilityLevel.private < .fileprivate)
  #expect(VisibilityLevel.fileprivate < .internal)
  #expect(VisibilityLevel.public < .open)
  #expect(VisibilityLevel.private.isWithinPrivateTier)
  #expect(VisibilityLevel.fileprivate.isWithinPrivateTier)
  #expect(!VisibilityLevel.internal.isWithinPrivateTier)
}

@Test(
  "`VisibilityLevel` ordering matches raw-value ordering",
  .tags(.visibilityLevel)
)
func testVisibilityLevelOrderingMatchesRawValueOrdering() {
  // Property-style test: comparison and privacy-tier classification should match
  // the model's independent raw-value ordering and the explicit private set for
  // every case.
  let orderedByRawValue = VisibilityLevel.allCases.sorted { lhs, rhs in
    lhs.rawValue < rhs.rawValue
  }

  #expect(VisibilityLevel.allCases.sorted() == orderedByRawValue)

  for visibilityLevel in VisibilityLevel.allCases {
    #expect(
      visibilityLevel.isWithinPrivateTier
      ==
      [.private, .fileprivate].contains(visibilityLevel)
    )
  }
}
