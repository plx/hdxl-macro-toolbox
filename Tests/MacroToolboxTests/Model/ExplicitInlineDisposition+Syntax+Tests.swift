import SwiftSyntax
import SwiftParser
import Testing
import MacroToolboxTestSupport
@testable import MacroToolbox

@Test(
  "`ExplicitInlineDisposition.sourceCodeStringRepresentation` (.always)",
  .tags(
    .explicitInlineDisposition,
    .syntaxInteroperation
  )
)
func testExplicitInlineDispositionSourceCodeStringRepresentation_inlinable() {
  #expect(
    "@inline(__always)"
    ==
    ExplicitInlineDisposition.always.sourceCodeStringRepresentation
  )
}

@Test(
  "`ExplicitInlineDisposition.sourceCodeStringRepresentation`  (.never)",
  .tags(
    .explicitInlineDisposition,
    .syntaxInteroperation
  )
)
func testExplicitInlineDispositionSourceCodeStringRepresentation() {
  #expect(
    "@inline(never)"
    ==
    ExplicitInlineDisposition.never.sourceCodeStringRepresentation
  )
}

@Test(
  "`ExplicitInlineDisposition(attributeSyntax:)` (@inline(__always))",
  .tags(
    .explicitInlineDisposition,
    .syntaxInteroperation,
    .attributeSyntax
  )
)
func testExplicitInlineDispositionAttributeTokenSyntax_inlinable() throws {
  let always = try #require(
    ExplicitInlineDisposition(attributeSyntax: AttributeSyntax("@inline(__always)"))
  )
  #expect(always == .always)
}

@Test(
  "`ExplicitInlineDisposition(attributeSyntax:)` (@inline(never))",
  .tags(
    .explicitInlineDisposition,
    .syntaxInteroperation,
    .attributeSyntax
  )
)
func testExplicitInlineDispositionInitAttributeSyntax_usableFromInline() throws {
  let never = try #require(
    ExplicitInlineDisposition(attributeSyntax: AttributeSyntax("@inline(never)"))
  )
  #expect(never == .never)
}
