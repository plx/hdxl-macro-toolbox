import SwiftSyntax

/// ``ExplicitInlineDisposition`` corresponds to the valid flavors of explicit `@inline($disposition)` attributes.
public enum ExplicitInlineDisposition {
  case always
  case never
}

extension ExplicitInlineDisposition: Sendable {}
extension ExplicitInlineDisposition: Equatable {}
extension ExplicitInlineDisposition: Hashable {}
extension ExplicitInlineDisposition: CaseIterable {}
extension ExplicitInlineDisposition: Codable {}
extension ExplicitInlineDisposition: CustomStringConvertible { }
extension ExplicitInlineDisposition: CustomDebugStringConvertible { }

extension ExplicitInlineDisposition: MacroToolboxCaseNameAwareEnumeration {
  
  @inlinable
  public var caseNameWithoutLeadingDot: String {
    switch self {
    case .always:
      "always"
    case .never:
      "never"
    }
  }
  
}
