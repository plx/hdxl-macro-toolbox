import MacroToolboxModels
import SwiftSyntax

/// A limitation or rejection with its original source node. These are analysis facts, not
/// diagnostics; callers choose diagnostic severity, wording, and expansion policy.
public struct StructAnalysisFinding: Sendable {
  public enum Reason: Sendable, Equatable, Hashable {
    case missingTypeAnnotation
    case unsupportedPattern
    case attributedBinding
    case lazyBinding
    case unfamiliarAccessors
    case conditionalMember
    case expandedMember
    case malformedSyntax
    case conflictingReadAccess
    case conflictingSetterAccess
    case unfamiliarAccessModifier
    case unsupportedMember(DeclarationArchetype?)
    case unsupportedAccessorShape(PropertyAccessorShape)
  }

  public let reason: Reason
  public let anchor: Syntax
  public let memberIndex: Int?
  public let bindingIndex: Int?
}

/// Every direct member is present, including nested types, conditional members, and unknown
/// declarations. Bindings are present only for a direct variable declaration, never descendants.
public struct StructMemberDescriptor: Sendable {
  public let index: Int
  public let source: MemberBlockItemSyntax
  public let kind: DeclarationArchetype?
  public let bindings: [StructBindingDescriptor]
  public let findings: [StructAnalysisFinding]
  public var declaration: DeclSyntax { source.decl }
}

/// Complete syntactic inventory of a struct's direct members. Inspect `findings` or use
/// `validated(using:)` before transforming. A written type is not resolved type identity;
/// attributes, conditional compilation, and macro expansions are never semantically evaluated.
public struct StructMemberAnalysis: Sendable {
  public let declaration: StructDeclSyntax
  public let members: [StructMemberDescriptor]
  public let findings: [StructAnalysisFinding]
  /// Access written on the attached struct, separate from each binding's own access.
  public var enclosingAccess: WrittenDeclarationAccess { .init(modifiers: declaration.modifiers) }
  /// All direct bindings in source order, including unsupported patterns with nil identifiers.
  public var bindings: [StructBindingDescriptor] { members.flatMap(\.bindings) }

  public init(_ declaration: StructDeclSyntax) {
    self.declaration = declaration
    var rootFindings = accessFindings(declaration.modifiers, memberIndex: nil)
    if declaration.hasError {
      rootFindings.append(.init(reason: .malformedSyntax, anchor: firstErroneousNode(Syntax(declaration)), memberIndex: nil, bindingIndex: nil))
    }
    members = declaration.memberBlock.members.enumerated().map { memberIndex, member in
      var findings: [StructAnalysisFinding] = []
      var bindings: [StructBindingDescriptor] = []
      let kind = member.decl.declarationArchetype
      if let variable = member.decl.as(VariableDeclSyntax.self) {
        findings += accessFindings(variable.modifiers, memberIndex: memberIndex)
        for (bindingIndex, binding) in variable.bindings.enumerated() {
          let descriptor = StructBindingDescriptor(memberIndex: memberIndex, bindingIndex: bindingIndex, variableDeclaration: variable, binding: binding)
          bindings.append(descriptor)
          func add(_ reason: StructAnalysisFinding.Reason, _ anchor: some SyntaxProtocol) {
            findings.append(.init(reason: reason, anchor: Syntax(anchor), memberIndex: memberIndex, bindingIndex: bindingIndex))
          }
          if descriptor.identifier == nil { add(.unsupportedPattern, binding.pattern) }
          if descriptor.explicitType == nil { add(.missingTypeAnnotation, binding) }
          for attribute in variable.attributes { add(.attributedBinding, attribute) }
          for modifier in variable.modifiers where modifier.name.tokenKind == .keyword(.lazy) { add(.lazyBinding, modifier) }
          if descriptor.accessorShape == .unfamiliar, let block = binding.accessorBlock { add(.unfamiliarAccessors, block) }
        }
      } else if member.decl.is(IfConfigDeclSyntax.self) {
        findings.append(.init(reason: .conditionalMember, anchor: Syntax(member.decl), memberIndex: memberIndex, bindingIndex: nil))
      } else if member.decl.is(MacroExpansionDeclSyntax.self) {
        findings.append(.init(reason: .expandedMember, anchor: Syntax(member.decl), memberIndex: memberIndex, bindingIndex: nil))
      } else if kind == nil {
        findings.append(.init(reason: .unsupportedMember(nil), anchor: Syntax(member.decl), memberIndex: memberIndex, bindingIndex: nil))
      }
      return .init(index: memberIndex, source: member, kind: kind, bindings: bindings, findings: findings)
    }
    findings = (rootFindings + members.flatMap(\.findings)).sorted {
      $0.anchor.positionAfterSkippingLeadingTrivia < $1.anchor.positionAfterSkippingLeadingTrivia
    }
  }
}

extension StructDeclSyntax {
  public func analyzeDirectMembers() -> StructMemberAnalysis { .init(self) }
}

private func accessFindings(_ modifiers: DeclModifierListSyntax, memberIndex: Int?) -> [StructAnalysisFinding] {
  let access = WrittenDeclarationAccess(modifiers: modifiers)
  var findings: [StructAnalysisFinding] = []
  func add(_ reason: StructAnalysisFinding.Reason, _ modifier: DeclModifierSyntax) {
    findings.append(.init(reason: reason, anchor: Syntax(modifier), memberIndex: memberIndex, bindingIndex: nil))
  }
  for modifier in access.readModifiers.dropFirst() { add(.conflictingReadAccess, modifier) }
  for modifier in access.setterModifiers.dropFirst() { add(.conflictingSetterAccess, modifier) }
  for modifier in modifiers where modifier.name.tokenKind.visibilityLevel != nil && modifier.detail != nil && modifier.setterVisibilityLevel == nil {
    add(.unfamiliarAccessModifier, modifier)
  }
  return findings
}

private func firstErroneousNode(_ node: Syntax) -> Syntax {
  for child in node.children(viewMode: .all) where child.hasError { return firstErroneousNode(child) }
  return node
}
