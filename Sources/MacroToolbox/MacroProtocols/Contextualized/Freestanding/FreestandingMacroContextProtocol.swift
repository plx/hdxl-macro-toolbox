import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


/// ``FreestandingMacroContextProtocol`` refines ``MacroContextProtocol`` and specializes it for use with the freestanding macros.
public protocol FreestandingMacroContextProtocol<ExpansionContext> : MacroContextProtocol
where MacroNode: FreestandingMacroExpansionSyntax
{ }

extension FreestandingMacroContextProtocol {
  
  @inlinable
  public var invocationArgumentsAsLabeledExpressionList: LabeledExprListSyntax? {
    macroInvocationNode.arguments
  }
  
}
