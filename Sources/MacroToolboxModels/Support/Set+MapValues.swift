
extension Set {
  
  /// Implements a set-to-set mapping.
  ///
  /// - parameters:
  ///   - expectUnique: if `true`, the result will pre-reserve `count` elements.
  ///   - transform: The transformation to apply.
  ///
  /// - returns: A `Set<V>` with the transformed elements from `self`.
  ///
  /// - note: This exists to avoid creating any transient, intermediate array (etc.).
  @inlinable
  package func setMap<V>(
    expectUnique: Bool = true,
    _ transform: (Element) throws -> V
  ) rethrows -> Set<V> where V: Hashable {
    guard !isEmpty else {
      return []
    }
    
    var result = Set<V>(
      minimumCapacity: expectUnique ? count : 0
    )
    
    for element in self {
      result.insert(try transform(element))
    }
    
    return result
  }
  
}
