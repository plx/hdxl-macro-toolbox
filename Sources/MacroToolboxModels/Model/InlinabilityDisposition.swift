
// MARK: InlinabilityDisposition

public enum InlinabilityDisposition {
  case usableFromInline
  case inlinable
}

// MARK: - Synthesized Conformances

extension InlinabilityDisposition: Sendable {}
extension InlinabilityDisposition: Equatable {}
extension InlinabilityDisposition: Hashable {}
extension InlinabilityDisposition: CaseIterable {}
extension InlinabilityDisposition: Codable {}
extension InlinabilityDisposition: CustomStringConvertible { }
extension InlinabilityDisposition: CustomDebugStringConvertible { }

// MARK: - MacroToolboxCaseNameAwareEnumeration

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

extension InlinabilityDisposition {

  /// Obtains the disposition's textual representation (e.g. suitable for `"\(raw: )"` interpolation).
  @inlinable
  public var sourceCodeStringRepresentation: String {
    switch self {
    case .usableFromInline:
      "@usableFromInline"
    case .inlinable:
      "@inlinable"
    }
  }

}
