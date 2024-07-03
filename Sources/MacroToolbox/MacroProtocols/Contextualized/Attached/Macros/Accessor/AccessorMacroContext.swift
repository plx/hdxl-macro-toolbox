import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

public struct AccessorMacroContext<Declaration, ExpansionContext>: AccessorMacroContextProtocol
where
Declaration: DeclSyntaxProtocol,
ExpansionContext: MacroExpansionContext
{
  
  public var macroInvocationNode: AttributeSyntax
  public var declaration: Declaration
  public var expansionContext: ExpansionContext
  public var diagnosticDomainIdentifier: String
  
  public init(
    macroInvocationNode: AttributeSyntax,
    declaration: Declaration,
    expansionContext: ExpansionContext,
    diagnosticDomainIdentifier: String
  ) {
    self.macroInvocationNode = macroInvocationNode
    self.declaration = declaration
    self.expansionContext = expansionContext
    self.diagnosticDomainIdentifier = diagnosticDomainIdentifier
  }
}
