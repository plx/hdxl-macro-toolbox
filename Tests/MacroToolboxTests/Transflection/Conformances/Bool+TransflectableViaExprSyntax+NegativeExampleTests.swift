import Testing
import SwiftSyntax
import SwiftParser
import MacroTransflection
import MacroToolboxTestSupport
@testable import MacroToolbox


// MARK: - Tests

@Test(
  "`Bool.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .booleanTransflections
  ),
  arguments: negativeBooleanExamples()
)
func testBoolInitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Bool>
) throws {
  try example.validateTransflectionFailure()
}

// MARK: - Tests - Optional

@Test(
  "`Bool?.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .booleanTransflections,
    .optionalTransflections
  ),
  arguments: negativeBooleanExamples().map(\.optionalized)
)
func testOptionalBoolInitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Bool?>
) throws {
  try example.validateTransflectionFailure()
}

// MARK: - Examples

fileprivate func negativeBooleanExamples() -> some Sendable & Collection<NegativeTransflectionExample<Bool>> {
  return [
    NegativeTransflectionExample(
      valueType: Bool.self,
      expression: ".true",
      failureType: BoolExprTransflectionError.self
    ),
    NegativeTransflectionExample(
      valueType: Bool.self,
      expression: ".false",
      failureType: BoolExprTransflectionError.self
    ),
    NegativeTransflectionExample(
      valueType: Bool.self,
      expression: "0",
      failureType: BoolExprTransflectionError.self
    ),
    NegativeTransflectionExample(
      valueType: Bool.self,
      expression: "false()",
      failureType: BoolExprTransflectionError.self
    ),
  ]
}

