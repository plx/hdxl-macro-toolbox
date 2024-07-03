import Foundation
import SwiftSyntax
import MacroToolbox
import MacroTransflection

public enum FloatLiteralSyntaxTransflectionError: Sendable, Error, LocalizedError {
  
  case unableToExtractFloatValue(String)
}

extension TransflectableViaExpressionSyntax<FloatLiteralExprSyntax> where Self: TransflectableViaFloatLiteralValue {
  
  @inlinable
  public init(expressionSyntax: FloatLiteralExprSyntax) throws {
    guard let floatLiteralValue = expressionSyntax.representedFloatLiteralValue else {
      throw FloatLiteralSyntaxTransflectionError.unableToExtractFloatValue(
        """
        Unable to transflect float-literal value while transflecting \(String(reflecting: Self.self)) from \(expressionSyntax)!
        """
      )
    }
    
    try self.init(transflectingFloatLiteralValue: floatLiteralValue)
  }
  
}
