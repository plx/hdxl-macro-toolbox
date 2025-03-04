import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

/// A protocol for accessor macros that use contextual information during expansion.
///
/// This protocol builds on the standard `AccessorMacro` protocol to provide a more
/// structured approach to macro expansion with built-in validation and contextualized
/// information about the declaration being processed.
public protocol ContextualizedAccessorMacro: AccessorMacro, ContextualizedAttachedMacro, DiagnosticDomainAwareMacro {
  
  /// Performs additional validation of the expansion context before proceeding with expansion.
  ///
  /// This method is called after the standard validation checks and provides an opportunity
  /// to perform macro-specific validation before expansion.
  ///
  /// - Parameter expansionContext: The context in which the macro is being expanded
  /// - Throws: If the expansion context does not meet the macro's requirements
  static func validateExpansionContext(
    _ expansionContext: some AccessorMacroContextProtocol
  ) throws

  /// Performs the actual macro expansion with access to the full context.
  ///
  /// This is the main implementation point for conforming types, where the macro's
  /// expansion logic should be implemented.
  ///
  /// - Parameter attachmentContext: The context containing information about the macro invocation
  /// - Returns: An array of accessor declarations to be added to the target property
  /// - Throws: If the expansion fails for any reason
  static func contextualizedExpansion(
    in attachmentContext: some AccessorMacroContextProtocol
  ) throws -> [AccessorDeclSyntax]
  
}

extension ContextualizedAccessorMacro {

  @inlinable
  public static func validateExpansionContext(
    _ expansionContext: some AccessorMacroContextProtocol
  ) throws {
    return // default: do nothing
  }

  @inlinable
  package static func withValidatedAttachmentContext<R, Declaration, ExpansionContext>(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: Declaration,
    in context: ExpansionContext,
    _ closure: (AccessorMacroContext<Declaration, ExpansionContext>) throws -> R
  ) throws -> R {
    let attachmentContext = AccessorMacroContext(
      macroInvocationNode: node,
      declaration: declaration,
      expansionContext: context,
      diagnosticDomainIdentifier: diagnosticDomainIdentifier
    )
    
    try validateMacroInvocationNode(node)
    try validateDeclarationArchetype(for: attachmentContext)
    try validateDeclarationDetails(for: attachmentContext)
    try validateExpansionContext(attachmentContext)

    return try closure(attachmentContext)
  }

  /// Implements the standard `AccessorMacro` expansion method using the contextualized approach.
  ///
  /// This method serves as the bridge between Swift's standard macro expansion system and
  /// the contextualized approach provided by this protocol. It handles creating the appropriate
  /// context, performing validation, and calling the `contextualizedExpansion` method.
  ///
  /// - Parameters:
  ///   - node: The attribute syntax representing the macro invocation
  ///   - declaration: The declaration to which the macro is attached
  ///   - context: The macro expansion context
  /// - Returns: An array of accessor declarations to be added to the target property
  /// - Throws: If validation or expansion fails
  public static func expansion(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AccessorDeclSyntax] {
    try withAutomaticReformatting {
      try withValidatedAttachmentContext(
        of: node,
        providingAccessorsOf: declaration,
        in: context
      ) { expansionContext in
        try contextualizedExpansion(in: expansionContext)
      }
    }
  }
  
}
