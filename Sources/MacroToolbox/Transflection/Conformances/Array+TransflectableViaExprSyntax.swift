import Foundation
import SwiftSyntax
import MacroTransflection

public enum ArrayExprTransflectionError: Error, LocalizedError {
  case unsupportedExprSyntax(String)
}

extension Array: TransflectableViaExprSyntax where Element: TransflectableViaExprSyntax {

  @inlinable
  public init(transflectingExprSyntax exprSyntax: ExprSyntax) throws {
    guard let arrayLiteral = exprSyntax.as(ArrayExprSyntax.self) else {
      throw ArrayExprTransflectionError.unsupportedExprSyntax(
        """
        Unable to transflect expression syntax: \(String(reflecting: exprSyntax))
        """
      )
    }
    
    self = try arrayLiteral.elements.map { element in
      try Element(transflectingExprSyntax: element.expression)
    }
  }
  
}
