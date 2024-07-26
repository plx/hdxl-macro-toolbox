
// ------------------------------------------------------------------------- //
// MARK: ArgumentLabelDescriptor
// ------------------------------------------------------------------------- //

/// Type used to represent an argument label.
public enum ArgumentLabelDescriptor {

  /// Corresponds to  the `_` for Swift's unlabeled arguments (e.g.`_` in a declaration).
  case unlabeled
  
  /// Corresponds to the label in a labeled argument (e.g. the `at` in `at target: Target`, say).
  case labeled(String)
  
}

// ------------------------------------------------------------------------- //
// MARK: - Synthesized Conformances
// ------------------------------------------------------------------------- //

extension ArgumentLabelDescriptor: Sendable { }
extension ArgumentLabelDescriptor: Equatable { }
extension ArgumentLabelDescriptor: Hashable { }
extension ArgumentLabelDescriptor: Codable { }

// ------------------------------------------------------------------------- //
// MARK: - Identifiable
// ------------------------------------------------------------------------- //

extension ArgumentLabelDescriptor: Identifiable {
  public typealias ID = Self
  
  @inlinable
  public var id: ID { self }
}

// ------------------------------------------------------------------------- //
// MARK: - CustomStringConvertible
// ------------------------------------------------------------------------- //

extension ArgumentLabelDescriptor: CustomStringConvertible {
  
  @inlinable
  public var description: String {
    switch self {
    case .unlabeled:
      ".unlabeled"
    case .labeled(let label):
      ".label(\"\(label)\")"
    }
  }
}

// ------------------------------------------------------------------------- //
// MARK: - CustomDebugStringConvertible
// ------------------------------------------------------------------------- //

extension ArgumentLabelDescriptor: CustomDebugStringConvertible {
  
  @inlinable
  public var debugDescription: String {
    switch self {
    case .unlabeled:
      "ArgumentLabelDescriptor.unlabeled"
    case .labeled(let label):
      "ArgumentLabelDescriptor.label(\"\(label)\")"
    }
  }
}

// ------------------------------------------------------------------------- //
// MARK: - API
// ------------------------------------------------------------------------- //

extension ArgumentLabelDescriptor {
  
  /// Constructs an `ArgumentLabelDescriptor` from the equivalent source-code (like `_` or `foo`).
  ///
  /// - warning: This doesn't attempt to *rigorously* verify that `declarationSourceCodeRepresentation` would be valid for use as an argument label in Swift source.
  @inlinable
  public init?(declarationSourceCodeRepresentation: String) {
    guard !declarationSourceCodeRepresentation.isEmpty else {
      return nil
    }
    
    if "_" == declarationSourceCodeRepresentation {
      self = .unlabeled
    } else if let _ = try? /\w+/.wholeMatch(in: declarationSourceCodeRepresentation) {
      self = .labeled(declarationSourceCodeRepresentation)
    } else {
      return nil
    }
    // TBD: do we want to be stricter vis-a-vis allowable labels?
    // For example, do we care enough here to rule out `__`-type labels?
    switch "_" == declarationSourceCodeRepresentation {
    case true:
      self = .unlabeled
    case false:
      self = .labeled(declarationSourceCodeRepresentation)
    }
  }
  
  /// Provides the textual represenation for this argument-label (e.g. `_` or `foo`).
  @inlinable
  public var declarationSourceCodeRepresentation: String {
    switch self {
    case .unlabeled:
      "_"
    case .labeled(let label):
      label
    }
  }
  
  /// Constructs appropriate *call-site* use for this argument-label with `argumentValue` (e.g. `argumentValue` or `foo: argumentValue`).
  @inlinable
  public func invocationSourceCodeRepresentation(forArgumentValue argumentValue: String) -> String {
    switch self {
    case .unlabeled:
      argumentValue
    case .labeled(let label):
      "\(label): \(argumentValue)"
    }
  }
  
}
