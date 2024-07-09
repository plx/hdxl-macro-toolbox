import Testing
import MacroToolboxTestSupport
@testable import MacroToolbox

@Test(
  "`PerformanceAnnotationAttachmentSite.description` uniqueness",
  .tags(.performanceAnnotationAttachmentSite)
)
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

@Test(
  "`PerformanceAnnotationAttachmentSite.debugDescription` uniqueness",
  .tags(.performanceAnnotationAttachmentSite)
)
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

@Test(
  "`PerformanceAnnotationAttachmentSite.caseNameWithoutLeadingDot` uniqueness",
  .tags(.performanceAnnotationAttachmentSite)
)
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
