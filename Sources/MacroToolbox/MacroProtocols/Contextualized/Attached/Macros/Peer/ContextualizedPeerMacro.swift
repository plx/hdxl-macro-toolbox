import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

public protocol ContextualizedPeerMacro: PeerMacro, ContextualizedAttachedMacro, DiagnosticDomainAwareMacro {
  
  static func validateAttachmentContext(
    _ attachmentContext: some PeerMacroContextProtocol
  ) throws

  static func contextualizedExpansion(
    in attachmentContext: some PeerMacroContextProtocol
  ) throws -> [DeclSyntax]
  
}

extension ContextualizedPeerMacro {

  @inlinable
  public static func validateAttachmentContext(
    _ attachmentContext: some PeerMacroContextProtocol
  ) throws {
    return // default: no-op
  }

  @inlinable
  package static func withValidatedAttachmentContext<R, Declaration, ExpansionContext>(
    of node: AttributeSyntax,
    providingPeersOf declaration: Declaration,
    in context: ExpansionContext,
    _ closure: (PeerMacroContext<Declaration, ExpansionContext>) throws -> R
  ) throws -> R {
    let attachmentContext = PeerMacroContext(
      macroInvocationNode: node,
      declaration: declaration,
      expansionContext: context,
      diagnosticDomainIdentifier: diagnosticDomainIdentifier
    )
    
    try validateDeclarationArchetype(for: attachmentContext)
    try validateMacroInvocationNode(attachmentContext.macroInvocationNode)
    try validateDeclarationDetails(for: attachmentContext)
    try validateAttachmentContext(attachmentContext)

    return try closure(attachmentContext)
  }

  public static func expansion(
    of node: AttributeSyntax,
    providingPeersOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    try withAutomaticReformatting {
      try withValidatedAttachmentContext(
        of: node,
        providingPeersOf: declaration,
        in: context
      ) { attachmentContext in
        try contextualizedExpansion(in: attachmentContext)
      }
    }
  }
  
}
