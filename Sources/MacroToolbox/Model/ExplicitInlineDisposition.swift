
// MARK: ExplicitInlineDisposition

/// ``ExplicitInlineDisposition`` corresponds to the valid flavors of explicit `@inline($disposition)` attributes.
public enum ExplicitInlineDisposition {
  case always
  case never
}

// MARK: - Synthesized Conformances

extension ExplicitInlineDisposition: Sendable {}
extension ExplicitInlineDisposition: Equatable {}
extension ExplicitInlineDisposition: Hashable {}
extension ExplicitInlineDisposition: CaseIterable {}
extension ExplicitInlineDisposition: Codable {}
extension ExplicitInlineDisposition: CustomStringConvertible { }
extension ExplicitInlineDisposition: CustomDebugStringConvertible { }

// MARK: - MacroToolboxCaseNameAwareEnumeration

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

// MARK: - API

extension ExplicitInlineDisposition {
  
  @inlinable
  public func appropriateDisposition(
    forAttachmentSite attachmentSite: PerformanceAnnotationAttachmentSite
  ) -> Self? {
    switch attachmentSite {
    case .typeDeclaration:
      nil
    case .storedPropertyDeclaration:
      nil
    case .functionOrMethodDeclaration:
      self
    }
  }
  
}
