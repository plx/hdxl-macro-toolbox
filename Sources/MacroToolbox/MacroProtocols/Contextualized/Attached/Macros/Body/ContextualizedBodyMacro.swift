import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

public protocol ContextualizedBodyMacro: BodyMacro, ContextualizedAttachedMacro, DiagnosticDomainAwareMacro {

  static func validateExpansionContext(
    _ expansionContext: some BodyMacroContextProtocol
  ) throws
  
  static func contextualizedExpansion(
    in attachmentContext: some BodyMacroContextProtocol
  ) throws -> [CodeBlockItemSyntax]
  
}

extension ContextualizedBodyMacro {
  
  @inlinable
  public static func validateExpansionContext(
    _ expansionContext: some BodyMacroContextProtocol
  ) throws {
    return // default: do nothing
  }
  
  @inlinable
  package static func withValidatedAttachmentContext<R, Declaration, ExpansionContext>(
    of node: AttributeSyntax,
    providingBodyFor declaration: Declaration,
    in context: ExpansionContext,
    _ closure: (any BodyMacroContextProtocol<Declaration, ExpansionContext>) throws -> R
  ) throws -> R
  where
    Declaration: DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
    ExpansionContext: MacroExpansionContext
  {
    let attachmentContext = BodyMacroContext(
      macroInvocationNode: node,
      declaration: declaration,
      expansionContext: context,
      diagnosticDomainIdentifier: diagnosticDomainIdentifier
    )
    
    try validateMacroInvocationNode(node)
    try validateDeclarationArchetype(for: attachmentContext)
    try validateDeclarationDetails(for: attachmentContext)
    try validateExpansionContext(attachmentContext)
    
    return try closure(attachmentContext)
  }
  
  
  @inlinable
  public static func expansion(
    of node: AttributeSyntax,
    providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
    in context: some MacroExpansionContext
  ) throws -> [CodeBlockItemSyntax] {
    try withAutomaticReformatting {
      try withValidatedAttachmentContext(
        of: node,
        providingBodyFor: declaration,
        in: context
      ) { expansionContext in
        try contextualizedExpansion(in: expansionContext)
      }
    }
  }
  
}
