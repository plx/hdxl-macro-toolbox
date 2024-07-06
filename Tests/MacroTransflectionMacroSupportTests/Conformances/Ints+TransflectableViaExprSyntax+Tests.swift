import Testing
import SwiftSyntax
import SwiftParser
import MacroToolbox
import MacroTransflection
@testable import MacroTransflectionMacroSupport

// MARK: Positive Tests - Signed

@Test(
  "`Int.init(transflectingExprSyntax:)` (positive examples)",
  arguments: positiveExamples(forType: Int.self)
)
func testIntInitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Int>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`Int8.init(transflectingExprSyntax:)` (positive examples)",
  arguments: positiveExamples(forType: Int8.self)
)
func testInt8InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Int8>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`Int16.init(transflectingExprSyntax:)` (positive examples)",
  arguments: positiveExamples(forType: Int16.self)
)
func testInt16InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Int16>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`Int32.init(transflectingExprSyntax:)` (positive examples)",
  arguments: positiveExamples(forType: Int32.self)
)
func testInt32InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Int32>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`Int64.init(transflectingExprSyntax:)` (positive examples)",
  arguments: positiveExamples(forType: Int64.self)
)
func testInt64InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Int64>
) throws {
  try validatePositiveExample(example: example)
}

// MARK: Positive Tests - Unsigned

@Test(
  "`UInt.init(transflectingExprSyntax:)` (positive examples)",
  arguments: positiveExamples(forType: UInt.self)
)
func testUIntInitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<UInt>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`UInt8.init(transflectingExprSyntax:)` (positive examples)",
  arguments: positiveExamples(forType: UInt8.self)
)
func testUInt8InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<UInt8>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`UInt16.init(transflectingExprSyntax:)` (positive examples)",
  arguments: positiveExamples(forType: UInt16.self)
)
func testUInt16InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<UInt16>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`UInt32.init(transflectingExprSyntax:)` (positive examples)",
  arguments: positiveExamples(forType: UInt32.self)
)
func testUInt32InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<UInt32>
) throws {
  try validatePositiveExample(example: example)
}

@Test(
  "`UInt64.init(transflectingExprSyntax:)` (positive examples)",
  arguments: positiveExamples(forType: UInt64.self)
)
func testUInt64InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<UInt64>
) throws {
  try validatePositiveExample(example: example)
}

// MARK: Setup Tests

@Test("Test `\"\\(type)\" produces clean type names")
func testTypeValueStringInterpolationProducesCleanTypeNames() {
  verifyStringification(
    type: Int.self,
    expectation: "Int"
  )
  verifyStringification(
    type: Int8.self,
    expectation: "Int8"
  )
  verifyStringification(
    type: Int16.self,
    expectation: "Int16"
  )
  verifyStringification(
    type: Int32.self,
    expectation: "Int32"
  )
  verifyStringification(
    type: Int64.self,
    expectation: "Int64"
  )
  
  verifyStringification(
    type: UInt.self,
    expectation: "UInt"
  )
  verifyStringification(
    type: UInt8.self,
    expectation: "UInt8"
  )
  verifyStringification(
    type: UInt16.self,
    expectation: "UInt16"
  )
  verifyStringification(
    type: UInt32.self,
    expectation: "UInt32"
  )
  verifyStringification(
    type: UInt64.self,
    expectation: "UInt64"
  )
}

fileprivate func verifyStringification<T>(
  type: T.Type,
  expectation: String,
  function: StaticString = #function,
  sourceLocation: Testing.SourceLocation = Testing.SourceLocation()
) {
  #expect(
    expectation == "\(type)",
    """
    Expected `"\\(type)"` to be `"\(expectation)"`, but got `"\(type)"` instead!
    
    - `type`: \(type)
    - `expectation`: \(expectation)
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
}

// MARK: Universal Examples

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
