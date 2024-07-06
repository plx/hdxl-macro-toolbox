import Testing
import SwiftSyntax
import SwiftParser
import SwiftSyntaxBuilder
import SwiftDiagnostics
import MacroToolbox
import MacroTransflection
@testable import MacroTransflectionMacroSupport

// MARK: - Tests

@Test(
  "`UInt.init(transflectingExprSyntax:)` (negative examples)",
  arguments: negativeExamples(forType: UInt.self)
)
func testUIntInitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<UInt>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`UInt8.init(transflectingExprSyntax:)` (negative examples)",
  arguments: negativeExamples(forType: UInt8.self)
)
func testUInt8InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<UInt8>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`UInt16.init(transflectingExprSyntax:)` (negative examples)",
  arguments: negativeExamples(forType: UInt16.self)
)
func testUInt16InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<UInt16>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`UInt32.init(transflectingExprSyntax:)` (negative examples)",
  arguments: negativeExamples(forType: UInt32.self)
)
func testUInt32InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<UInt32>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`UInt64.init(transflectingExprSyntax:)` (negative examples)",
  arguments: negativeExamples(forType: UInt64.self)
)
func testUInt64InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<UInt64>
) throws {
  try example.validateTransflectionFailure()
}

// MARK: - Tests - Optional

@Test(
  "`UInt?.init(transflectingExprSyntax:)` (negative examples)",
  arguments: negativeExamples(
    forType: UInt.self
  ).map(\.optionalized)
)
func testOptionalUIntInitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<UInt?>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`UInt8?.init(transflectingExprSyntax:)` (negative examples)",
  arguments: negativeExamples(
    forType: UInt8.self
  ).map(\.optionalized)
)
func testOptionalUInt8InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<UInt8?>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`UInt16?.init(transflectingExprSyntax:)` (negative examples)",
  arguments: negativeExamples(
    forType: UInt16.self
  ).map(\.optionalized)
)
func testOptionalUInt16InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<UInt16?>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`UInt32?.init(transflectingExprSyntax:)` (negative examples)",
  arguments: negativeExamples(
    forType: UInt32.self
  ).map(\.optionalized)
)
func testOptionalUInt32InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<UInt32?>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`UInt64?.init(transflectingExprSyntax:)` (negative examples)",
  arguments: negativeExamples(
    forType: UInt64.self
  ).map(\.optionalized)
)
func testOptionalUInt64InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<UInt64?>
) throws {
  try example.validateTransflectionFailure()
}

// MARK: - Examples

fileprivate func negativeExamples<T>(
  forType type: T.Type
) -> some Sendable & Collection<NegativeTransflectionExample<T>>
where
T: Sendable,
T: Equatable,
T: BinaryInteger,
T: FixedWidthInteger,
T: TransflectableViaExprSyntax
{
  func expression(_ _expression: ExprSyntax) -> NegativeTransflectionExample<T> {
    NegativeTransflectionExample(
      valueType: type,
      expression: _expression,
      failureType: IntegerExprTransflectionError.self
    )
  }

  return [
    expression("0.0"),
    expression("max"),
    expression("min"),
    expression("zero"),
    expression("\".max\""),
    expression("\".min\""),
    expression("\".zero\""),
    expression("\"0\""),
    expression("\"1\"")
  ]
}
