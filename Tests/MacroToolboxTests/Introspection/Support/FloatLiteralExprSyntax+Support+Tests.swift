import Testing
import SwiftSyntax
import MacroToolboxTestSupport
@testable import MacroToolbox

@Test(
  "`FloatLiteralExprSyntax.representedFloatLiteralValue`",
  .tags(
    .syntaxIntrospection,
    .floatLiteralExprSyntax
  )
)
func testFloatLiteralExprSyntaxRepresentedFloatLiteralValue() {
  // Test positive values
  #expect(
    42.5
    ==
    FloatLiteralExprSyntax(
      literal: .floatLiteral("42.5")
    ).representedFloatLiteralValue
  )
  
  // Test negative values
  #expect(
    -123.75
    ==
    FloatLiteralExprSyntax(
      literal: .floatLiteral("-123.75")
    ).representedFloatLiteralValue
  )
  
  // Test zero
  #expect(
    0.0
    ==
    FloatLiteralExprSyntax(
      literal: .floatLiteral("0.0")
    ).representedFloatLiteralValue
  )
  
  // Test scientific notation
  #expect(
    1.234e5
    ==
    FloatLiteralExprSyntax(
      literal: .floatLiteral("1.234e5")
    ).representedFloatLiteralValue
  )
  
  // Test with invalid float format
  #expect(
    nil
    ==
    FloatLiteralExprSyntax(
      literal: .floatLiteral("not_a_float")
    ).representedFloatLiteralValue
  )
  
  // Test with special values
  #expect(
    Double.infinity
    ==
    FloatLiteralExprSyntax(
      literal: .floatLiteral("Infinity")
    ).representedFloatLiteralValue
  )
  
  #expect(
    -Double.infinity
    ==
    FloatLiteralExprSyntax(
      literal: .floatLiteral("-Infinity")
    ).representedFloatLiteralValue
  )
  
  // Test with NaN (using isNaN as direct equality comparison doesn't work with NaN)
  #expect(
    FloatLiteralExprSyntax(
      literal: .floatLiteral("NaN")
    ).representedFloatLiteralValue?.isNaN == true
  )
}