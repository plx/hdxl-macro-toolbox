import Foundation

public enum IntegerLiteralTransflectionError: Sendable, Error, LocalizedError {
  
  case unrepresentableIntegerLiteral(String)
  
}

extension BinaryInteger where Self: TransflectableViaIntegerLiteralValue {
  
  @inlinable
  public init(transflectingIntegerLiteralValue integerLiteralValue: Int) throws {
    guard let value = Self(exactly: integerLiteralValue) else {
      throw IntegerLiteralTransflectionError.unrepresentableIntegerLiteral(
        """
        Unable to exactly represent `integerLiteralValue` \(integerLiteralValue) as `\(String(reflecting: Self.self))`!
        """
      )
    }
    
    self = value
  }

}

extension Int: TransflectableViaIntegerLiteralValue { }
extension Int8: TransflectableViaIntegerLiteralValue { }
extension Int16: TransflectableViaIntegerLiteralValue { }
extension Int32: TransflectableViaIntegerLiteralValue { }
extension Int64: TransflectableViaIntegerLiteralValue { }

extension UInt: TransflectableViaIntegerLiteralValue { }
extension UInt8: TransflectableViaIntegerLiteralValue { }
extension UInt16: TransflectableViaIntegerLiteralValue { }
extension UInt32: TransflectableViaIntegerLiteralValue { }
extension UInt64: TransflectableViaIntegerLiteralValue { }
