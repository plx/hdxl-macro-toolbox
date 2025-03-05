import Testing
import SwiftSyntax
import MacroToolboxTestSupport
@testable import MacroToolbox


@Test(
  "`IntegerLiteralExprSyntax.representedIntegerLiteralValue`",
  .tags(
    .syntaxIntrospection,
    .integerLiteralExprSyntax
  )
)
func testIntegerLiteralExprSyntaxRepresentedIntegerLiteralValue() {
  #expect(
    42
    ==
    IntegerLiteralExprSyntax(
      literal: .integerLiteral("42")
    ).representedIntegerLiteralValue
  )
  
  #expect(
    -123
    ==
    IntegerLiteralExprSyntax(
      literal: .integerLiteral("-123")
    ).representedIntegerLiteralValue
  )
  
  #expect(
    0
    ==
    IntegerLiteralExprSyntax(
      literal: .integerLiteral("0")
    ).representedIntegerLiteralValue
  )
  
  // Test with invalid integer format
  #expect(
    nil
    ==
    IntegerLiteralExprSyntax(
      literal: .integerLiteral("not_an_integer")
    ).representedIntegerLiteralValue
  )
}

@Test(
  "`IntegerLiteralExprSyntax.representedValue(ofType:)`",
  .tags(
    .syntaxIntrospection,
    .integerLiteralExprSyntax
  )
)
func testIntegerLiteralExprSyntaxRepresentedValueOfType() {
  // Test with UInt8
  #expect(
    UInt8(42)
    ==
    IntegerLiteralExprSyntax(
      literal: .integerLiteral("42")
    ).representedValue(ofType: UInt8.self)
  )
  
  // Test with Int16
  #expect(
    Int16(-123)
    ==
    IntegerLiteralExprSyntax(
      literal: .integerLiteral("-123")
    ).representedValue(ofType: Int16.self)
  )
  
  // Test with Int64
  #expect(
    Int64(9223372036854775807)
    ==
    IntegerLiteralExprSyntax(
      literal: .integerLiteral("9223372036854775807")
    ).representedValue(ofType: Int64.self)
  )
  
  // Test with value that doesn't fit in Int but fits in UInt64
  #expect(
    UInt64(18446744073709551615)
    ==
    IntegerLiteralExprSyntax(
      literal: .integerLiteral("18446744073709551615")
    ).representedValue(ofType: UInt64.self)
  )
  
  // Test overflow case for UInt8
  #expect(
    nil
    ==
    IntegerLiteralExprSyntax(
      literal: .integerLiteral("256")
    ).representedValue(ofType: UInt8.self)
  )
  
  // Test invalid integer format
  #expect(
    nil
    ==
    IntegerLiteralExprSyntax(
      literal: .integerLiteral("not_an_integer")
    ).representedValue(ofType: Int.self)
  )
}