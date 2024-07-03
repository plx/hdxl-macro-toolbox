import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


public struct DeclarationMacroContext<MacroNode,ExpansionContext>: DeclarationMacroContextProtocol
where
MacroNode: FreestandingMacroExpansionSyntax,
ExpansionContext: MacroExpansionContext
{
  
  public var macroInvocationNode: MacroNode
  public var expansionContext: ExpansionContext
  public var diagnosticDomainIdentifier: String
  
  public init(
    macroInvocationNode: MacroNode,
    expansionContext: ExpansionContext,
    diagnosticDomainIdentifier: String
  ) {
    self.macroInvocationNode = macroInvocationNode
    self.expansionContext = expansionContext
    self.diagnosticDomainIdentifier = diagnosticDomainIdentifier
  }
}
