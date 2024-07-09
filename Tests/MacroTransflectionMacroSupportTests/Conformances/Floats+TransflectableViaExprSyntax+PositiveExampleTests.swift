import Testing
import SwiftSyntax
import SwiftParser
import MacroToolbox
import MacroTransflection
import MacroToolboxTestSupport
@testable import MacroTransflectionMacroSupport

// MARK: - Tests

@Test(
  "`Float16.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .floatingPointTransflections
  ),
  arguments: positiveExamples(forType: Float16.self)
)
func testFloat16InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Float16>
) throws {
  try validatePositiveFloatingPointExample(example: example)
}

@Test(
  "`Float.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .floatingPointTransflections
  ),
  arguments: positiveExamples(forType: Float.self)
)
func testFloatInitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Float>
) throws {
  try validatePositiveFloatingPointExample(example: example)
}

@Test(
  "`Double.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .floatingPointTransflections
  ),
  arguments: positiveExamples(forType: Double.self)
)
func testDoubleInitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Double>
) throws {
  try validatePositiveFloatingPointExample(example: example)
}

// MARK: - Tests - Optional

@Test(
  "`Float16?.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .floatingPointTransflections,
    .float16Transflection,
    .optionalTransflections
  ),
  arguments: positiveExamples(
    forType: Float16.self
  ).map(\.optionalized)
)
func testOptionalFloat16InitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Float16?>
) throws {
  try validatePositiveFloatingPointExample(example: example)
}

@Test(
  "`Float?.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .floatingPointTransflections,
    .floatTransflection,
    .optionalTransflections
  ),
  arguments: positiveExamples(
    forType: Float.self
  ).map(\.optionalized)
)
func testOptionalFloatInitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Float?>
) throws {
  try validatePositiveFloatingPointExample(example: example)
}

@Test(
  "`Double?.init(transflectingExprSyntax:)` (positive examples)",
  .tags(
    .transflection,
    .positiveExamples,
    .floatingPointTransflections,
    .doubleTransflection,
    .optionalTransflections
  ),
  arguments: positiveExamples(
    forType: Double.self
  ).map(\.optionalized)
)
func testOptionalDoubleInitTransflectingExprSyntax_positiveExamples(
  example: PositiveTransflectionExample<Double?>
) throws {
  try validatePositiveFloatingPointExample(example: example)
}

// MARK: - Examples

fileprivate func positiveExamples<T>(
  forType type: T.Type
) -> some Sendable & Collection<PositiveTransflectionExample<T>>
where
T: Sendable,
T: Equatable,
T: BinaryFloatingPoint,
T: TransflectableViaExprSyntax
{
  var result: [PositiveTransflectionExample<T>] = []
  result.append(
    contentsOf: [
      PositiveTransflectionExample(
        value: type.zero,
        expression: "0"
      ),
      PositiveTransflectionExample(
        value: type.zero,
        expression: "0.0"
      ),
      PositiveTransflectionExample(
        value: type.zero,
        expression: ".zero"
      ),
      PositiveTransflectionExample(
        value: type.zero,
        expression: "\(raw: type).zero"
      )
    ]
  )
  
  result.append(
    contentsOf: [
      PositiveTransflectionExample(
        value: type.leastNonzeroMagnitude,
        expression: ".leastNonzeroMagnitude"
      ),
      PositiveTransflectionExample(
        value: type.leastNonzeroMagnitude,
        expression: "\(raw: type).leastNonzeroMagnitude"
      ),
      PositiveTransflectionExample(
        value: -type.leastNonzeroMagnitude,
        expression: "-.leastNonzeroMagnitude"
      ),
      PositiveTransflectionExample(
        value: -type.leastNonzeroMagnitude,
        expression: "-\(raw: type).leastNonzeroMagnitude"
      )
    ]
  )

  result.append(
    contentsOf: [
      PositiveTransflectionExample(
        value: type.leastNormalMagnitude,
        expression: ".leastNormalMagnitude"
      ),
      PositiveTransflectionExample(
        value: type.leastNormalMagnitude,
        expression: "\(raw: type).leastNormalMagnitude"
      ),
      PositiveTransflectionExample(
        value: -type.leastNormalMagnitude,
        expression: "-.leastNormalMagnitude"
      ),
      PositiveTransflectionExample(
        value: -type.leastNormalMagnitude,
        expression: "-\(raw: type).leastNormalMagnitude"
      )
    ]
  )

  result.append(
    contentsOf: [
      PositiveTransflectionExample(
        value: type.infinity,
        expression: ".infinity"
      ),
      PositiveTransflectionExample(
        value: type.infinity,
        expression: "\(raw: type).infinity"
      ),
      PositiveTransflectionExample(
        value: -type.infinity,
        expression: "-.infinity"
      ),
      PositiveTransflectionExample(
        value: -type.infinity,
        expression: "-\(raw: type).infinity"
      )
    ]
  )

  result.append(
    contentsOf: [
      PositiveTransflectionExample(
        value: type.nan,
        expression: ".nan"
      ),
      PositiveTransflectionExample(
        value: type.nan,
        expression: "\(raw: type).nan"
      )
    ]
  )

  result.append(
    contentsOf: [
      PositiveTransflectionExample(
        value: type.signalingNaN,
        expression: ".signalingNaN"
      ),
      PositiveTransflectionExample(
        value: type.signalingNaN,
        expression: "\(raw: type).signalingNaN"
      )
    ]
  )

  result.append(
    contentsOf: [
      PositiveTransflectionExample(
        value: type.ulpOfOne,
        expression: ".ulpOfOne"
      ),
      PositiveTransflectionExample(
        value: type.ulpOfOne,
        expression: "\(raw: type).ulpOfOne"
      ),
      PositiveTransflectionExample(
        value: -type.ulpOfOne,
        expression: "-.ulpOfOne"
      ),
      PositiveTransflectionExample(
        value: -type.ulpOfOne,
        expression: "-\(raw: type).ulpOfOne"
      )
    ]
  )

  result.append(
    contentsOf: [
      PositiveTransflectionExample(
        value: type.pi,
        expression: ".pi"
      ),
      PositiveTransflectionExample(
        value: type.pi,
        expression: "\(raw: type).pi"
      ),
      PositiveTransflectionExample(
        value: -type.pi,
        expression: "-.pi"
      ),
      PositiveTransflectionExample(
        value: -type.pi,
        expression: "-\(raw: type).pi"
      )
    ]
  )

  result.append(
    contentsOf: [
      PositiveTransflectionExample(
        value: type.greatestFiniteMagnitude,
        expression: ".greatestFiniteMagnitude"
      ),
      PositiveTransflectionExample(
        value: type.greatestFiniteMagnitude,
        expression: "\(raw: type).greatestFiniteMagnitude"
      ),
      PositiveTransflectionExample(
        value: -type.greatestFiniteMagnitude,
        expression: "-.greatestFiniteMagnitude"
      ),
      PositiveTransflectionExample(
        value: -type.greatestFiniteMagnitude,
        expression: "-\(raw: type).greatestFiniteMagnitude"
      )
    ]
  )

  for i in (1...5) {
    result.append(
      PositiveTransflectionExample(
        value: type.init(i),
        expression: "\(raw: i)"
      )
    )
    result.append(
      PositiveTransflectionExample(
        value: -type.init(i),
        expression: "-\(raw: i)"
      )
    )
    for j in (0...9) {
      let value = type.init(i) + (type.init(j) / 10.0)
      result.append(
        PositiveTransflectionExample(
          value: value,
          expression: "\(raw: i).\(raw: j)"
        )
      )
      result.append(
        PositiveTransflectionExample(
          value: -value,
          expression: "-\(raw: i).\(raw: j)"
        )
      )
    }
  }

  return result
}
