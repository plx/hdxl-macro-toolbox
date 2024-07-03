import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

public protocol ContextualizedAccessorMacro: AccessorMacro, ContextualizedAttachedMacro, DiagnosticDomainAwareMacro {
  
  static func validateExpansionContext(
    _ expansionContext: some AccessorMacroContextProtocol
  ) throws

  static func contextualizedExpansion(
    in attachmentContext: some AccessorMacroContextProtocol
  ) throws -> [AccessorDeclSyntax]
  
}

extension ContextualizedAccessorMacro {

  @inlinable
  public static func validateExpansionContext(
    _ expansionContext: some AccessorMacroContextProtocol
  ) throws {
    return // default: do nothing
  }

  @inlinable
  package static func withValidatedAttachmentContext<R, Declaration, ExpansionContext>(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: Declaration,
    in context: ExpansionContext,
    _ closure: (AccessorMacroContext<Declaration, ExpansionContext>) throws -> R
  ) throws -> R {
    let expansionContext = AccessorMacroContext(
      macroInvocationNode: node,
      declaration: declaration,
      expansionContext: context,
      diagnosticDomainIdentifier: diagnosticDomainIdentifier
    )
    
    try validateMacroInvocationNode(node)
    try validateDeclarationArchetype(for: expansionContext)
    try validateExpansionContext(expansionContext)

    return try closure(expansionContext)
  }

  public static func expansion(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AccessorDeclSyntax] {
    try withAutomaticReformatting {
      try withValidatedAttachmentContext(
        of: node,
        providingAccessorsOf: declaration,
        in: context
      ) { expansionContext in
        try contextualizedExpansion(in: expansionContext)
      }
    }
  }
  
}
