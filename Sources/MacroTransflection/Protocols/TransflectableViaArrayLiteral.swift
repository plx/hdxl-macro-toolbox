
public protocol TransflectableViaArrayLiteral<TransflectionArrayLiteralElement> {
  associatedtype TransflectionArrayLiteralElement
  
  init(transflectingArrayLiteralValue arrayLiteralValue: [TransflectionArrayLiteralElement]) throws
  
}
