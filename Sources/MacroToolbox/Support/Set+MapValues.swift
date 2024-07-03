
extension Set {
  
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
