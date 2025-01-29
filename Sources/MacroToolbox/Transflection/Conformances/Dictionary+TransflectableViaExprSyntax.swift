import Foundation
import SwiftSyntax
import MacroTransflection

public enum DictionaryExprTransflectionError: Error, LocalizedError {
  case unsupportedExprSyntax(String)
  case duplicateKey(String)
}

extension Dictionary: TransflectableViaExprSyntax where Key: TransflectableViaExprSyntax, Value: TransflectableViaExprSyntax {
  
  @inlinable
  public init(transflectingExprSyntax exprSyntax: ExprSyntax) throws {
    guard let dictionaryLiteral = exprSyntax.as(DictionaryExprSyntax.self) else {
      throw DictionaryExprTransflectionError.unsupportedExprSyntax(
        """
        Unable to transflect expression syntax: \(String(reflecting: exprSyntax))
        """
      )
    }
    
    switch dictionaryLiteral.content {
    case .colon:
      self.init()
    case .elements(let elements):
      self.init(minimumCapacity: elements.count)
      for element in elements {
        let value = try Value(transflectingExprSyntax: element.value)
        let key = try Key(transflectingExprSyntax: element.key)
        switch self[key] {
        case .none:
          self[key] = value
        case .some(let previousValue):
          throw DictionaryExprTransflectionError.duplicateKey(
            """
            Encountered duplicate-key `\(String(reflecting: key))` w/values: \(String(reflecting: value)), \(String(reflecting: previousValue))!
            """
          )
        }
      }
    }
  }
  
}
