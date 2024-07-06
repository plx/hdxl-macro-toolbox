import Testing
import SwiftSyntax
import SwiftParser
import MacroToolbox
import MacroTransflection
@testable import MacroTransflectionMacroSupport

// MARK: - Tests

@Test(
  "`Bool.init(transflectingExprSyntax:)` (positive examples)",
  arguments: positiveBooleanExamples()
)
func testBoolInitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Bool>
) throws {
  try validatePositiveExample(example: example)
}

// MARK: - Tests - Optional

@Test(
  "`Bool?.init(transflectingExprSyntax:)` (positive examples)",
  arguments: positiveBooleanExamples().map(\.optionalized)
)
func testOptionalBoolInitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Bool?>
) throws {
  try validatePositiveExample(example: example)
}

// MARK: - Examples

fileprivate func positiveBooleanExamples() -> some Sendable & Collection<PositiveTransflectionExample<Bool>> {
  return [
    PositiveTransflectionExample(
      value: true,
      expression: "true"
    ),
    PositiveTransflectionExample(
      value: false,
      expression: "false"
    )
  ]
}

