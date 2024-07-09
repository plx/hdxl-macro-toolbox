import Testing
import SwiftSyntax
import SwiftParser
import MacroToolbox
import MacroTransflection
import MacroToolboxTestSupport
@testable import MacroTransflectionMacroSupport


// MARK: - Tests

@Test(
  "`Int.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .signedIntegerTransflections,
    .intTransflection
  ),
  arguments: positiveExamples(forType: Int.self)
)
func testIntInitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Int>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`Int8.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .signedIntegerTransflections,
    .int8Transflection
  ),
  arguments: positiveExamples(forType: Int8.self)
)
func testInt8InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Int8>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`Int16.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .signedIntegerTransflections,
    .int16Transflection
  ),
  arguments: positiveExamples(forType: Int16.self)
)
func testInt16InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Int16>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`Int32.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .signedIntegerTransflections,
    .int32Transflection
  ),
  arguments: positiveExamples(forType: Int32.self)
)
func testInt32InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Int32>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`Int64.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .signedIntegerTransflections,
    .int64Transflection
  ),
  arguments: positiveExamples(forType: Int64.self)
)
func testInt64InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Int64>
) throws {
  try validatePositiveExample(example: example)
}

// MARK: - Tests - Optional

@Test(
  "`Int?.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .signedIntegerTransflections,
    .intTransflection,
    .optionalTransflections
  ),
  arguments: positiveExamples(
    forType: Int.self
  ).map(\.optionalized)
)
func testOptionalIntInitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Int?>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`Int8?.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .signedIntegerTransflections,
    .int8Transflection,
    .optionalTransflections
  ),
  arguments: positiveExamples(
    forType: Int8.self
  ).map(\.optionalized)
)
func testOptionalInt8InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Int8?>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`Int16?.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .signedIntegerTransflections,
    .int16Transflection,
    .optionalTransflections
  ),
  arguments: positiveExamples(
    forType: Int16.self
  ).map(\.optionalized)
)
func testOptionalInt16InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Int16?>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`Int32?.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .signedIntegerTransflections,
    .int32Transflection,
    .optionalTransflections
  ),
  arguments: positiveExamples(
    forType: Int32.self
  ).map(\.optionalized)
)
func testOptionalInt32InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Int32?>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`Int64?.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .signedIntegerTransflections,
    .int64Transflection,
    .optionalTransflections
  ),
  arguments: positiveExamples(
    forType: Int64.self
  ).map(\.optionalized)
)
func testOptionalInt64InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Int64?>
) throws {
  try validatePositiveExample(example: example)
}

// MARK: Test Examples

fileprivate func positiveExamples<T>(
  forType type: T.Type
) -> some Sendable & Collection<PositiveTransflectionExample<T>>
where
T: Sendable,
T: Equatable,
T: BinaryInteger,
T: FixedWidthInteger,
T: TransflectableViaExprSyntax
{
  var result: [PositiveTransflectionExample<T>] = []
  result.append(
    contentsOf: [
      PositiveTransflectionExample(
        value: type.init(),
        expression: "0"
      ),
      PositiveTransflectionExample(
        value: type.init(),
        expression: ".zero"
      ),
      PositiveTransflectionExample(
        value: type.init(),
        expression: "\(raw: type).zero"
      )
    ]
  )
  
  result.append(
    contentsOf: [
      PositiveTransflectionExample(
        value: type.max,
        expression: ".max"
      ),
      PositiveTransflectionExample(
        value: type.max,
        expression: "\(raw: type).max"
      )
    ]
  )
  
  result.append(
    contentsOf: [
      PositiveTransflectionExample(
        value: type.min,
        expression: ".min"
      ),
      PositiveTransflectionExample(
        value: type.min,
        expression: "\(raw: type).min"
      )
    ]
  )

  result.append(
    contentsOf: (1...5).map {
      PositiveTransflectionExample(
        value: type.max - $0,
        expression: "\(raw: type.max - $0)"
      )
    }
  )
  result.append(
    contentsOf: (1...5).map {
      PositiveTransflectionExample(
        value: type.min + $0,
        expression: "\(raw: type.min + $0)"
      )
    }
  )

  result.append(
    contentsOf: (1...5).map {
      PositiveTransflectionExample(
        value: $0,
        expression: "\(raw: $0)"
      )
    }
  )
  
  if type.isSigned {
    result.append(
      contentsOf: (1...5).map {
        PositiveTransflectionExample(
          value: -1 * $0,
          expression: "\(raw: -1 * $0)"
        )
      }
    )
  }
  
  return result
}
