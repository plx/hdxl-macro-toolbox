import Foundation

public enum RawRepresentableTransflectionError: Sendable, Error, LocalizedError {
  
  case invalidRawValue(String)
  
  @inlinable
  internal static func forRawValueConversionFailure<T, RawValue, LiteralValue>(
    toType type: T.Type,
    rawValue: RawValue,
    literalValue: LiteralValue,
    function: StaticString
  ) -> Self {
    .invalidRawValue(
      """
      Unable to construct \(type) via `rawValue` (\(rawValue)) obtained-from \(literalValue) (in: \(function))!
      """
    )
  }
}

extension RawRepresentable {
  
  @inlinable
  internal init<T>(
    rawValue: RawValue,
    transflectedVia literalValue: T,
    function: StaticString = #function
  ) throws {
    switch Self(rawValue: rawValue) {
    case .some(let value):
      self = value
    case .none:
      throw RawRepresentableTransflectionError.forRawValueConversionFailure(
        toType: Self.self,
        rawValue: rawValue,
        literalValue: literalValue,
        function: function
      )
    }
  }

  @inlinable
  internal init(
    rawValueTransflectedViaNilLiteral rawValue: RawValue,
    function: StaticString = #function
  ) throws {
    switch Self(rawValue: rawValue) {
    case .some(let value):
      self = value
    case .none:
      throw RawRepresentableTransflectionError.forRawValueConversionFailure(
        toType: Self.self,
        rawValue: rawValue,
        literalValue: (),
        function: function
      )
    }
  }

}

extension RawRepresentable where Self: TransflectableViaNilLiteralValue, RawValue: TransflectableViaNilLiteralValue {
  
  @inlinable
  public init(transflectingNilLiteralValue nilLiteralValue: Void) throws {
    try self.init(
      rawValueTransflectedViaNilLiteral: try RawValue(
        transflectingNilLiteralValue: nilLiteralValue
      )
    )
  }
  
}

extension RawRepresentable where Self: TransflectableViaBooleanLiteralValue, RawValue: TransflectableViaBooleanLiteralValue {
  
  @inlinable
  public init(transflectingBooleanLiteralValue booleanLiteralValue: Bool) throws {
    try self.init(
      rawValue: try RawValue(
        transflectingBooleanLiteralValue: booleanLiteralValue
      ),
      transflectedVia: booleanLiteralValue
    )
  }
  
}

extension RawRepresentable where Self: TransflectableViaIntegerLiteralValue, RawValue: TransflectableViaIntegerLiteralValue {
  
  @inlinable
  public init(transflectingIntegerLiteralValue integerLiteralValue: Int) throws {
    try self.init(
      rawValue: try RawValue(
        transflectingIntegerLiteralValue: integerLiteralValue
      ),
      transflectedVia: integerLiteralValue
    )
  }
  
}

extension RawRepresentable where Self: TransflectableViaFloatLiteralValue, RawValue: TransflectableViaFloatLiteralValue {
  
  @inlinable
  public init(transflectingFloatLiteralValue floatLiteralValue: Double) throws {
    try self.init(
      rawValue: try RawValue(
        transflectingFloatLiteralValue: floatLiteralValue
      ),
      transflectedVia: floatLiteralValue
    )
  }
  
}

extension RawRepresentable where Self: TransflectableViaStringLiteralValue, RawValue: TransflectableViaStringLiteralValue {
  
  @inlinable
  public init(transflectingStringLiteralValue stringLiteralValue: String) throws {
    try self.init(
      rawValue: try RawValue(
        transflectingStringLiteralValue: stringLiteralValue
      ),
      transflectedVia: stringLiteralValue
    )
  }
  
}

// these would be nice to have but as-of today (7/3/2024) they just cause compiler crashes:
//extension RawRepresentable where Self: TransflectableViaArrayLiteral, RawValue: TransflectableViaArrayLiteral<TransflectionArrayLiteralElement>
//{
//  
//  @inlinable
//  public init(transflectingArrayLiteralValue arrayLiteralValue: [TransflectionArrayLiteralElement]) throws {
//    try self.init(
//      rawValue: try RawValue(
//        transflectingArrayLiteralValue: arrayLiteralValue
//      ),
//      transflectedVia: arrayLiteralValue
//    )
//  }
//  
//}
//
//extension RawRepresentable where Self: TransflectableViaDictionaryLiteral, RawValue: TransflectableViaDictionaryLiteral<TransflectionDictionaryLiteralKey, TransflectionDictionaryLiteralValue>
//{
//  
//  @inlinable
//  public init(transflectingDictionaryLiteralValue dictionaryLiteralValue: [TransflectionDictionaryLiteralKey:TransflectionDictionaryLiteralValue]) throws {
//    try self.init(
//      rawValue: try RawValue(
//        transflectingDictionaryLiteralValue: dictionaryLiteralValue
//      ),
//      transflectedVia: dictionaryLiteralValue
//    )
//  }
//  
//}
