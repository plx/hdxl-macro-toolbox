import SwiftSyntax
import SwiftParser
import Testing
@testable import MacroToolbox

@Test("`InlinabilityDisposition.sourceCodeStringRepresentation` (.inlinable)")
func testInlinabilityDispositionSourceCodeStringRepresentation_inlinable() {
  #expect(
    "@inlinable"
    ==
    InlinabilityDisposition.inlinable.sourceCodeStringRepresentation
  )
}

@Test("`InlinabilityDisposition.sourceCodeStringRepresentation`  (.usableFromInline)")
func testInlinabilityDispositionSourceCodeStringRepresentation() {
  #expect(
    "@usableFromInline"
    ==
    InlinabilityDisposition.usableFromInline.sourceCodeStringRepresentation
  )
}

@Test("`InlinabilityDisposition(tokenSyntax:)` (@inlinable)")
func testInlinabilityDispositionInitTokenSyntax_inlinable() throws {
  let inlinable = try #require(
    InlinabilityDisposition(tokenSyntax: TokenSyntax("inlinable"))
  )
  #expect(inlinable == .inlinable)
}

@Test("`InlinabilityDisposition(tokenSyntax:)` (@usableFromInline)")
func testInlinabilityDispositionInitTokenSyntax_usableFromInline() throws {
  let usableFromInline = try #require(
    InlinabilityDisposition(tokenSyntax: TokenSyntax("usableFromInline"))
  )
  #expect(usableFromInline == .usableFromInline)
}

@Test("`InlinabilityDisposition(attributeSyntax:)` (@inlinable)")
func testInlinabilityDispositionAttributeTokenSyntax_inlinable() throws {
  let inlinable = try #require(
    InlinabilityDisposition(attributeSyntax: AttributeSyntax("@inlinable"))
  )
  #expect(inlinable == .inlinable)
}

@Test("`InlinabilityDisposition(attributeSyntax:)` (@usableFromInline)")
func testInlinabilityDispositionInitAttributeSyntax_usableFromInline() throws {
  let usableFromInline = try #require(
    InlinabilityDisposition(attributeSyntax: AttributeSyntax("@usableFromInline"))
  )
  #expect(usableFromInline == .usableFromInline)
}
