import MacroToolboxModels
import SwiftSyntax

/// A syntactic accessor classification; it does not establish property-wrapper storage semantics.
public enum PropertyAccessorShape: Sendable, Equatable, Hashable {
  case stored
  case observed
  case computed
  case unfamiliar
}

/// One original binding, including unsupported patterns and unavailable type annotations.
/// Equality/hashing use the original syntax-node identities and source ordinals, not printed text.
public struct StructBindingDescriptor: Sendable, Equatable, Hashable {
  public let memberIndex: Int
  public let bindingIndex: Int
  public let variableDeclaration: VariableDeclSyntax
  public let binding: PatternBindingSyntax

  public var pattern: PatternSyntax { binding.pattern }
  public var identifier: TokenSyntax? { pattern.as(IdentifierPatternSyntax.self)?.identifier }
  /// Original identifier spelling, including backticks; nil for an unsupported pattern.
  public var name: String? { identifier?.text }
  /// Written annotation only. No type is inferred from an initializer or a neighboring binding.
  public var explicitType: TypeSyntax? { binding.typeAnnotation?.type }
  public var initializer: ExprSyntax? { binding.initializer?.value }
  public var bindingSpecifier: TokenSyntax { variableDeclaration.bindingSpecifier }
  public var isLet: Bool { bindingSpecifier.tokenKind == .keyword(.let) }
  public var isTypeProperty: Bool { modifiers.contains { $0.name.tokenKind == .keyword(.static) || $0.name.tokenKind == .keyword(.class) } }
  public var isLazy: Bool { modifiers.contains { $0.name.tokenKind == .keyword(.lazy) } }
  public var attributes: AttributeListSyntax { variableDeclaration.attributes }
  public var modifiers: DeclModifierListSyntax { variableDeclaration.modifiers }
  public var writtenAccess: WrittenDeclarationAccess { .init(modifiers: modifiers) }
  public var accessorBlock: AccessorBlockSyntax? { binding.accessorBlock }

  public var accessorShape: PropertyAccessorShape {
    guard let block = accessorBlock else { return .stored }
    guard !block.hasError else { return .unfamiliar }
    switch block.accessors {
    case .getter: return .computed
    case .accessors(let accessors):
      let names = accessors.map { $0.accessorSpecifier.text }
      let unique = Set(names)
      guard !names.isEmpty, names.count == unique.count else { return .unfamiliar }
      if unique.isSubset(of: ["willSet", "didSet"]) { return .observed }
      if unique.contains("get"), unique.isSubset(of: ["get", "set"]) { return .computed }
      return .unfamiliar
    }
  }
}
