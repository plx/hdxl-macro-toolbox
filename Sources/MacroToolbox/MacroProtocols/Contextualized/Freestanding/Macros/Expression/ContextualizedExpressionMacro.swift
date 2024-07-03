import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

public protocol ContextualizedExpressionMacro: ExpressionMacro, ContextualizedFreestandingMacro, DiagnosticDomainAwareMacro {
  
  static func validateFreestandingContext(
    _ expansionContext: some ExpressionMacroContextProtocol
  ) throws
  
  static func contextualizedExpansion(
    in attachmentContext: some ExpressionMacroContextProtocol
  ) throws -> ExprSyntax
  
}

extension ContextualizedExpressionMacro {

  @inlinable
  public static func validateFreestandingContext(
    _ expansionContext: some ExpressionMacroContextProtocol
  ) throws {
    return // default is: "ok"
  }
  

  @inlinable
  package static func withValidatedFreestandingContext<R, Invocation, ExpansionContext>(
    of invocation: Invocation,
    in context: ExpansionContext,
    _ closure: (ExpressionMacroContext<Invocation, ExpansionContext>) throws -> R
  ) throws -> R {
    let freestandingContext = ExpressionMacroContext(
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
  ) throws -> ExprSyntax {
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
