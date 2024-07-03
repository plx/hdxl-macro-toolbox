

extension Bool: TransflectableViaBooleanLiteralValue {
  
  @inlinable
  public init(transflectingBooleanLiteralValue booleanLiteralValue: Bool) throws {
    self = booleanLiteralValue
  }
  
}
