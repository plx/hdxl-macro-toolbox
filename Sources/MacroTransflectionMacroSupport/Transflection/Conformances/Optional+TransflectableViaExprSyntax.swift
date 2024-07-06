import Foundation
import SwiftSyntax
import SwiftParser
import MacroToolbox
import MacroTransflection

// MARK: Conformances

extension Optional: TransflectableViaExprSyntax where Wrapped: TransflectableViaExprSyntax {
  
  
  @inlinable
  package init(transflectingFunctionCallExprSyntaxIfExplicitSome functionCallExprSyntax: FunctionCallExprSyntax) throws {
    guard
      let memberAccessExpression = functionCallExprSyntax.calledExpression.as(MemberAccessExprSyntax.self)
    else {
      fatalError()
    }
    
    guard
      memberAccessExpression.isCompatibleWithTypeLevelPropertyAccess(forBaseType: Self.self)
    else {
      fatalError()
    }
      
    guard
      memberAccessExpression.period.tokenKind == .period
    else {
      fatalError()
    }
    
    guard
      memberAccessExpression.declName.argumentNames == nil
    else {
      fatalError()
    }
    
    guard
      functionCallExprSyntax.arguments.count == 1,
      let onlyArgument = functionCallExprSyntax.arguments.first,
      onlyArgument.label == nil,
      onlyArgument.colon == nil
    else {
      fatalError()
    }
    
    self = .some(
      try Wrapped(transflectingExprSyntax: onlyArgument.expression)
    )
  }
  
  @inlinable
  public init(transflectingExprSyntax exprSyntax: ExprSyntax) throws {
    if exprSyntax.is(NilLiteralExprSyntax.self) {
      try self.init(transflectingNilLiteralValue: ())
      return
    } else if let functionCallExprSyntax = exprSyntax.as(FunctionCallExprSyntax.self) {
      try self.init(transflectingFunctionCallExprSyntaxIfExplicitSome: functionCallExprSyntax)
      return
    }
    
    if 
      let memberAccessExprSyntax = exprSyntax.as(MemberAccessExprSyntax.self),
      memberAccessExprSyntax.isCompatibleWithTypeLevelPropertyAccess(forBaseType: Self.self),
      memberAccessExprSyntax.isExplicitNone
    {
      try self.init(transflectingNilLiteralValue: ())
      return
    }
    
    self = .some(
      try Wrapped.init(transflectingExprSyntax: exprSyntax)
    )
  }

}

// MARK: - IntegerExprTransflectionError

public enum OptionalExprTransflectionError: Error, LocalizedError {
  case unsupportedExprSyntax(String)
}
