
public protocol TransflectableViaIntegerLiteralValue<TransflectionIntegerValue> {
  associatedtype TransflectionIntegerValue: FixedWidthInteger
  
  init(transflectingIntegerLiteralValue integerLiteralValue: TransflectionIntegerValue) throws
  
}
