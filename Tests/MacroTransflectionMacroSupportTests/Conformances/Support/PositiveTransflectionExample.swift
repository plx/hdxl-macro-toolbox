import Testing
import SwiftSyntax
import SwiftParser
import MacroTransflection
import MacroToolboxTestSupport
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

extension PositiveTransflectionExample {
  
  var optionalized: PositiveTransflectionExample<Optional<T>> {
    PositiveTransflectionExample<Optional<T>>(
      value: .some(value),
      expression: expression
    )
  }
}
