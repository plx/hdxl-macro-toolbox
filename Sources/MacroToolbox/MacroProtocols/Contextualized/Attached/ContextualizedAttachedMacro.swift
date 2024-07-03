import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


/// ``ContextualizedAttachedMacro`` is an abstract protocol for attached macros that use attachment-contexts for expansion.
///
/// With a richer type system, much of this system's functionality could be included here...but, as it is, this is somewhere between
/// a marker protocol and a place to attach some useful method stubs.
///
public protocol ContextualizedAttachedMacro: AttachedMacro, DiagnosticDomainAwareMacro {
  
  /// You can use this property to configure some *very basic* attachment-site checking (e.g. "am I attached to (one of) the right kind(s) of declarations)?
  static var attachmentRequirement: MacroAttachmentRequirement<DeclarationArchetype> { get }

  /// This method is a hook *solely* meant to give you a way to validate to site to-which you're attached.
  ///
  /// The supplied default evaluates `attachmentRequirement` against the `attachmentContext`'s declaration archetype.
  static func validateDeclarationArchetype(
    for attachmentContext: some AttachedMacroContextProtocol
  ) throws

  /// This method is a hook *solely* meant to validate your macro-invocation node itself (e.g. "do we have the expected arguments?").
  ///
  /// The supplied default does no validation—you only need to supply this if you're doing actual validation.
  static func validateMacroInvocationNode(
    _ attributeSyntax: AttributeSyntax
  ) throws
  
}

extension ContextualizedAttachedMacro {
  
  @inlinable
  public static var attachmentRequirement: MacroAttachmentRequirement<DeclarationArchetype> { .unspecified }
  
  /// This has the actual logic for validating `attachmentContext` against `attachmentRequirement`.
  ///
  /// This is here so that *if* you override `validateDeclarationArchetype` *then* you can still call this method, too.
  @inlinable
  public static func validateDeclarationArchetypeAgainstAttachmentRequirement(
    attachmentContext: some AttachedMacroContextProtocol,
    attachmentRequirement: MacroAttachmentRequirement<DeclarationArchetype>
  ) throws {
    try attachmentContext.requireSatisfactoryAttachment(
      attachmentRequirement: attachmentRequirement
    )
  }

  @inlinable
  public static func validateDeclarationArchetype(
    for attachmentContext: some AttachedMacroContextProtocol
  ) throws {
    try validateDeclarationArchetypeAgainstAttachmentRequirement(
      attachmentContext: attachmentContext,
      attachmentRequirement: attachmentRequirement
    )
  }

  @inlinable
  public static func validateMacroInvocationNode(
    _ attributeSyntax: AttributeSyntax
  ) throws {
    return // default: allow everything
  }

}
