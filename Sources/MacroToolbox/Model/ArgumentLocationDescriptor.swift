
// ------------------------------------------------------------------------- //
// MARK: - ArgumentLocationDescriptor
// ------------------------------------------------------------------------- //

public struct ArgumentLocationDescriptor {
  
  @usableFromInline
  internal typealias Storage = ArgumentLocationDescriptorStorage
  
  @usableFromInline
  internal var storage: Storage
  
  @inlinable
  internal init(storage: Storage) {
    self.storage = storage
  }
  
}

// ------------------------------------------------------------------------- //
// MARK: - Synthesized Conformances
// ------------------------------------------------------------------------- //

extension ArgumentLocationDescriptor: Sendable { }
extension ArgumentLocationDescriptor: Equatable { }
extension ArgumentLocationDescriptor: Hashable { }
extension ArgumentLocationDescriptor: Codable { }

// ------------------------------------------------------------------------- //
// MARK: - CustomStringConvertible
// ------------------------------------------------------------------------- //

extension ArgumentLocationDescriptor: CustomStringConvertible {
  
  @inlinable
  public var description: String {
    String(describing: storage)
  }
  
}

// ------------------------------------------------------------------------- //
// MARK: - CustomDebugStringConvertible
// ------------------------------------------------------------------------- //

extension ArgumentLocationDescriptor: CustomDebugStringConvertible {
  
  @inlinable
  public var debugDescription: String {
    "ArgumentLocationDescriptor(storage: \(String(reflecting: storage)))"
  }
}

// ------------------------------------------------------------------------- //
// MARK: - API
// ------------------------------------------------------------------------- //

extension ArgumentLocationDescriptor {
  
  @inlinable
  public static func absolute(position offsetFromFirst: Int) -> Self {
    precondition(offsetFromFirst >= 0)
    return Self(storage: .position(.relativeToFirst(offsetFromFirst)))
  }
  
  @inlinable
  public static func offsetFromLast(by offsetFromLast: Int) -> Self {
    precondition(offsetFromLast >= 0)
    return Self(storage: .position(.relativeToLast(offsetFromLast)))
  }
  
  @inlinable
  public static func labeled(_ name: String) -> Self {
    precondition(!name.isEmpty)
    return Self(storage: .label(.labeled(name)))
  }
  
  public static let first = Self(storage: .position(.first))
  
  public static let last = Self(storage: .position(.last))
  
  @inlinable
  public func unlabeled() -> Self {
    Self(storage: storage.with(label: .unlabeled))
  }
  
  @inlinable
  public func with(label: String) -> Self {
    Self(storage: storage.with(label: label))
  }
  
  @inlinable
  public func with(absolutePosition offsetFromFirst: Int) -> Self {
    Self(
      storage: storage.with(
        absolutePosition: offsetFromFirst
      )
    )
  }
  
  @inlinable
  public func with(offsetFromLast: Int) -> Self {
    Self(
      storage: storage.with(
        offsetFromLast: offsetFromLast
      )
    )
  }
  
}
