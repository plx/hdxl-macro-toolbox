import SwiftSyntax
import MacroTransflection

/// ``TransparentDisposition`` corresponds to the `@_transparent` attribute.
public enum TransparentDisposition {
  case transparent
}

extension TransparentDisposition: Sendable {}
extension TransparentDisposition: Equatable {}
extension TransparentDisposition: Hashable {}
extension TransparentDisposition: CaseIterable {}
extension TransparentDisposition: Codable {}
extension TransparentDisposition: CustomStringConvertible { }
extension TransparentDisposition: CustomDebugStringConvertible { }

extension TransparentDisposition: MacroToolboxCaseNameAwareEnumeration {
  
  @inlinable
  public var caseNameWithoutLeadingDot: String {
    switch self {
    case .transparent:
      "transparent"
    }
  }
}

extension TransparentDisposition: TransflectableViaSourceCodeIdentifier, TransflectableViaSourceCodeIdentifierTable {
  @usableFromInline
  internal static let sourceCodeIdentifierTransflectionTable = _inferred
}
