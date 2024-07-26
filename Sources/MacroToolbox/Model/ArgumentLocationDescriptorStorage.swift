
@usableFromInline
internal enum ArgumentLocationDescriptorStorage {
  
  case position(ArgumentPositionDescriptor)
  case label(ArgumentLabelDescriptor)
  case positionAndLabel(ArgumentPositionDescriptor, ArgumentLabelDescriptor)
  
}

extension ArgumentLocationDescriptorStorage: Sendable { }
extension ArgumentLocationDescriptorStorage: Equatable { }
extension ArgumentLocationDescriptorStorage: Hashable { }
extension ArgumentLocationDescriptorStorage: Codable { }

extension ArgumentLocationDescriptorStorage: CustomStringConvertible {
  
  @inlinable
  internal var description: String {
    switch self {
    case .position(let position):
      ".position(\(String(describing: position)))"
    case .label(let argumentLabelDescriptor):
      ".label(\(String(describing: argumentLabelDescriptor)))"
    case .positionAndLabel(let position, let argumentLabelDescriptor):
      ".positionAndLabel(\(String(describing: position)), \(String(describing: argumentLabelDescriptor)))"
    }
  }
}

extension ArgumentLocationDescriptorStorage: CustomDebugStringConvertible {
  
  @inlinable
  internal var debugDescription: String {
    switch self {
    case .position(let position):
      "ArgumentLocationDescriptorStorage.position(\(String(reflecting: position)))"
    case .label(let argumentLabelDescriptor):
      "ArgumentLocationDescriptorStorage.label(\(String(reflecting: argumentLabelDescriptor)))"
    case .positionAndLabel(let position, let argumentLabelDescriptor):
      ".positionAndLabel(\(String(reflecting: position)), \(String(reflecting: argumentLabelDescriptor)))"
    }
  }
}

extension ArgumentLocationDescriptorStorage {
  
  @inlinable
  internal var positionDescriptor: ArgumentPositionDescriptor? {
    switch self {
    case .position(let argumentPositionDescriptor):
      argumentPositionDescriptor
    case .label:
      nil
    case .positionAndLabel(let argumentPositionDescriptor, _):
      argumentPositionDescriptor
    }
  }
  
  @inlinable
  internal var labelDescriptor: ArgumentLabelDescriptor? {
    switch self {
    case .position:
      nil
    case .label(let argumentLabelDescriptor):
      argumentLabelDescriptor
    case .positionAndLabel(_, let argumentLabelDescriptor):
      argumentLabelDescriptor
    }
  }
  
  @inlinable
  internal func with(label: String) -> Self {
    with(label: .labeled(label))
  }
  
  @inlinable
  internal func with(label: ArgumentLabelDescriptor) -> Self {
    switch positionDescriptor {
    case .some(let position):
        .positionAndLabel(position, label)
    case .none:
        .label(label)
    }
  }
  
  @inlinable
  internal func with(absolutePosition offsetFromFirst: Int) -> Self {
    with(position: .relativeToFirst(offsetFromFirst))
  }
  
  @inlinable
  internal func with(offsetFromLast: Int) -> Self {
    with(position: .relativeToLast(offsetFromLast))
  }
  
  @inlinable
  internal func with(position: ArgumentPositionDescriptor) -> Self {
    switch labelDescriptor {
    case .some(let label):
        .positionAndLabel(position, label)
    case .none:
        .position(position)
    }
  }
  
}
