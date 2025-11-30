
// MARK: VisibilityLevel

/// Each case in ``VisibilityLevel`` corresponds to one of Swift's access levels.
///
/// This exists to streamline reasoning about access levels while expanding macros.
///
/// - seealso: ``InlinabilityDisposition``
/// - seealso: ``InlinabilityAnnotableDeclarationType``.
///
public enum VisibilityLevel: UInt8 {
  
  /// Corresponds to the `private` access level.
  case `private` = 0b00000001
  
  /// Corresponds to the `fileprivate` access level.
  case `fileprivate` = 0b00000010
  
  /// Corresponds to the `internal` access level.
  case `internal` = 0b00000100
  
  /// Corresponds to the `package` access level.
  case `package` = 0b00001000
  
  /// Corresponds to the `public` access level.
  case `public` = 0b00010000
  
  /// Corresponds to the `open` access level.
  case `open` = 0b00100000
}

// MARK: - Synthesized Conformances

extension VisibilityLevel: Sendable {}
extension VisibilityLevel: Equatable {}
extension VisibilityLevel: Hashable {}
extension VisibilityLevel: CaseIterable {}
extension VisibilityLevel: Codable {}
extension VisibilityLevel: CustomStringConvertible { }
extension VisibilityLevel: CustomDebugStringConvertible { }

// MARK: - Comparable

extension VisibilityLevel: Comparable {
  
  @inlinable
  public static func < (lhs: VisibilityLevel, rhs: VisibilityLevel) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
  
}

// MARK: - MacroToolboxCaseNameAwareEnumeration

extension VisibilityLevel: MacroToolboxCaseNameAwareEnumeration {
  
  @inlinable
  public var caseNameWithoutLeadingDot: String {
    switch self {
    case .private:
      "private"
    case .fileprivate:
      "fileprivate"
    case .internal:
      "internal"
    case .package:
      "package"
    case .public:
      "public"
    case .open:
      "open"
    }
  }
  
}

// MARK: - General API

extension VisibilityLevel {
  
  @inlinable
  public var isWithinPrivateTier: Bool {
    switch self {
    case .private, .fileprivate:
      true
    case .public, .open, .internal, .package:
      false
    }
  }
  
}
