import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

/// A concrete implementation of `AccessorMacroContextProtocol` that provides context for accessor macro expansion.
///
/// This struct encapsulates all the information needed for an accessor macro to perform its expansion,
/// including the original macro invocation, the declaration being processed, and the expansion context.
public struct AccessorMacroContext<Declaration, ExpansionContext>: AccessorMacroContextProtocol
where
Declaration: DeclSyntaxProtocol,
ExpansionContext: MacroExpansionContext
{
  
  /// The original macro attribute node that triggered this expansion.
  public var macroInvocationNode: AttributeSyntax
  
  /// The declaration to which the macro is attached.
  public var declaration: Declaration
  
  /// The context in which the macro is being expanded.
  public var expansionContext: ExpansionContext
  
  /// A string identifier for the diagnostic domain used for error reporting.
  public var diagnosticDomainIdentifier: String
  
  /// Creates a new accessor macro context with the specified components.
  ///
  /// - Parameters:
  ///   - macroInvocationNode: The attribute syntax node representing the macro invocation
  ///   - declaration: The declaration to which the macro is attached
  ///   - expansionContext: The context in which the macro is being expanded
  ///   - diagnosticDomainIdentifier: A string identifier for the diagnostic domain
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
