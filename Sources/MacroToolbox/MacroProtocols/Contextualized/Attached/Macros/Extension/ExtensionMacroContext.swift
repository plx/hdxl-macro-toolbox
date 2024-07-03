import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


public struct ExtensionMacroContext<Declaration, ExpansionContext, ExtendedType>: ExtensionMacroContextProtocol
where
Declaration: DeclGroupSyntax,
ExpansionContext: MacroExpansionContext,
ExtendedType: TypeSyntaxProtocol
{
  
  public var macroInvocationNode: AttributeSyntax
  public var declaration: Declaration
  public var extendedType: ExtendedType
  public var conformedProtocols: [TypeSyntax]
  public var expansionContext: ExpansionContext
  public var diagnosticDomainIdentifier: String
  
  public init(
    macroInvocationNode: AttributeSyntax,
    declaration: Declaration,
    extendedType: ExtendedType,
    conformedProtocols: [TypeSyntax],
    expansionContext: ExpansionContext,
    diagnosticDomainIdentifier: String
  ) {
    self.macroInvocationNode = macroInvocationNode
    self.declaration = declaration
    self.extendedType = extendedType
    self.conformedProtocols = conformedProtocols
    self.expansionContext = expansionContext
    self.diagnosticDomainIdentifier = diagnosticDomainIdentifier
  }
}
