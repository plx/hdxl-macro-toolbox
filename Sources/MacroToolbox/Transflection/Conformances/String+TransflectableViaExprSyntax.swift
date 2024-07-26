import Foundation
import SwiftSyntax
import SwiftParser
import MacroTransflection

// MARK: Conformances

extension String: TransflectableViaExprSyntax { }

// MARK: - StringExprTransflectionError

public enum StringExprTransflectionError: Error, LocalizedError {
  case noCompatibleStringLiteral(String)
  case unsupportedExprSyntax(String)
}

// MARK: - Conformance Implementation

extension String {
  
  @inlinable
  package init(transflectingSimpleStringLiteralExprSyntax simpleStringLiteralExprSyntax: SimpleStringLiteralExprSyntax) throws {
    guard let representedStringLiteralValue = simpleStringLiteralExprSyntax.representedStringLiteralValue else {
      throw StringExprTransflectionError.noCompatibleStringLiteral(
        """
        No compatible string-literal-value identified within `\(simpleStringLiteralExprSyntax)`!
        """
      )
    }
    
    try self.init(transflectingStringLiteralValue: representedStringLiteralValue)
  }

  @inlinable
  package init(transflectingStringLiteralExprSyntax stringLiteralExprSynax: StringLiteralExprSyntax) throws {
    guard let representedStringLiteralValue = stringLiteralExprSynax.representedLiteralValue else {
      throw StringExprTransflectionError.noCompatibleStringLiteral(
        """
        No compatible string-literal-value identified within `\(stringLiteralExprSynax)`!
        """
      )
    }
    
    try self.init(transflectingStringLiteralValue: representedStringLiteralValue)
  }

  @inlinable
  public init(transflectingExprSyntax exprSyntax: ExprSyntax) throws {
    if let simpleStringLiteralExprSyntax = exprSyntax.as(SimpleStringLiteralExprSyntax.self) {
      try self.init(transflectingSimpleStringLiteralExprSyntax: simpleStringLiteralExprSyntax)
    } else if let stringLiteralExprSynax = exprSyntax.as(StringLiteralExprSyntax.self) {
      try self.init(transflectingStringLiteralExprSyntax: stringLiteralExprSynax)
    } else {
      throw StringExprTransflectionError.unsupportedExprSyntax(
        """
        Unable to transflect unsupported expr-syntax \(exprSyntax)!
        """
      )
    }
  }
  
}

