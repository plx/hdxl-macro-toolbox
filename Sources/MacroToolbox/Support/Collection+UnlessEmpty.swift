
extension Collection {
  
  @inlinable
  package var unlessEmpty: Self? {
    switch isEmpty {
    case false:
      self
    case true:
      nil
    }
  }
  
}
