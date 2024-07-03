import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

public protocol ContextualizedDeclarationMacro: DeclarationMacro, ContextualizedFreestandingMacro, DiagnosticDomainAwareMacro {
  
  static func validateFreestandingContext(
    _ expansionContext: some DeclarationMacroContextProtocol
  ) throws
  
  static func contextualizedExpansion(
    in attachmentContext: some DeclarationMacroContextProtocol
  ) throws -> [DeclSyntax]
  
}

extension ContextualizedDeclarationMacro {
  
  @inlinable
  package static func withValidatedFreestandingContext<R, Invocation, ExpansionContext>(
    of invocation: Invocation,
    in context: ExpansionContext,
    _ closure: (DeclarationMacroContext<Invocation, ExpansionContext>) throws -> R
  ) throws -> R {
    let freestandingContext = DeclarationMacroContext(
      macroInvocationNode: invocation,
      expansionContext: context,
      diagnosticDomainIdentifier: diagnosticDomainIdentifier
    )
    
    try validateMacroInvocationNode(invocation)
    try validateFreestandingContext(freestandingContext)
    
    return try closure(freestandingContext)
  }
  
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    try withAutomaticReformatting {
      try withValidatedFreestandingContext(
        of: node,
        in: context
      ) { freestandingContext in
        try contextualizedExpansion(in: freestandingContext)
      }
    }
  }
  
}
