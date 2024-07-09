import Testing
@testable import MacroToolbox

@Test("`PerformanceAnnotationAttachmentSite.description` uniqueness")
func testPerformanceAnnotationAttachmentSiteDescriptionUniqueness() {
  #expect(
    PerformanceAnnotationAttachmentSite
      .allCases
      .count
    ==
    Set(
      PerformanceAnnotationAttachmentSite
        .allCases
        .lazy
        .map(\.description)
    ).count
  )
}

@Test("`PerformanceAnnotationAttachmentSite.debugDescription` uniqueness")
func testPerformanceAnnotationAttachmentSiteDebugDescriptionUniqueness() {
  #expect(
    PerformanceAnnotationAttachmentSite
      .allCases
      .count
    ==
    Set(
      PerformanceAnnotationAttachmentSite
        .allCases
        .lazy
        .map(\.debugDescription)
    ).count
  )
}

@Test("`PerformanceAnnotationAttachmentSite.caseNameWithoutLeadingDot` uniqueness")
func testPerformanceAnnotationAttachmentSiteCaseNameWithoutLeadingDotUniqueness() {
  #expect(
    PerformanceAnnotationAttachmentSite
      .allCases
      .count
    ==
    Set(
      PerformanceAnnotationAttachmentSite
        .allCases
        .lazy
        .map(\.caseNameWithoutLeadingDot)
    ).count
  )
}
