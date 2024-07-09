import SwiftSyntax
import SwiftParser
import Testing
import MacroToolboxTestSupport
@testable import MacroToolbox

@Test(
  "`InlinabilityDisposition.sourceCodeStringRepresentation` (.inlinable)",
  .tags(
    .inlinabilityDisposition,
    .syntaxInteroperation
  )
)
func testInlinabilityDispositionSourceCodeStringRepresentation_inlinable() {
  #expect(
    "@inlinable"
    ==
    InlinabilityDisposition.inlinable.sourceCodeStringRepresentation
  )
}

@Test(
  "`InlinabilityDisposition.sourceCodeStringRepresentation`  (.usableFromInline)",
  .tags(
    .inlinabilityDisposition,
    .syntaxInteroperation
  )
)
func testInlinabilityDispositionSourceCodeStringRepresentation() {
  #expect(
    "@usableFromInline"
    ==
    InlinabilityDisposition.usableFromInline.sourceCodeStringRepresentation
  )
}

@Test(
  "`InlinabilityDisposition(tokenSyntax:)` (@inlinable)",
  .tags(
    .inlinabilityDisposition,
    .syntaxInteroperation,
    .tokenSyntax
  )
)
func testInlinabilityDispositionInitTokenSyntax_inlinable() throws {
  let inlinable = try #require(
    InlinabilityDisposition(tokenSyntax: TokenSyntax("inlinable"))
  )
  #expect(inlinable == .inlinable)
}

@Test(
  "`InlinabilityDisposition(tokenSyntax:)` (@usableFromInline)",
  .tags(
    .inlinabilityDisposition,
    .syntaxInteroperation,
    .tokenSyntax
  )
)
func testInlinabilityDispositionInitTokenSyntax_usableFromInline() throws {
  let usableFromInline = try #require(
    InlinabilityDisposition(tokenSyntax: TokenSyntax("usableFromInline"))
  )
  #expect(usableFromInline == .usableFromInline)
}

@Test(
  "`InlinabilityDisposition(attributeSyntax:)` (@inlinable)",
  .tags(
    .inlinabilityDisposition,
    .syntaxInteroperation,
    .attributeSyntax
  )
)
func testInlinabilityDispositionAttributeTokenSyntax_inlinable() throws {
  let inlinable = try #require(
    InlinabilityDisposition(attributeSyntax: AttributeSyntax("@inlinable"))
  )
  #expect(inlinable == .inlinable)
}

@Test(
  "`InlinabilityDisposition(attributeSyntax:)` (@usableFromInline)",
  .tags(
    .inlinabilityDisposition,
    .syntaxInteroperation,
    .attributeSyntax
  )
)
func testInlinabilityDispositionInitAttributeSyntax_usableFromInline() throws {
  let usableFromInline = try #require(
    InlinabilityDisposition(attributeSyntax: AttributeSyntax("@usableFromInline"))
  )
  #expect(usableFromInline == .usableFromInline)
}
