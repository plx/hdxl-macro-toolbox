
extension Optional {
  
  @inlinable
  internal mutating func ensuredValue(
    guaranteedBy fallback: @autoclosure() -> Wrapped
  ) -> Wrapped {
    switch self {
    case .some(let value):
      return value
    case .none:
      let value = fallback()
      self = .some(value)
      return value
    }
  }
  
}
