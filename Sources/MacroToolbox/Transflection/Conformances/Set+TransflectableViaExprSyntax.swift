import Foundation
import SwiftSyntax
import MacroTransflection

public enum SetExprTransflectionError: Error, LocalizedError {
  case unsupportedExprSyntax(String)
}

extension Set: TransflectableViaExprSyntax where Element: TransflectableViaExprSyntax {
  
  @inlinable
  public init(transflectingExprSyntax exprSyntax: ExprSyntax) throws {
    guard let arrayLiteral = exprSyntax.as(ArrayExprSyntax.self) else {
      throw SetExprTransflectionError.unsupportedExprSyntax(
        """
        Unable to transflect expression syntax: \(String(reflecting: exprSyntax))
        """
      )
    }
    
    self.init(try arrayLiteral.elements.lazy.map { element in
      try Element(transflectingExprSyntax: element.expression)
    })
  }
  
}
