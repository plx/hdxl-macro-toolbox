import Testing
import SwiftSyntax
import SwiftParser
import MacroToolbox
import MacroTransflection
import MacroToolboxTestSupport
@testable import MacroTransflectionMacroSupport

// MARK: - Tests

@Test(
  "`Float16.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .floatingPointTransflections,
    .float16Transflection
  ),
  arguments: negativeExamples(forType: Float16.self)
)
func testFloat16InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Float16>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`Float.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .floatingPointTransflections,
    .floatTransflection
  ),
  arguments: negativeExamples(forType: Float.self)
)
func testFloatInitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Float>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`Double.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .floatingPointTransflections,
    .doubleTransflection
  ),
  arguments: negativeExamples(forType: Double.self)
)
func testDoubleInitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Double>
) throws {
  try example.validateTransflectionFailure()
}

// MARK: - Tests - Optionalized

@Test(
  "`Float16?.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .floatingPointTransflections,
    .float16Transflection,
    .optionalTransflections
  ),
  arguments: negativeExamples(
    forType: Float16.self
  ).map(\.optionalized)
)
func testOptionalFloat16InitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Float16?>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`Float?.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .floatingPointTransflections,
    .floatTransflection,
    .optionalTransflections
  ),
  arguments: negativeExamples(
    forType: Float.self
  ).map(\.optionalized)
)
func testOptionalFloatInitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Float?>
) throws {
  try example.validateTransflectionFailure()
}

@Test(
  "`Double?.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .floatingPointTransflections,
    .doubleTransflection,
    .optionalTransflections
  ),
  arguments: negativeExamples(
    forType: Double.self
  ).map(\.optionalized)
)
func testOptionalDoubleInitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<Double?>
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
T: BinaryFloatingPoint,
T: TransflectableViaExprSyntax
{
  func expression(_ _expression: ExprSyntax) -> NegativeTransflectionExample<T> {
    NegativeTransflectionExample(
      valueType: type,
      expression: _expression,
      failureType: FloatExprTransflectionError.self
    )
  }
  
  return [
    expression("a"),
    expression("π"),
    expression("pi"),
    expression("0xdeadbeef"),
    expression("nan"),
    expression("NaN"),
    expression("NAN"),
    expression("signalingNaN"),
    expression("infinity"),
    expression("-infinity"),
    expression("\".infinity\""),
    expression("\".pi\""),
    expression("\".nan\""),
    expression("\"nan\""),
    expression("\"1\""),
    expression("\"0\""),
    expression("\"0.0\""),
    expression("\"1.0\"")
  ]
}
