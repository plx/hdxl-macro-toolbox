import Testing
import SwiftSyntax
import SwiftParser
import MacroToolbox
import MacroTransflection
@testable import MacroTransflectionMacroSupport

// MARK: - Tests

@Test(
  "`String.init(transflectingExprSyntax:)` (positive examples)",
  arguments: positiveExamples(forType: String.self)
)
func testStringInitTransflectingExprSyntax_negativeExamples(
  example: PositiveTransflectionExample<String>
) throws {
  try validatePositiveExample(example: example)
}

// MARK: - Tests - Optional

@Test(
  "`String?.init(transflectingExprSyntax:)` (positive examples)",
  arguments: positiveExamples(
    forType: String.self
  ).map(\.optionalized)
)
func testOptionalStringInitTransflectingExprSyntax_negativeExamples(
  example: PositiveTransflectionExample<String?>
) throws {
  try validatePositiveExample(example: example)
}

// MARK: - Examples

fileprivate func positiveExamples<T>(
  forType type: T.Type
) -> some Sendable & Collection<PositiveTransflectionExample<T>>
where
T: Sendable,
T: StringProtocol,
T: TransflectableViaExprSyntax
{
  return [
    PositiveTransflectionExample(
      value: "",
      expression: "\"\""
    ),
    PositiveTransflectionExample(
      value: " ",
      expression: "\" \""
    ),
    PositiveTransflectionExample(
      value: "abc",
      expression: "\"abc\""
    ),
    PositiveTransflectionExample(
      value: "hello, world!",
      expression: "\"hello, world!\""
    ),
    PositiveTransflectionExample(
      value: "π",
      expression: "\"π\""
    )
  ]
}
