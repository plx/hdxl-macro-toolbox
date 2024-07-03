import Foundation
import SwiftSyntax
import MacroTransflection

public enum TypedExpressionSyntaxTransflectionError: Sendable, Error, LocalizedError {
  
  case extractionFromWrongExpression(String)
}

public protocol TransflectableViaExpressionSyntax<ExpressionSyntax> : TransflectableViaExprSyntax {
  associatedtype ExpressionSyntax: ExprSyntaxProtocol
    
  init(expressionSyntax: ExpressionSyntax) throws
  
}

extension TransflectableViaExprSyntax where Self: TransflectableViaExpressionSyntax {
  
  @inlinable
  public init(exprSyntax: ExprSyntax) throws {
    guard
      let expressionSyntax = exprSyntax.as(ExpressionSyntax.self) 
    else {
      throw TypedExpressionSyntaxTransflectionError.extractionFromWrongExpression(
        """
        Couldn't convert `exprSyntax` to preferred-type:
        
        - `exprSyntax`: \(exprSyntax)
        - `ExpressionSyntax`: \(ExpressionSyntax.self)
        """
      )
    }
    
    try self.init(expressionSyntax: expressionSyntax)
  }
  
}
