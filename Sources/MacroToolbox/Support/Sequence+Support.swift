
extension Sequence {
  
  /// Shorthand for `!allSatisfy { !predicate($0) }`.
  @inlinable
  package func anySatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
    for element in self where try predicate(element) {
      return true
    }
    
    return false
  }
  
  /// Returns the first non-`nil` value obtained from `extractor` (if any are found).
  @inlinable
  package func firstNonNilValue<T>(
    _ extractor: (Element) throws -> T?
  ) rethrows -> T? {
    for element in self {
      if let value = try extractor(element) {
        return value
      }
    }
    
    return nil
  }
  
  @inlinable
  package func dropNilElements<T>() -> [T] where Element == T? {
    compactMap { $0 }
  }
  
}
