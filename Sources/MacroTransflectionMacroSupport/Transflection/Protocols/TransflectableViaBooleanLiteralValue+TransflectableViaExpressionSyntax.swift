import Foundation
import SwiftSyntax
import MacroToolbox
import MacroTransflection

public enum BooleanLiteralSyntaxTransflectionError: Sendable, Error, LocalizedError {
  
  case unableToExtractBooleanValue(String)
}

extension TransflectableViaExpressionSyntax<BooleanLiteralExprSyntax> where Self: TransflectableViaBooleanLiteralValue {
  
  @inlinable
  public init(expressionSyntax: BooleanLiteralExprSyntax) throws {
    guard let boolLiteralValue = expressionSyntax.representedBooleanLiteralValue else {
      throw BooleanLiteralSyntaxTransflectionError.unableToExtractBooleanValue(
        """
        Unable to transflect boolean-literal value while transflecting \(String(reflecting: Self.self)) from \(expressionSyntax)!
        """
      )
    }
    
    try self.init(transflectingBooleanLiteralValue: boolLiteralValue)
  }
  
}
