import SwiftSyntax

public enum InlinabilityDisposition {
  case usableFromInline
  case inlinable
}

extension InlinabilityDisposition: Sendable {}
extension InlinabilityDisposition: Equatable {}
extension InlinabilityDisposition: Hashable {}
extension InlinabilityDisposition: CaseIterable {}
extension InlinabilityDisposition: Codable {}
extension InlinabilityDisposition: CustomStringConvertible { }
extension InlinabilityDisposition: CustomDebugStringConvertible { }

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
