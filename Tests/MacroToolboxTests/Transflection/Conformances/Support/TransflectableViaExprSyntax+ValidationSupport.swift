import Testing
import SwiftSyntax
import SwiftParser
import MacroTransflection
import MacroToolboxTestSupport
@testable import MacroToolbox

func validatePositiveExample<T>(
  example: PositiveTransflectionExample<T>,
  function: StaticString = #function,
  sourceLocation: Testing.SourceLocation = Testing.SourceLocation.automatic()
) throws where T: Sendable, T: Equatable, T: TransflectableViaExprSyntax {
  let expectedValue = example.value
  let expression = try example.expression.validated()
  let transflectedValue = try T(transflectingExprSyntax: expression)
  #expect(
    expectedValue == transflectedValue,
    """
    Transflection-failure for \(example)!
    
    - `expression`: \(expression)
    - `expectedValue`: \(expectedValue)
    - `transflectedValue`: \(transflectedValue)
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `fileID`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
}

func validatePositiveFloatingPointExample<T>(
  example: PositiveTransflectionExample<T>,
  function: StaticString = #function,
  sourceLocation: Testing.SourceLocation = Testing.SourceLocation.automatic()
) throws where T: Sendable, T: Equatable, T: TransflectableViaExprSyntax, T: BinaryFloatingPoint {
  let expectedValue = example.value
  let expression = try example.expression.validated()
  let transflectedValue = try T(transflectingExprSyntax: expression)
  #expect(
    expectedValue == transflectedValue
    ||
    (expectedValue.isSignalingNaN && transflectedValue.isSignalingNaN)
    ||
    (expectedValue.isNaN && transflectedValue.isNaN)
    ||
    (expectedValue.isInfinite && transflectedValue.isInfinite && (expectedValue.sign == transflectedValue.sign)),
    """
    Transflection-failure for \(example)!
    
    - `expression`: \(expression)
    - `expectedValue`: \(expectedValue)
    - `transflectedValue`: \(transflectedValue)
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `fileID`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
}

func validatePositiveFloatingPointExample<T>(
  example: PositiveTransflectionExample<T?>,
  function: StaticString = #function,
  sourceLocation: Testing.SourceLocation = Testing.SourceLocation.automatic()
) throws where T: Sendable, T: Equatable, T: TransflectableViaExprSyntax, T: BinaryFloatingPoint {
  let _expectedValue = example.value
  let expression = try example.expression.validated()
  let _transflectedValue = try T?(transflectingExprSyntax: expression)
  switch (_expectedValue, _transflectedValue) {
  case (.none, .none):
    return
  case (.some(let expectedValue), .some(let transflectedValue)):
    #expect(
      expectedValue == transflectedValue
      ||
      (expectedValue.isSignalingNaN && transflectedValue.isSignalingNaN)
      ||
      (expectedValue.isNaN && transflectedValue.isNaN)
      ||
      (expectedValue.isInfinite && transflectedValue.isInfinite && (expectedValue.sign == transflectedValue.sign)),
      """
      Transflection-failure for \(example)!
      
      - `expression`: \(expression)
      - `expectedValue`: \(expectedValue)
      - `transflectedValue`: \(transflectedValue)
      - `function`: \(function)
      - `fileID`: \(sourceLocation.fileID)
      - `line`: \(sourceLocation.line)
      - `fileID`: \(sourceLocation.column)
      """,
      sourceLocation: sourceLocation
    )
  default:
    #expect(
      (_expectedValue == .none) == (_transflectedValue == .none),
      """
      Transflection-failure for \(example)!
      
      - `expression`: \(expression)
      - `expectedValue`: \(String(reflecting: _expectedValue))
      - `transflectedValue`: \(String(reflecting: _transflectedValue))
      - `function`: \(function)
      - `fileID`: \(sourceLocation.fileID)
      - `line`: \(sourceLocation.line)
      - `fileID`: \(sourceLocation.column)
      """,
      sourceLocation: sourceLocation
    )
  }
}
