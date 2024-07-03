import Foundation

public enum StringLiteralTransflectionError: Sendable, Error, LocalizedError {
  
  case unrepresentableIntegerLiteral(String)
  
}

extension String: TransflectableViaStringLiteralValue {
  
  @inlinable
  public init(transflectingStringLiteralValue stringLiteralValue: String) throws {
    self = stringLiteralValue
  }
  
}
