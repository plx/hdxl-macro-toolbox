import SwiftSyntax

/// Each case corresponds to a *type-level* declaration archetype.
///
/// This enumeration can be considered a refinement of ``DeclarationArchetype``.
///
/// - seealso: ``DeclarationArchetype``
public enum TypeDeclarationArchetype {
  case `actor`
  case `class`
  case `enum`
  case `struct`
  case `protocol`
}

extension TypeDeclarationArchetype: Sendable { }
extension TypeDeclarationArchetype: Equatable { }
extension TypeDeclarationArchetype: Hashable { }
extension TypeDeclarationArchetype: Codable { }
extension TypeDeclarationArchetype: CaseIterable { }

extension TypeDeclarationArchetype: MacroToolboxCaseNameAwareEnumeration {
  
  @inlinable
  public var caseNameWithoutLeadingDot: String {
    switch self {
    case .actor:
      "actor"
    case .enum:
      "enum"
    case .class:
      "class"
    case .struct:
      "struct"
    case .protocol:
      "protocol"
    }
  }
  
}

extension TypeDeclarationArchetype: CustomStringConvertible { }
extension TypeDeclarationArchetype: CustomDebugStringConvertible { }

extension TypeDeclarationArchetype {
  
  @usableFromInline
  package static let setOfAllCases = Set(allCases)
  
  @inlinable
  public var isNotAProtocol: Bool {
    self != .protocol
  }
  
  @inlinable
  public var isEnumClassOrStruct: Bool {
    switch self {
    case .actor:
      false
    case .class:
      true
    case .enum:
      true
    case .struct:
      true
    case .protocol:
      false
    }
  }
  
  @inlinable
  public var isActorClassOrStruct: Bool {
    switch self {
    case .actor:
      true
    case .class:
      true
    case .enum:
      false
    case .struct:
      true
    case .protocol:
      false
    }
  }
  
}
