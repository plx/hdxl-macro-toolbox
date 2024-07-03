import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

public protocol ContextualizedMemberMacro: MemberMacro, ContextualizedTypeAttachedMacro, DiagnosticDomainAwareMacro {
  
  static func validateAttachmentContext(
    _ attachmentContext: some MemberMacroContextProtocol
  ) throws

  static func contextualizedExpansion(
    in attachmentContext: some MemberMacroContextProtocol
  ) throws -> [DeclSyntax]
    
}

extension ContextualizedMemberMacro {

  @inlinable
  public static func validateAttachmentContext(
    _ attachmentContext: some MemberMacroContextProtocol
  ) throws {
    return // default: always ok
  }

  @inlinable
  package static func withValidatedAttachmentContext<R, Declaration, ExpansionContext>(
    of node: AttributeSyntax,
    providingMembersOf declaration: Declaration,
    conformingTo protocols: [TypeSyntax],
    in context: ExpansionContext,
    _ closure: (MemberMacroContext<Declaration, ExpansionContext>) throws -> R
  ) throws -> R {
    let attachmentContext = MemberMacroContext(
      macroInvocationNode: node,
      declaration: declaration,
      conformedProtocols: protocols,
      expansionContext: context,
      diagnosticDomainIdentifier: diagnosticDomainIdentifier
    )
    
    try validateDeclarationArchetype(for: attachmentContext)
    try validateMacroInvocationNode(attachmentContext.macroInvocationNode)
    try validateAttachmentContext(attachmentContext)

    return try closure(attachmentContext)
  }

  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    try withAutomaticReformatting {
      try withValidatedAttachmentContext(
        of: node,
        providingMembersOf: declaration,
        conformingTo: protocols,
        in: context
      ) { attachmentContext in
        try contextualizedExpansion(in: attachmentContext)
      }
    }
  }

}
