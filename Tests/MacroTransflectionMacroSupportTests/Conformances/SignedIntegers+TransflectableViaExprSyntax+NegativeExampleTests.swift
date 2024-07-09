import Testing
import SwiftSyntax
import SwiftParser
import SwiftSyntaxBuilder
import SwiftDiagnostics
import MacroToolbox
import MacroTransflection
import MacroToolboxTestSupport
@testable import MacroTransflectionMacroSupport


// MARK: - Tests

@Test(
  "`Int.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .signedIntegerTransflections,
    .intTransflection
  ),
  arguments: negativeExamples(forType: Int.self)
)
func testIntInitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Int>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`Int8.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .signedIntegerTransflections,
    .int8Transflection
  ),
  arguments: negativeExamples(forType: Int8.self)
)
func testInt8InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Int8>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`Int16.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .signedIntegerTransflections,
    .int16Transflection
  ),
  arguments: negativeExamples(forType: Int16.self)
)
func testInt16InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Int16>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`Int32.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .signedIntegerTransflections,
    .int32Transflection
  ),
  arguments: negativeExamples(forType: Int32.self)
)
func testInt32InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Int32>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`Int64.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .signedIntegerTransflections,
    .int64Transflection
  ),
  arguments: negativeExamples(forType: Int64.self)
)
func testInt64InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Int64>
) throws {
  try example.validateTransflectionFailure()
}

// MARK: - Tests - Optional

@Test(
  "`Int?.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .signedIntegerTransflections,
    .intTransflection,
    .optionalTransflections
  ),
  arguments: negativeExamples(
    forType: Int.self
  ).map(\.optionalized)
)
func testOptionalIntInitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Int?>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`Int8?.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .signedIntegerTransflections,
    .int8Transflection,
    .optionalTransflections
  ),
  arguments: negativeExamples(
    forType: Int8.self
  ).map(\.optionalized)
)
func testOptionalInt8InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Int8?>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`Int16?.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .signedIntegerTransflections,
    .int16Transflection,
    .optionalTransflections
  ),
  arguments: negativeExamples(
    forType: Int16.self
  ).map(\.optionalized)
)
func testOptionalInt16InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Int16?>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`Int32?.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .signedIntegerTransflections,
    .int32Transflection,
    .optionalTransflections
  ),
  arguments: negativeExamples(
    forType: Int32.self
  ).map(\.optionalized)
)
func testOptionalInt32InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Int32?>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`Int64?.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .signedIntegerTransflections,
    .int64Transflection,
    .optionalTransflections
  ),
  arguments: negativeExamples(
    forType: Int64.self
  ).map(\.optionalized)
)
func testOptionalInt64InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Int64?>
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
