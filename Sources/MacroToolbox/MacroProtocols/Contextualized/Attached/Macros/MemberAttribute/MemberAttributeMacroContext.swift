import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


public struct MemberAttributeMacroContext<Declaration, ExpansionContext, Member>: MemberAttributeMacroContextProtocol
where
Declaration: DeclGroupSyntax,
ExpansionContext: MacroExpansionContext,
Member: DeclSyntaxProtocol
{
  
  public var macroInvocationNode: AttributeSyntax
  public var declaration: Declaration
  public var member: Member
  public var expansionContext: ExpansionContext
  public var diagnosticDomainIdentifier: String
  
  public init(
    macroInvocationNode: AttributeSyntax,
    declaration: Declaration,
    member: Member,
    expansionContext: ExpansionContext,
    diagnosticDomainIdentifier: String
  ) {
    self.macroInvocationNode = macroInvocationNode
    self.declaration = declaration
    self.member = member
    self.expansionContext = expansionContext
    self.diagnosticDomainIdentifier = diagnosticDomainIdentifier
  }
}
