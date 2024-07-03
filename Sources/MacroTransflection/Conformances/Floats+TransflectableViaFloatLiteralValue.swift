import Foundation

public enum FloatLiteralTransflectionError: Sendable, Error, LocalizedError {
  
  case unrepresentableFloatLiteral(String)
  
}

extension BinaryFloatingPoint where Self: TransflectableViaFloatLiteralValue {
  
  @inlinable
  public init(transflectingFloatLiteralValue floatLiteralValue: Double) throws {
    guard let value = Self(exactly: floatLiteralValue) else {
      throw FloatLiteralTransflectionError.unrepresentableFloatLiteral(
        """
        Unable to exactly represent `floatLiteralValue` \(floatLiteralValue) as `\(String(reflecting: Self.self))`!
        """
      )
    }
    
    self = value
  }
  
}

extension Float16: TransflectableViaFloatLiteralValue { }
extension Float: TransflectableViaFloatLiteralValue { }
extension Double: TransflectableViaFloatLiteralValue { }
