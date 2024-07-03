
extension Optional: TransflectableViaNilLiteralValue {
  
  @inlinable
  public init(transflectingNilLiteralValue nilLiteralValue: Void) throws {
    self = nil
  }
  
}

extension Optional: TransflectableViaBooleanLiteralValue where Wrapped: TransflectableViaBooleanLiteralValue {
  
  @inlinable
  public init(transflectingBooleanLiteralValue booleanLiteralValue: Bool) throws {
    self = .some(
      try Wrapped(transflectingBooleanLiteralValue: booleanLiteralValue)
    )
  }
  
}

extension Optional: TransflectableViaIntegerLiteralValue where Wrapped: TransflectableViaIntegerLiteralValue {
  
  @inlinable
  public init(transflectingIntegerLiteralValue integerLiteralValue: Int) throws {
    self = .some(
      try Wrapped(transflectingIntegerLiteralValue: integerLiteralValue)
    )
  }
  
}

extension Optional: TransflectableViaFloatLiteralValue where Wrapped: TransflectableViaFloatLiteralValue {
  
  @inlinable
  public init(transflectingFloatLiteralValue floatLiteralValue: Double) throws {
    self = .some(
      try Wrapped(transflectingFloatLiteralValue: floatLiteralValue)
    )
  }
  
}

extension Optional: TransflectableViaStringLiteralValue where Wrapped: TransflectableViaStringLiteralValue {
  
  @inlinable
  public init(transflectingStringLiteralValue stringLiteralValue: String) throws {
    self = .some(
      try Wrapped(transflectingStringLiteralValue: stringLiteralValue)
    )
  }
  
}

extension Optional: TransflectableViaArrayLiteral where Wrapped: TransflectableViaArrayLiteral {
  public typealias TransflectionArrayLiteralElement = Wrapped.TransflectionArrayLiteralElement
  
  @inlinable
  public init(transflectingArrayLiteralValue arrayLiteralValue: [TransflectionArrayLiteralElement]) throws {
    self = .some(
      try Wrapped(transflectingArrayLiteralValue: arrayLiteralValue)
    )
  }
  
}

extension Optional: TransflectableViaDictionaryLiteral where Wrapped: TransflectableViaDictionaryLiteral {
  public typealias TransflectionDictionaryLiteralKey = Wrapped.TransflectionDictionaryLiteralKey
  public typealias TransflectionDictionaryLiteralValue = Wrapped.TransflectionDictionaryLiteralValue
  
  @inlinable
  public init(transflectingDictionaryLiteralValue dictionaryLiteralValue: [TransflectionDictionaryLiteralKey: TransflectionDictionaryLiteralValue]) throws {
    self = .some(
      try Wrapped(transflectingDictionaryLiteralValue: dictionaryLiteralValue)
    )
  }
  
}

