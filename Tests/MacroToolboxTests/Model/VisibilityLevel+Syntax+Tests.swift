import Testing
import MacroToolboxTestSupport
@testable import MacroToolbox

@Test(
  "`VisibilityLevel.keywordRepresentation`",
  .tags(
    .visibilityLevel,
    .syntaxInteroperation,
    .keyword
  )
)
func testVisibilityLevelKeywordRepresentation() {
  #expect(
    VisibilityLevel.private.keywordRepresentation
    ==
    .private
  )
  #expect(
    VisibilityLevel.fileprivate.keywordRepresentation
    ==
    .fileprivate
  )
  #expect(
    VisibilityLevel.internal.keywordRepresentation
    ==
    .internal
  )
  #expect(
    VisibilityLevel.package.keywordRepresentation
    ==
    .package
  )
  #expect(
    VisibilityLevel.public.keywordRepresentation
    ==
    .public
  )
  #expect(
    VisibilityLevel.open.keywordRepresentation
    ==
    .open
  )
}

@Test(
  "`VisibilityLevel.keywordRepresentation` (round-trips)",
  .tags(
    .visibilityLevel,
    .syntaxInteroperation,
    .keyword
  ),
  arguments: VisibilityLevel.allCases
)
func testVisibilityLevelKeywordRepresentationRoundTrip(
  visibilityLevel: VisibilityLevel
) {
  #expect(
    visibilityLevel
    ==
    VisibilityLevel(keywordRepresentation: visibilityLevel.keywordRepresentation)
  )
}
