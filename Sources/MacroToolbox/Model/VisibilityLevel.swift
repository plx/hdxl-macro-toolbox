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
public enum VisibilityLevel {
  
  /// Corresponds to the `private` access level.
  case `private`
  
  /// Corresponds to the `fileprivate` access level.
  case `fileprivate`
  
  /// Corresponds to the `internal` access level.
  case `internal`
  
  /// Corresponds to the `package` access level.
  case `package`
  
  /// Corresponds to the `public` access level.
  case `public`
  
  /// Corresponds to the `open` access level.
  case `open`
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
// MARK: - MacroToolboxCaseNameAwareEnumeration
// ------------------------------------------------------------------------- //

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

// ------------------------------------------------------------------------- //
// MARK: - TransflectableViaSourceCodeIdentifier, TransflectableViaSourceCodeIdentifierTable
// ------------------------------------------------------------------------- //

extension VisibilityLevel: TransflectableViaSourceCodeIdentifier, TransflectableViaSourceCodeIdentifierTable {
  @usableFromInline
  internal static let sourceCodeIdentifierTransflectionTable = _inferred
}
