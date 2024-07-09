import SwiftSyntax
import SwiftParser
import Testing
@testable import MacroToolbox

@Test("`ExplicitInlineDisposition.sourceCodeStringRepresentation` (.always)")
func testExplicitInlineDispositionSourceCodeStringRepresentation_inlinable() {
  #expect(
    "@inline(__always)"
    ==
    ExplicitInlineDisposition.always.sourceCodeStringRepresentation
  )
}

@Test("`ExplicitInlineDisposition.sourceCodeStringRepresentation`  (.never)")
func testExplicitInlineDispositionSourceCodeStringRepresentation() {
  #expect(
    "@inline(never)"
    ==
    ExplicitInlineDisposition.never.sourceCodeStringRepresentation
  )
}

@Test("`ExplicitInlineDisposition(attributeSyntax:)` (@inline(__always))")
func testExplicitInlineDispositionAttributeTokenSyntax_inlinable() throws {
  let always = try #require(
    ExplicitInlineDisposition(attributeSyntax: AttributeSyntax("@inline(__always)"))
  )
  #expect(always == .always)
}

@Test("`ExplicitInlineDisposition(attributeSyntax:)` (@inline(never))")
func testExplicitInlineDispositionInitAttributeSyntax_usableFromInline() throws {
  let never = try #require(
    ExplicitInlineDisposition(attributeSyntax: AttributeSyntax("@inline(never)"))
  )
  #expect(never == .never)
}
