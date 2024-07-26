import Foundation
import SwiftSyntax
import SwiftParser
import MacroTransflection

// MARK: Conformances

extension Bool: TransflectableViaExprSyntax { }

// MARK: - BoolExprTransflectionError

public enum BoolExprTransflectionError: Error, LocalizedError {
  case noIdentifiableBooleanLiteral(String)
  case unsupportedExprSyntax(String)
}

// MARK: - Conformance Implementation

extension Bool {
  
  @inlinable
  package init(transflectingBooleanLiteralExprSyntax booleanLiteralExprSyntax: BooleanLiteralExprSyntax) throws {
    guard let representedBooleanLiteralValue = booleanLiteralExprSyntax.representedBooleanLiteralValue else {
      throw BoolExprTransflectionError.noIdentifiableBooleanLiteral(
        """
        No identifiable bool-literal-value identified within `\(booleanLiteralExprSyntax)`!
        """
      )
    }
    
    try self.init(transflectingBooleanLiteralValue: representedBooleanLiteralValue)
  }
    
  @inlinable
  public init(transflectingExprSyntax exprSyntax: ExprSyntax) throws {
    if let booleanLiteralSynax = exprSyntax.as(BooleanLiteralExprSyntax.self) {
      try self.init(transflectingBooleanLiteralExprSyntax: booleanLiteralSynax)
    } else {
      throw BoolExprTransflectionError.unsupportedExprSyntax(
        """
        Unable to transflect unsupported expr-syntax \(exprSyntax)!
        """
      )
    }
  }
  
}

