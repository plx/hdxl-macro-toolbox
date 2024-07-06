import Foundation

public enum IntegerLiteralTransflectionError: Sendable, Error, LocalizedError {
  
  case unrepresentableIntegerLiteral(String)
  
}

extension BinaryInteger 
where
Self: TransflectableViaIntegerLiteralValue,
TransflectionIntegerValue: FixedWidthInteger
{
  
  @inlinable
  public init(transflectingIntegerLiteralValue integerLiteralValue: TransflectionIntegerValue) throws {
    guard let value = Self(exactly: integerLiteralValue) else {
      throw IntegerLiteralTransflectionError.unrepresentableIntegerLiteral(
        """
        Literal \(integerLiteralValue) out-of-range for \(Self.self)!
        """
      )
    }
    self = value
  }

}

extension Int: TransflectableViaIntegerLiteralValue {
  public typealias TransflectionIntegerValue = Int64
}

extension Int8: TransflectableViaIntegerLiteralValue {
  public typealias TransflectionIntegerValue = Int64
}

extension Int16: TransflectableViaIntegerLiteralValue {
  public typealias TransflectionIntegerValue = Int64
}

extension Int32: TransflectableViaIntegerLiteralValue {
  public typealias TransflectionIntegerValue = Int64
}

extension Int64: TransflectableViaIntegerLiteralValue {
  public typealias TransflectionIntegerValue = Int64
}

extension UInt: TransflectableViaIntegerLiteralValue {
  public typealias TransflectionIntegerValue = UInt64
}

extension UInt8: TransflectableViaIntegerLiteralValue {
  public typealias TransflectionIntegerValue = UInt64
}

extension UInt16: TransflectableViaIntegerLiteralValue {
  public typealias TransflectionIntegerValue = UInt64
}

extension UInt32: TransflectableViaIntegerLiteralValue {
  public typealias TransflectionIntegerValue = UInt64
}

extension UInt64: TransflectableViaIntegerLiteralValue {
  public typealias TransflectionIntegerValue = UInt64
}
