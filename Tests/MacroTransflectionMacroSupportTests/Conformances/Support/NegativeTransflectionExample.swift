import Testing
import SwiftSyntax
import SwiftParser
import MacroTransflection
@testable import MacroTransflectionMacroSupport

// TODO: fix this once swift-syntax is concurrency-compliant
struct NegativeTransflectionExample<T>: @unchecked Sendable
where
T: Sendable,
T: Equatable,
T: TransflectableViaExprSyntax
{
  
  private typealias Storage = NegativeTransflectionExampleStorage<T>
  private let storage: Storage
  
  private init(storage: Storage) {
    self.storage = storage
  }
  
  init<F>(
    valueType: T.Type,
    expression: ExprSyntax,
    failureType: F.Type
  ) where F: Error {
    self.init(
      storage: _NegativeTransflectionExampleStorage(
        valueType: valueType,
        expression: expression,
        failureType: failureType
      )
    )
  }
}

extension NegativeTransflectionExample {
  
  var valueType: T.Type { storage.valueType }
  var expression: ExprSyntax { storage.expression }
  var typeErasedFailureType: Error.Type { storage.typeErasedFailureType }
  
}

extension NegativeTransflectionExample: CustomTestStringConvertible {
  var testDescription: String {
    "\(valueType) should throw \(typeErasedFailureType) when transflecting \(expression.trimmed)"
  }
}

extension NegativeTransflectionExample: CustomTestArgumentEncodable {
  
  func encodeTestArgument(to encoder: some Encoder) throws {
    try storage.encodeTestArgument(to: encoder)
  }
  
}

extension NegativeTransflectionExample {
  
  func validateTransflectionFailure(
    function: StaticString = #function,
    sourceLocation: Testing.SourceLocation = Testing.SourceLocation()
  ) throws {
    try storage.validateTransflectionFailure(
      function: function,
      sourceLocation: sourceLocation
    )
  }
  
}

fileprivate class NegativeTransflectionExampleStorage<T>: @unchecked Sendable, CustomTestArgumentEncodable {
  var valueType: T.Type
  var expression: ExprSyntax
  
  init(valueType: T.Type, expression: ExprSyntax) {
    self.valueType = valueType
    self.expression = expression
  }
  
  enum AbstractMethodOverrideError: Error {
    case failedToOverrideAbstractMethod(String)
  }
  
  func validateTransflectionFailure(
    function: StaticString = #function,
    sourceLocation: Testing.SourceLocation = Testing.SourceLocation()
  ) throws {
    // deliberately minimal -- goal is just "better than `fatalError`"
    throw AbstractMethodOverrideError.failedToOverrideAbstractMethod(
      """
      Somehow forgot to override `validateTransflectionFailure(function:sourceLocation:)`!
      """
    )
  }
  
  var typeErasedFailureType: Error.Type {
    fatalError() // sigh
  }

  func encodeTestArgument(to encoder: some Encoder) throws {
    // deliberately minimal -- goal is just "better than `fatalError`"
    throw AbstractMethodOverrideError.failedToOverrideAbstractMethod(
      """
      Somehow forgot to override `encodeTestArgument(to:)`!
      """
    )
  }
}

fileprivate final class _NegativeTransflectionExampleStorage<T,F>: NegativeTransflectionExampleStorage<T>, @unchecked Sendable
where
T: Sendable,
T: Equatable,
T: TransflectableViaExprSyntax,
F: Error
{
  var failureType: F.Type
  
  init(
    valueType: T.Type,
    expression: ExprSyntax,
    failureType: F.Type
  ) {
    self.failureType = failureType
    super.init(
      valueType: valueType,
      expression: expression
    )
  }
  
  override func validateTransflectionFailure(
    function: StaticString = #function,
    sourceLocation: Testing.SourceLocation = Testing.SourceLocation()
  ) throws {
    let expression = try expression.validated()
    #expect(
      throws: failureType,
      """
      Failed to validate negative-example \(self)!
      
      - `valueType`: \(valueType)
      - `expression`: \(expression)
      - `failureType`: \(failureType)
      - `function`: \(function)
      - `fileID`: \(sourceLocation.fileID)
      - `line`: \(sourceLocation.line)
      - `fileID`: \(sourceLocation.column)
      """,
      sourceLocation: sourceLocation
    ) {
      try valueType.init(transflectingExprSyntax: expression)
    }
  }

  override var typeErasedFailureType: Error.Type {
    failureType
  }
  
  enum SerializationKeys: String, CodingKey {
    case valueType
    case expression
    case failureType
  }
  
  override func encodeTestArgument(to encoder: some Encoder) throws {
    var container = encoder.container(keyedBy: SerializationKeys.self)
    try container.encode(
      String(describing: valueType),
      forKey: .valueType
    )
    try container.encode(
      "\(expression.trimmed)",
      forKey: .expression
    )
    try container.encode(
      String(describing: failureType),
      forKey: .failureType
    )
  }

}

extension NegativeTransflectionExample {
  
  var optionalized: NegativeTransflectionExample<Optional<T>> {
    NegativeTransflectionExample<Optional<T>>(
      valueType: Optional<T>.self,
      expression: expression,
      failureType: OptionalExprTransflectionError.self
    )
  }
  
}
