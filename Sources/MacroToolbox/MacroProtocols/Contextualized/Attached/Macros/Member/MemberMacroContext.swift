import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


public struct MemberMacroContext<Declaration, ExpansionContext>: MemberMacroContextProtocol
where
Declaration: DeclGroupSyntax,
ExpansionContext: MacroExpansionContext
{
  
  public var macroInvocationNode: AttributeSyntax
  public var declaration: Declaration
  public var conformedProtocols: [TypeSyntax]
  public var expansionContext: ExpansionContext
  public var diagnosticDomainIdentifier: String
  
  public init(
    macroInvocationNode: AttributeSyntax,
    declaration: Declaration,
    conformedProtocols: [TypeSyntax],
    expansionContext: ExpansionContext,
    diagnosticDomainIdentifier: String
  ) {
    self.macroInvocationNode = macroInvocationNode
    self.declaration = declaration
    self.conformedProtocols = conformedProtocols
    self.expansionContext = expansionContext
    self.diagnosticDomainIdentifier = diagnosticDomainIdentifier
  }
}
