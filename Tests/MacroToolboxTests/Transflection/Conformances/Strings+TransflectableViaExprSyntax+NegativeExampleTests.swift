import Testing
import SwiftSyntax
import SwiftParser
import MacroTransflection
import MacroToolboxTestSupport
@testable import MacroToolbox

// MARK: - Tests

@Test(
  "`String.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .stringTransflections
  ),
  arguments: negativeExamples(forType: String.self)
)
func testStringInitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<String>
) throws {
  try example.validateTransflectionFailure()
}

// MARK: - Tests - Optional

@Test(
  "`String?.init(transflectingExprSyntax:)` (negative examples)",
  .tags(
    .transflection,
    .negativeExamples,
    .stringTransflections,
    .optionalTransflections
  ),
  arguments: negativeExamples(
    forType: String.self
  ).map(\.optionalized)
)
func testOptionalStringInitTransflectingExprSyntax_negativeExamples(
  example: NegativeTransflectionExample<String?>
) throws {
  try example.validateTransflectionFailure()
}

// MARK: - Examples

fileprivate func negativeExamples<T>(
  forType type: T.Type
) -> some Sendable & Collection<NegativeTransflectionExample<T>>
where
T: Sendable,
T: StringProtocol,
T: TransflectableViaExprSyntax
{
  func expression(_ _expression: ExprSyntax) -> NegativeTransflectionExample<T> {
    NegativeTransflectionExample(
      valueType: type,
      expression: _expression,
      failureType: StringExprTransflectionError.self
    )
  }
  
  return [
    // non-string examples:
    expression("a"),
    expression("1"),
    expression("2.3"),
    expression("0xdeadbeef"),
    expression("(1 + 2) / 4"),

    // neither of these work, b/c the underlying syntax
    // gets rejected during the `expression.validate()` call:
    //
    // expression("\"hello, world"), // <- no right quote
    // expression("hello, world\""), // <- no left quote

    // examples with interpolation:
    expression("\"pump up \\(theJam)\""),
    expression("\"pump up \\(theJam, privacy: .private)\""),
    expression("\"pump up \\(raw: theJam)\"")
  ]
}
