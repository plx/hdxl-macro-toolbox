import MacroTransflection

// ------------------------------------------------------------------------- //
// MARK: InlinabilityDisposition
// ------------------------------------------------------------------------- //

public enum InlinabilityDisposition {
  case usableFromInline
  case inlinable
}

// ------------------------------------------------------------------------- //
// MARK: - Synthesized Conformances
// ------------------------------------------------------------------------- //

extension InlinabilityDisposition: Sendable {}
extension InlinabilityDisposition: Equatable {}
extension InlinabilityDisposition: Hashable {}
extension InlinabilityDisposition: CaseIterable {}
extension InlinabilityDisposition: Codable {}
extension InlinabilityDisposition: CustomStringConvertible { }
extension InlinabilityDisposition: CustomDebugStringConvertible { }

// ------------------------------------------------------------------------- //
// MARK: - MacroToolboxCaseNameAwareEnumeration
// ------------------------------------------------------------------------- //

extension InlinabilityDisposition: MacroToolboxCaseNameAwareEnumeration {
  
  @inlinable
  public var caseNameWithoutLeadingDot: String {
    switch self {
    case .usableFromInline:
      "usableFromInline"
    case .inlinable:
      "inlinable"
    }
  }
  
}

// ------------------------------------------------------------------------- //
// MARK: - TransflectableViaSourceCodeIdentifier, TransflectableViaSourceCodeIdentifierTable
// ------------------------------------------------------------------------- //

extension InlinabilityDisposition: TransflectableViaSourceCodeIdentifier, TransflectableViaSourceCodeIdentifierTable {
  @usableFromInline
  internal static let sourceCodeIdentifierTransflectionTable = _inferred
}
