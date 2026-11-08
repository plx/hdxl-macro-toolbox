
// MARK: TypeDeclarationArchetype

/// Each case corresponds to a *type-level* declaration archetype.
///
/// This enumeration can be considered a refinement of ``DeclarationArchetype``.
///
/// - seealso: ``DeclarationArchetype``
public enum TypeDeclarationArchetype {
  /// Corresponds to `actor` type-declarations.
  case `actor`
  
  /// Corresponds to `class` type-declarations.
  case `class`
  
  /// Corresponds to `enum` type-declarations.
  case `enum`
  
  /// Corresponds to `struct` type-declarations.
  case `struct`
  
  /// Corresponds to `protocol` type-declarations.
  case `protocol`
}

// MARK: - Synthesized Conformances

extension TypeDeclarationArchetype: Sendable { }
extension TypeDeclarationArchetype: Equatable { }
extension TypeDeclarationArchetype: Hashable { }
extension TypeDeclarationArchetype: Codable { }
extension TypeDeclarationArchetype: CaseIterable { }
extension TypeDeclarationArchetype: CustomStringConvertible { }
extension TypeDeclarationArchetype: CustomDebugStringConvertible { }

// MARK: - MacroToolboxCaseNameAwareEnumeration

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

// MARK: - Additional API

extension TypeDeclarationArchetype {
  
  @usableFromInline
  package static let setOfAllCases = Set(allCases)
  
  /// `true` iff this is anything *but* a protocol.
  @inlinable
  public var isNotAProtocol: Bool {
    self != .protocol
  }
  
  /// `true` iff `self` is either an `enum`, `class`, or `struct`.
  ///
  /// - note: This exists b/c we check for this combo fairly often (e.g. for "types with implementations but *not* isolation).
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
  
  /// `true` iff `self` is either an `actor`, `class`, or `struct`.
  ///
  /// - note: This exists b/c we check for this combo fairly often (e.g. for "types with implementations *and* stored properties").
  /// - seealso: ``isNotEnumOrProtocol``, which has identical semantics but different emphasis when reading.
  ///
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

  /// `true` iff `self` is anything other than an `enum` or `protocol`.
  ///
  /// - note: This exists b/c we check for this combo fairly often (e.g. for "types with implementations *and* stored properties").
  /// - seealso: ``isActorClassOrStruct``, which has identical semantics but different emphasis when reading.
  ///
  @inlinable
  public var isNotEnumOrProtocol: Bool {
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
