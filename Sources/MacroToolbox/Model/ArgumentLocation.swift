
public enum ArgumentLabelDescriptor {
  
  case unlabeled
  case label(String)
  
}

extension ArgumentLabelDescriptor: Sendable { }
extension ArgumentLabelDescriptor: Equatable { }
extension ArgumentLabelDescriptor: Hashable { }
extension ArgumentLabelDescriptor: Codable { }


public struct ArgumentLocation {
  
  public var positionIndex: Int
  public var argumentLabel: ArgumentLabelDescriptor
  
  @inlinable
  public init(
    positionIndex: Int,
    argumentLabel: ArgumentLabelDescriptor
  ) {
    self.positionIndex = positionIndex
    self.argumentLabel = argumentLabel
  }
  
}

extension ArgumentLocation: Sendable { }
extension ArgumentLocation: Equatable { }
extension ArgumentLocation: Hashable { }
extension ArgumentLocation: Codable { }

extension ArgumentLocation: CustomStringConvertible {
  
  @inlinable
  public var description: String {
    "\(positionIndex) (\(String(describing: argumentLabel))"
  }
  
}
