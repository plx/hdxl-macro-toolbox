import Foundation

public enum FloatLiteralTransflectionError: Sendable, Error, LocalizedError {
  
  case unrepresentableFloatLiteral(String)
  
}

extension BinaryFloatingPoint where Self: TransflectableViaFloatLiteralValue {
  
  @inlinable
  public init(transflectingFloatLiteralValue floatLiteralValue: Double) throws {
    if floatLiteralValue.isSignalingNaN {
      self = .signalingNaN
    } else if floatLiteralValue.isNaN {
      self = .nan
    } else if floatLiteralValue == .infinity {
      self = .infinity
    } else if floatLiteralValue == -.infinity {
      self = -.infinity
    } else if let value = Self(exactly: floatLiteralValue) {
      self = value
    } else {
      throw FloatLiteralTransflectionError.unrepresentableFloatLiteral(
        """
        Unable to exactly represent `floatLiteralValue` \(floatLiteralValue) as `\(String(reflecting: Self.self))`!
        """
      )
    }
  }
  
}

extension Float16: TransflectableViaFloatLiteralValue { }
extension Float: TransflectableViaFloatLiteralValue { }
extension Double: TransflectableViaFloatLiteralValue { }
