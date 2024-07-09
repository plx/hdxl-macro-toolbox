import Testing
import SwiftSyntax
import SwiftParser
import MacroToolbox
import MacroTransflection
import MacroToolboxTestSupport
@testable import MacroTransflectionMacroSupport


// MARK: - Tests

@Test(
  "`UInt.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .unsignedIntegerTransflections,
    .uintTransflection
  ),
  arguments: positiveExamples(forType: UInt.self)
)
func testUIntInitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<UInt>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`UInt8.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .unsignedIntegerTransflections,
    .uint8Transflection
  ),
  arguments: positiveExamples(forType: UInt8.self)
)
func testUInt8InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<UInt8>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`UInt16.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .unsignedIntegerTransflections,
    .uint16Transflection
  ),
  arguments: positiveExamples(forType: UInt16.self)
)
func testUInt16InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<UInt16>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`UInt32.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .unsignedIntegerTransflections,
    .uint32Transflection
  ),
  arguments: positiveExamples(forType: UInt32.self)
)
func testUInt32InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<UInt32>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`UInt64.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .unsignedIntegerTransflections,
    .uint64Transflection
  ),
  arguments: positiveExamples(forType: UInt64.self)
)
func testUInt64InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<UInt64>
) throws {
  try validatePositiveExample(example: example)
}

// MARK: - Tests - Optional

@Test(
  "`UInt?.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .unsignedIntegerTransflections,
    .uintTransflection,
    .optionalTransflections
  ),
  arguments: positiveExamples(
    forType: UInt.self
  ).map(\.optionalized)
)
func testOptionalUIntInitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<UInt?>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`UInt8?.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .unsignedIntegerTransflections,
    .uint8Transflection,
    .optionalTransflections
  ),
  arguments: positiveExamples(
    forType: UInt8.self
  ).map(\.optionalized)
)
func testOptionalUInt8InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<UInt8?>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`UInt16?.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .unsignedIntegerTransflections,
    .uint16Transflection,
    .optionalTransflections
  ),
  arguments: positiveExamples(
    forType: UInt16.self
  ).map(\.optionalized)
)
func testOptionalUInt16InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<UInt16?>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`UInt32?.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .unsignedIntegerTransflections,
    .uint32Transflection,
    .optionalTransflections
  ),
  arguments: positiveExamples(
    forType: UInt32.self
  ).map(\.optionalized)
)
func testOptionalUInt32InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<UInt32?>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`UInt64.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .unsignedIntegerTransflections,
    .uint64Transflection,
    .optionalTransflections
  ),
  arguments: positiveExamples(
    forType: UInt64.self
  ).map(\.optionalized)
)
func testOptionalUInt64InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<UInt64?>
) throws {
  try validatePositiveExample(example: example)
}

// MARK: - Examples

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
