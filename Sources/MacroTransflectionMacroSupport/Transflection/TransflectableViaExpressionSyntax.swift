import Foundation
import SwiftSyntax
import MacroTransflection

public enum TypedExpressionSyntaxTransflectionError: Sendable, Error, LocalizedError {
  
  case extractionFromWrongExpression(String)
}

public protocol TransflectableViaExpressionSyntax<TransflectionExpressionSyntax> : TransflectableViaExprSyntax {
  associatedtype TransflectionExpressionSyntax: ExprSyntaxProtocol
    
  init(expressionSyntax: TransflectionExpressionSyntax) throws
  
}

extension TransflectableViaExprSyntax where Self: TransflectableViaExpressionSyntax {
  
  @inlinable
  public init(exprSyntax: ExprSyntax) throws {
    guard
      let expressionSyntax = exprSyntax.as(TransflectionExpressionSyntax.self) 
    else {
      throw TypedExpressionSyntaxTransflectionError.extractionFromWrongExpression(
        """
        Couldn't convert `exprSyntax` to preferred-type:
        
        - `exprSyntax`: \(exprSyntax)
        - `ExpressionSyntax`: \(TransflectionExpressionSyntax.self)
        """
      )
    }
    
    try self.init(expressionSyntax: expressionSyntax)
  }
  
}
