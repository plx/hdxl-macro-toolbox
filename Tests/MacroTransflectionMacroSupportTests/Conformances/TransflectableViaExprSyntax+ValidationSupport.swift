import Testing
import SwiftSyntax
import SwiftParser
import MacroTransflection
@testable import MacroTransflectionMacroSupport

// TODO: fix this once swift-syntax is concurrency-compliant
struct PositiveTransflectionExample<T>: @unchecked Sendable
where
T: Sendable,
T: Equatable,
T: TransflectableViaExprSyntax
{
  let value: T
  let expression: ExprSyntax
    
  init(value: T, expression: ExprSyntax) {
    self.value = value
    self.expression = expression
  }
}

extension PositiveTransflectionExample: CustomTestStringConvertible {
  var testDescription: String {
    "\(expression.trimmed) transflects-to \(value)"
  }
}

extension PositiveTransflectionExample: Codable, CustomTestArgumentEncodable where T: Codable {
  
  enum SerializationKeys: String, CodingKey {
    case value
    case expression
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: SerializationKeys.self)
    try container.encode(
      value,
      forKey: .value
    )
    try container.encode(
      "\(expression.trimmed)",
      forKey: .expression
    )
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: SerializationKeys.self)
    self.init(
      value: try container.decode(
        T.self,
        forKey: .value
      ),
      expression: try ExprSyntax(
        stringLiteral: try container.decode(
          String.self,
          forKey: .expression
        )
      ).validated()
    )
  }
  
  func encodeTestArgument(to encoder: some Encoder) throws {
    try encode(to: encoder)
  }
  
}

func validatePositiveExample<T>(
  example: PositiveTransflectionExample<T>,
  function: StaticString = #function,
  sourceLocation: Testing.SourceLocation = Testing.SourceLocation()
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
    """
  )
}

func validatePositiveFloatingPointExample<T>(
  example: PositiveTransflectionExample<T>,
  function: StaticString = #function,
  sourceLocation: Testing.SourceLocation = Testing.SourceLocation()
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
    (expectedValue.isInfinite && transflectedValue.isInfinite && (expectedValue > 0) == (transflectedValue > 0)),
    """
    Transflection-failure for \(example)!
    
    - `expression`: \(expression)
    - `expectedValue`: \(expectedValue)
    - `transflectedValue`: \(transflectedValue)
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `fileID`: \(sourceLocation.column)
    """
  )
}
