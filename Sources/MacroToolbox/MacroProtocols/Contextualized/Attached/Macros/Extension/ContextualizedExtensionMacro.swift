import SwiftSyntax
import SwiftBasicFormat
import SwiftDiagnostics
import SwiftSyntaxMacros

public protocol ContextualizedExtensionMacro: ExtensionMacro, ContextualizedTypeAttachedMacro, DiagnosticDomainAwareMacro {
  
  static func validateAttachmentContext(
    _ attachmentContext: some ExtensionMacroContextProtocol
  ) throws

  static func contextualizedExpansion(
    in attachmentContext: some ExtensionMacroContextProtocol
  ) throws -> [ExtensionDeclSyntax]
    
}

extension ContextualizedExtensionMacro {

  @inlinable
  public static func validateAttachmentContext(
    _ attachmentContext: some ExtensionMacroContextProtocol
  ) throws {
    return // default: no-op
  }
  
  @inlinable
  package static func withValidatedAttachmentContext<R, Declaration, ExpansionContext, ExtendedType>(
    of node: AttributeSyntax,
    attachedTo declaration: Declaration,
    providingExtensionsOf type: ExtendedType,
    conformingTo protocols: [TypeSyntax],
    in context: ExpansionContext,
    _ closure: (ExtensionMacroContext<Declaration, ExpansionContext, ExtendedType>) throws -> R
  ) throws -> R {
    let attachmentContext = ExtensionMacroContext(
      macroInvocationNode: node,
      declaration: declaration,
      extendedType: type,
      conformedProtocols: protocols,
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
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    try withAutomaticReformatting {
      try withValidatedAttachmentContext(
        of: node,
        attachedTo: declaration,
        providingExtensionsOf: type,
        conformingTo: protocols,
        in: context
      ) { attachmentContext in
        try contextualizedExpansion(in: attachmentContext)
      }
    }
  }

}
