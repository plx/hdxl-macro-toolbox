import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

public protocol ContextualizedMemberAttributeMacro: MemberAttributeMacro, ContextualizedTypeAttachedMacro, DiagnosticDomainAwareMacro {

  static func validateAttachmentContext(
    _ attachmentContext: some MemberAttributeMacroContextProtocol
  ) throws
  
  static func contextualizedExpansion(
    in attachmentContext: some MemberAttributeMacroContextProtocol
  ) throws -> [AttributeSyntax]
    
}

extension ContextualizedMemberAttributeMacro {
  
  @inlinable
  public static func validateAttachmentContext(
    _ attachmentContext: some MemberAttributeMacroContextProtocol
  ) throws {
    return // default: no-op
  }

  @inlinable
  package static func withValidatedAttachmentContext<R, Declaration, ExpansionContext, Member>(
    of node: AttributeSyntax,
    attachedTo declaration: Declaration,
    providingAttributesFor member: Member,
    in context: ExpansionContext,
    _ closure: (MemberAttributeMacroContext<Declaration, ExpansionContext, Member>) throws -> R
  ) throws -> R {
    let attachmentContext = MemberAttributeMacroContext(
      macroInvocationNode: node,
      declaration: declaration,
      member: member,
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
    attachedTo declaration: some DeclGroupSyntax,
    providingAttributesFor member: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AttributeSyntax] {
    try withAutomaticReformatting {
      try withValidatedAttachmentContext(
        of: node,
        attachedTo: declaration,
        providingAttributesFor: member,
        in: context
      ) { attachmentContext in
        try contextualizedExpansion(in: attachmentContext)
      }
    }
  }

}
