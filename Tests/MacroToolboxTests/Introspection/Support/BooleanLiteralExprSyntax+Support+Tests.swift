import Testing
import SwiftSyntax
import MacroToolboxTestSupport
@testable import MacroToolbox

@Test(
  "`BooleanLiteralExprSyntax.representedBooleanLiteralValue`",
  .tags(
    .syntaxIntrospection,
    .booleanLiteralExprSyntax
  )
)
func testBooleanLiteralExprSyntaxRepresentedBooleanLiteralValue() {
  #expect(
    true
    ==
    BooleanLiteralExprSyntax(
      literal: .keyword(.true)
    ).representedBooleanLiteralValue
  )
  
  #expect(
    false 
    ==
    BooleanLiteralExprSyntax(
      literal: .keyword(.false)
    ).representedBooleanLiteralValue
  )
}
