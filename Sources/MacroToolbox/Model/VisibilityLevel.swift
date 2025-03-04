import MacroTransflection

// ------------------------------------------------------------------------- //
// MARK: VisibilityLevel
// ------------------------------------------------------------------------- //

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

// ------------------------------------------------------------------------- //
// MARK: - Synthesized Conformances
// ------------------------------------------------------------------------- //

extension VisibilityLevel: Sendable {}
extension VisibilityLevel: Equatable {}
extension VisibilityLevel: Hashable {}
extension VisibilityLevel: CaseIterable {}
extension VisibilityLevel: Codable {}
extension VisibilityLevel: CustomStringConvertible { }
extension VisibilityLevel: CustomDebugStringConvertible { }

// ------------------------------------------------------------------------- //
// MARK: - Comparable
// ------------------------------------------------------------------------- //

extension VisibilityLevel: Comparable {
  
  /// Compares two visibility levels.
  ///
  /// Visibility levels are ordered from most restrictive (`private`) to least restrictive (`open`).
  ///
  /// - Parameters:
  ///   - lhs: The left-hand side visibility level
  ///   - rhs: The right-hand side visibility level
  /// - Returns: `true` if `lhs` is more restrictive than `rhs`
  @inlinable
  public static func < (lhs: VisibilityLevel, rhs: VisibilityLevel) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
  
}

// ------------------------------------------------------------------------- //
// MARK: - MacroToolboxCaseNameAwareEnumeration
// ------------------------------------------------------------------------- //

extension VisibilityLevel: MacroToolboxCaseNameAwareEnumeration {
  
  /// Returns the case name as a string without a leading dot.
  ///
  /// This property is useful when generating Swift code that refers to visibility modifiers.
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

// ------------------------------------------------------------------------- //
// MARK: - TransflectableViaSourceCodeIdentifier, TransflectableViaSourceCodeIdentifierTable
// ------------------------------------------------------------------------- //

extension VisibilityLevel: TransflectableViaSourceCodeIdentifier, TransflectableViaSourceCodeIdentifierTable {
  @usableFromInline
  internal static let sourceCodeIdentifierTransflectionTable = _inferred
}

// ------------------------------------------------------------------------- //
// MARK: - General API
// ------------------------------------------------------------------------- //

extension VisibilityLevel {
  
  /// Indicates whether this visibility level is within the "private tier".
  ///
  /// Returns `true` for `.private` and `.fileprivate`, and `false` for all other visibility levels.
  /// This is useful when determining if a declaration is private to its containing module.
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
