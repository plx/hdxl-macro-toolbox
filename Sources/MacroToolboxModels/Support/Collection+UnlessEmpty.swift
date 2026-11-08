
extension Collection {
  
  /// `self` when non-empty, `nil` when empty.
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
