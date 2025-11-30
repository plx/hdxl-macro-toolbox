
// MARK: ArgumentPositionDescriptor

public enum ArgumentPositionDescriptor {

  case solitary
  case relativeToFirst(Int)
  case relativeToLast(Int)

}

// MARK: - Synthesized Conformances

extension ArgumentPositionDescriptor: Sendable { }
extension ArgumentPositionDescriptor: Equatable { }
extension ArgumentPositionDescriptor: Hashable { }
extension ArgumentPositionDescriptor: Codable { }

// MARK: - Identifiable

extension ArgumentPositionDescriptor: Identifiable {
  public typealias ID = Self
  
  @inlinable
  public var id: ID { self }
 
}

// MARK: - CustomStringConvertible

extension ArgumentPositionDescriptor: CustomStringConvertible {
  
  @inlinable
  public var description: String {
    switch self {
    case .solitary:
      ".solitary"
    case .relativeToFirst(let offsetFromFirst):
      ".relativeToFirst(\(offsetFromFirst))"
    case .relativeToLast(let offsetFromLast):
      ".relativeToLast(\(offsetFromLast))"
    }
  }
  
}

// MARK: - CustomDebugStringConvertible

extension ArgumentPositionDescriptor: CustomDebugStringConvertible {
  
  @inlinable
  public var debugDescription: String {
    switch self {
    case .solitary:
      "ArgumentPositionDescriptor.solitary"
    case .relativeToFirst(let offsetFromFirst):
      "ArgumentPositionDescriptor.relativeToFirst(\(offsetFromFirst))"
    case .relativeToLast(let offsetFromLast):
      "ArgumentPositionDescriptor.relativeToLast(\(offsetFromLast))"
    }
  }
}

// MARK: - API

extension ArgumentPositionDescriptor {
  public static let first = Self.relativeToFirst(0)
  public static let last = Self.relativeToLast(0)
}

