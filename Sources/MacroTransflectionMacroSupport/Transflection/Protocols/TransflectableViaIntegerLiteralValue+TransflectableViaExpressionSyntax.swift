import Foundation
import SwiftSyntax
import MacroToolbox
import MacroTransflection

public enum IntegerLiteralSyntaxTransflectionError: Sendable, Error, LocalizedError {
  
  case unableToExtractIntegerValue(String)
}

extension TransflectableViaExpressionSyntax<IntegerLiteralExprSyntax> where Self: TransflectableViaIntegerLiteralValue {
  
  @inlinable
  public init(expressionSyntax: IntegerLiteralExprSyntax) throws {
    guard let integerLiteralValue = expressionSyntax.representedIntegerLiteralValue else {
      throw IntegerLiteralSyntaxTransflectionError.unableToExtractIntegerValue(
        """
        Unable to transflect integer-literal value while transflecting \(String(reflecting: Self.self)) from \(expressionSyntax)!
        """
      )
    }
    
    try self.init(transflectingIntegerLiteralValue: integerLiteralValue)
  }
  
}
