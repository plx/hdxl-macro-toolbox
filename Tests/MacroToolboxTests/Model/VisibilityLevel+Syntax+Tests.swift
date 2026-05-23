import SwiftSyntax
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

@Test(
  "`VisibilityLevel` syntax conveniences render tokens and source strings",
  .tags(
    .visibilityLevel,
    .syntaxInteroperation,
    .keyword
  )
)
func testVisibilityLevelSyntaxConveniencesRenderTokensAndSourceStrings() {
  // Hand-written examples: visibility levels should produce keyword tokens,
  // token kinds, and source strings suitable for generated Swift declarations.
  let token = VisibilityLevel.public.tokenRepresentation(
    leadingTrivia: .spaces(1),
    trailingTrivia: .spaces(1)
  )
  let initializedToken = TokenSyntax(
    leadingTrivia: .spaces(1),
    visibilityLevel: .public,
    trailingTrivia: .spaces(1)
  )

  #expect(token.description == " public ")
  #expect(initializedToken.description == " public ")
  #expect(VisibilityLevel.public.tokenKindRepresentation == .keyword(.public))
  #expect(TokenKind(visibilityLevel: .public) == .keyword(.public))
  #expect(Keyword(visibilityLevel: .public) == .public)
  #expect(VisibilityLevel.public.sourceCodeStringRepresentation == "public")
  #expect(VisibilityLevel(keywordRepresentation: .func) == nil)
  #expect(TokenKind.identifier("public").visibilityLevel == nil)
}

@Test(
  "`VisibilityLevel` syntax conveniences round-trip all cases",
  .tags(
    .visibilityLevel,
    .syntaxInteroperation,
    .keyword
  ),
  arguments: VisibilityLevel.allCases
)
func testVisibilityLevelSyntaxConveniencesRoundTripAllCases(
  visibilityLevel: VisibilityLevel
) {
  // Property-style test: every visibility level should have a mutually
  // consistent keyword, token kind, token syntax, and source-string spelling.
  #expect(Keyword(visibilityLevel: visibilityLevel) == visibilityLevel.keywordRepresentation)
  #expect(TokenKind(visibilityLevel: visibilityLevel).visibilityLevel == visibilityLevel)
  #expect(TokenSyntax(visibilityLevel: visibilityLevel).tokenKind.visibilityLevel == visibilityLevel)
  #expect(visibilityLevel.tokenRepresentation().text == visibilityLevel.sourceCodeStringRepresentation)
  #expect(visibilityLevel.sourceCodeStringRepresentation == visibilityLevel.caseNameWithoutLeadingDot)
}
