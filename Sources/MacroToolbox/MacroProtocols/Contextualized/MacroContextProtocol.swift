import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

/// ``MacroContextProtocol`` is a base protocol corresponding to the lowest-common-denominator set of information available to *all* macros during expansion.
///
/// This exists primarily as an "attachment point" for utility code that streamlines capturing diagnostics while (a) validating macro invocation sites and also (b) providing macro expansions.
public protocol MacroContextProtocol<MacroNode, ExpansionContext> {
  
  /// The concrete syntax-type for the macro's invocation.
  ///
  /// Will be `AttributeSyntax` for attached macros and `FreestandingMacroExpansionSyntax` for freestanding macros.
  associatedtype MacroNode: SyntaxProtocol
  
  /// The concrete type of the `MacroExpansionContext` supplied for this expansion.
  associatedtype ExpansionContext: MacroExpansionContext
  
  /// The concrete syntax node that invoked this macro.
  var macroInvocationNode: MacroNode { get }
  
  /// An arbitrary string-identifier identifying the *domain* for any diagnostics.
  ///
  /// - note: At present, we have a 1:1 relationship between diagnostic identifiers and concrete macro types.
  var diagnosticDomainIdentifier: String { get }
  
  /// The macro-expansion-context for this macro's invocation.
  var expansionContext: ExpansionContext { get }
  
  /// An arbitrary syntax node that acts as the default node for diagnostic *attribution* (e.g. which node "claims" the diagnostic).
  var syntaxNodeForAttribution: any SyntaxProtocol { get }
  
  /// An arbitrary syntax node that acts as the default node for diagnostic *positioning* (e.g. *where* the diagnostic sits in the syntax tree).
  var syntaxNodeForPositioning: any SyntaxProtocol { get }
  
  ///
  /// - note: This is made into a customization point so that we can
  var invocationArgumentsAsLabeledExpressionList: LabeledExprListSyntax? { get }
}

extension MacroContextProtocol {
    
  public var syntaxNodeForAttribution: any SyntaxProtocol {
    macroInvocationNode
  }

  public var syntaxNodeForPositioning: any SyntaxProtocol {
    macroInvocationNode
  }

}

