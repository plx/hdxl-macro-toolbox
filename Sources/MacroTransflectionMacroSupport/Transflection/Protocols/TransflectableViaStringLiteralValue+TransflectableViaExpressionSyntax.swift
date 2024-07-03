import Foundation
import SwiftSyntax
import SwiftParser
import MacroToolbox
import MacroTransflection

public enum StringLiteralSyntaxTransflectionError: Sendable, Error, LocalizedError {
  
  case unableToExtractStringLiteralValue(String)
}

extension TransflectableViaExpressionSyntax<StringLiteralExprSyntax> where Self: TransflectableViaStringLiteralValue {
  
  @inlinable
  public init(expressionSyntax: StringLiteralExprSyntax) throws {
    guard let stringLiteralValue = expressionSyntax.representedLiteralValue else {
      throw StringLiteralSyntaxTransflectionError.unableToExtractStringLiteralValue(
        """
        Unable to transflect string-literal value while transflecting \(String(reflecting: Self.self)) from \(expressionSyntax)!
        """
      )
    }
    
    try self.init(transflectingStringLiteralValue: stringLiteralValue)
  }
  
}
