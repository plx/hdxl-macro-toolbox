
extension Sequence {
  
  /// Shorthand for `!allSatisfy { !predicate($0) }`.
  @inlinable
  package func anySatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
    for element in self where try predicate(element) {
      return true
    }
    
    return false
  }
  
}
