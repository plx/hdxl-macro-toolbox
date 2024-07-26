import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


// -------------------------------------------------------------------------- //
// MARK: AttachedMacroContextProtocol
// -------------------------------------------------------------------------- //

/// ``AttachedMacroContextProtocol`` refines ``MacroContextProtocol`` and specializes it for use with attached macros.
public protocol AttachedMacroContextProtocol<Declaration, ExpansionContext> : MacroContextProtocol
where MacroNode == AttributeSyntax
{
  
  /// The concrete syntax-type of the declaration to-which this macro was attached.
  associatedtype Declaration: DeclSyntaxProtocol
  
  /// The declaration to-which we're attached.
  var declaration: Declaration { get }
  
}

extension AttachedMacroContextProtocol {
  
  @inlinable
  public var invocationArgumentsAsLabeledExpressionList: LabeledExprListSyntax? {
    guard case .argumentList(let argumentList) = macroInvocationNode.arguments else {
      return nil
    }
    
    return argumentList
  }
  
}
