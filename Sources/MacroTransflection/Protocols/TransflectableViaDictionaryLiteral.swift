
public protocol TransflectableViaDictionaryLiteral<TransflectionDictionaryLiteralKey,TransflectionDictionaryLiteralValue>  {
  associatedtype TransflectionDictionaryLiteralKey: Hashable
  associatedtype TransflectionDictionaryLiteralValue
  
  init(transflectingDictionaryLiteralValue dictionaryLiteralValue: [TransflectionDictionaryLiteralKey:TransflectionDictionaryLiteralValue]) throws
  
}
