
/// A protocol for types that can be initialized from dictionary literals during macro expansion.
/// 
/// Conforming types can be extracted from Swift dictionary literals in macro arguments, enabling
/// strongly-typed parameter processing in macros.
public protocol TransflectableViaDictionaryLiteral<TransflectionDictionaryLiteralKey,TransflectionDictionaryLiteralValue>  {
  /// The key type for the dictionary literal.
  associatedtype TransflectionDictionaryLiteralKey: Hashable
  /// The value type for the dictionary literal.
  associatedtype TransflectionDictionaryLiteralValue
  
  /// Creates a new instance by extracting values from a dictionary literal.
  /// 
  /// - Parameter dictionaryLiteralValue: The dictionary representation of the literal 
  /// - Throws: If the dictionary literal value cannot be converted to a valid instance
  init(transflectingDictionaryLiteralValue dictionaryLiteralValue: [TransflectionDictionaryLiteralKey:TransflectionDictionaryLiteralValue]) throws
  
}
