
public enum MacroAttachmentRequirement<T> where T :Hashable {
  case unspecified
  case exactly(T)
  case mustBeOneOf(Set<T>)
  case anythingBut(Set<T>)
}

extension MacroAttachmentRequirement: Sendable where T: Sendable { }
extension MacroAttachmentRequirement: Equatable { }
extension MacroAttachmentRequirement: Encodable where T: Encodable { }
extension MacroAttachmentRequirement: Decodable where T: Decodable { }

extension MacroAttachmentRequirement: CustomStringConvertible {
  
  @inlinable
  public var description: String {
    switch self {
    case .unspecified:
      ".unspecified"
    case .exactly(let exactType):
      ".exactly(\(String(describing: exactType)))"
    case .mustBeOneOf(let allowedTypes):
      ".mustBeOneOf(\(String(describing: allowedTypes)))"
    case .anythingBut(let excludedTypes):
      ".anythingBut(\(String(describing: excludedTypes)))"
    }
  }
  
}

extension MacroAttachmentRequirement: CustomDebugStringConvertible {
  
  @inlinable
  public var debugDescription: String {
    switch self {
    case .unspecified:
      "MacroAttachmentRequirement.unspecified"
    case .exactly(let exactType):
      "MacroAttachmentRequirement.exactly(\(String(reflecting: exactType)))"
    case .mustBeOneOf(let allowedTypes):
      "MacroAttachmentRequirement.mustBeOneOf(\(String(reflecting: allowedTypes)))"
    case .anythingBut(let excludedTypes):
      "MacroAttachmentRequirement.anythingBut(\(String(reflecting: excludedTypes)))"
    }
  }

}

extension MacroAttachmentRequirement {
  
  @inlinable
  public func isCompatible(with value: T) -> Bool {
    switch self {
    case .unspecified:
      true
    case .exactly(let exactRequirement):
      exactRequirement == value
    case .mustBeOneOf(let allowedValues):
      allowedValues.contains(value)
    case .anythingBut(let excludedValues):
      !excludedValues.contains(value)
    }
  }
  
}

extension MacroAttachmentRequirement {
  
  @inlinable
  package var hasConsistentInternalState: Bool {
    switch self {
    case .unspecified:
      true
    case .exactly:
      true
    case .mustBeOneOf(let allowedTypes):
      !allowedTypes.isEmpty
    case .anythingBut(let excludedTypes):
      !excludedTypes.isEmpty
    }
  }
  
  @inlinable
  public func mapRequirements<V>(
    _ transform: (T) throws -> V
  ) rethrows -> MacroAttachmentRequirement<V> where V: Hashable {
    assert(hasConsistentInternalState)
    switch self {
    case .unspecified:
      return .unspecified
    case .exactly(let exactType):
      return .exactly(try transform(exactType))
    case .mustBeOneOf(let allowedTypes):
      let result = MacroAttachmentRequirement<V>.mustBeOneOf(
        try allowedTypes.setMap(transform)
      )
      
      assert(result.hasConsistentInternalState)
      return result
    case .anythingBut(let excludedTypes):
      let result = MacroAttachmentRequirement<V>.anythingBut(
        try excludedTypes.setMap(transform)
      )
      
      assert(result.hasConsistentInternalState)
      return result
    }
  }
  
}
