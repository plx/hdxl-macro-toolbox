import Foundation
import SwiftSyntax
import SwiftParser
import MacroToolbox
import MacroTransflection

// MARK: - OptionalExprTransflectionError

public enum OptionalExprTransflectionError: Error, LocalizedError {
  case invalidExplicitSomeExpression(String)
  case unableToTransflectWrappedValue(any Error)
}

extension Optional: TransflectableViaExprSyntax where Wrapped: TransflectableViaExprSyntax {
  
  @inlinable
  public static var translectionTypeNamesForStaticMemberAccessSyntax: Set<String> {
    Set<String>(
      Wrapped
        .translectionTypeNamesForStaticMemberAccessSyntax
        .lazy
        .flatMap { explicitWrappedTypeName in
          [
            "Optional<\(explicitWrappedTypeName)>",
            "\(explicitWrappedTypeName)?"
          ]
        }
    )
  }
  
  @inlinable
  package init(transflectingFunctionCallExprSyntaxIfExplicitSome functionCallExprSyntax: FunctionCallExprSyntax) throws {
    guard
      let memberAccessExpression = functionCallExprSyntax.calledExpression.as(MemberAccessExprSyntax.self)
    else {
      throw OptionalExprTransflectionError.invalidExplicitSomeExpression(
        """
        We can only handle something like `.some(_)`, but got \(functionCallExprSyntax.trimmed)!
        """
      )
    }
    
    guard
      memberAccessExpression.isCompatibleWithTypeLevelPropertyAccess(
        forBaseTypeNames: Self.translectionTypeNamesForStaticMemberAccessSyntax
      )
    else {
      throw OptionalExprTransflectionError.invalidExplicitSomeExpression(
        """
        This expression appears to have an incompatible explicit-type annotation: \(functionCallExprSyntax.trimmed)!
        """
      )
    }
      
    guard
      memberAccessExpression.period.tokenKind == .period
    else {
      throw OptionalExprTransflectionError.invalidExplicitSomeExpression(
        """
        This expression appears to have an incompatible explicit-type annotation: \(functionCallExprSyntax.trimmed)!
        """
      )
    }

    guard
      .identifier("some") == memberAccessExpression.declName.baseName.tokenKind
    else {
      throw OptionalExprTransflectionError.invalidExplicitSomeExpression(
        """
        We can only handle the explicit-some statement here, but got \(functionCallExprSyntax.trimmed)
        """
      )
    }

    guard
      memberAccessExpression.declName.argumentNames == nil
    else {
      throw OptionalExprTransflectionError.invalidExplicitSomeExpression(
        """
        We can only handle something like `.some(_)`, but got \(functionCallExprSyntax.trimmed)!
        """
      )
    }
    
    guard
      functionCallExprSyntax.arguments.count == 1,
      let onlyArgument = functionCallExprSyntax.arguments.first,
      onlyArgument.label == nil,
      onlyArgument.colon == nil
    else {
      throw OptionalExprTransflectionError.invalidExplicitSomeExpression(
        """
        We can only handle something like `.some(_)`, but got \(functionCallExprSyntax.trimmed)!
        """
      )
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
    
    do {
      self = .some(
        try Wrapped.init(transflectingExprSyntax: exprSyntax)
      )
    }
    catch let error {
      throw OptionalExprTransflectionError.unableToTransflectWrappedValue(error)
    }
  }

}
