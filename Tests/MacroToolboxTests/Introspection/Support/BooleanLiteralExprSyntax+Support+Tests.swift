import Testing
import SwiftSyntax

@testable import MacroToolbox

@Test("`BooleanLiteralExprSyntax.representedBooleanLiteralValue`")
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
