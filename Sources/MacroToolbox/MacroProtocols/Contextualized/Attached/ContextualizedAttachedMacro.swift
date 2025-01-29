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
 
  static func validateMacroInvocationName(
    _ macroInvocationName: String
  ) throws

  static func validateAttachedTypeName(
    _ attachedTypeName: String
  ) throws

  /// If overridden to be non-nil, the macro will report an error whenever the attached type doesn't match the regex.
  static var macroInvocationNameRegex: Regex<Substring>? { get }
  
  /// If overridden to be non-nil, the macro will report an error whenever the attached type doesn't match the regex.
  static var attachedTypeNameRegex: Regex<Substring>? { get }

  /// This method is a hook *solely* meant to give you a way to do finer-grained validation of macro's attachment site.
  ///
  /// The supplied default is a no-op.
  ///
  /// - note: 
  ///
  /// This method's validation is considered both (a) independent-of and also (b) subsequent-to the validation
  /// being done within ``validateDeclarationArchetype(in:)``; overriding this method will not
  /// impact that method's validation *and* there's no reason to call that method from this one.
  static func validateDeclarationDetails(
    for attachmentContext: some AttachedMacroContextProtocol
  ) throws

}

public enum ContextualizedAttachedMacroValidationError: Error {
  
  case macroInvocationNameMismatch(String)
  case attachedTypeNameMismatch(String)
  
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

  @inlinable
  public static func validateDeclarationDetails(
    for attachmentContext: some AttachedMacroContextProtocol
  ) throws {
    return // default: no validation!
  }
  
  @inlinable
  public static func validateMacroInvocationName(
    _ macroInvocationName: String
  ) throws {
    guard let macroInvocationNameRegex else {
      return
    }
    
    switch try macroInvocationNameRegex.wholeMatch(in: macroInvocationName) {
    case .some:
      return
    case .none:
      throw ContextualizedAttachedMacroValidationError.macroInvocationNameMismatch(
        """
        \(Self.self) invoked by \(macroInvocationName), which doesn't match the requirement \(macroInvocationNameRegex)!
        """
      )
    }
  }

  @inlinable
  public static func validateAttachedTypeName(
    _ attachedTypeName: String
  ) throws {
    guard let attachedTypeNameRegex else {
      return
    }
    
    switch try attachedTypeNameRegex.wholeMatch(in: attachedTypeName) {
    case .some:
      return
    case .none:
      throw ContextualizedAttachedMacroValidationError.attachedTypeNameMismatch(
        """
        \(Self.self) attached to type named \(attachedTypeName), which doesn't match the requirement \(attachedTypeNameRegex)!
        """
      )
    }
  }

  @inlinable
  public static var macroInvocationNameRegex: Regex<Substring>? { nil }
  
  @inlinable
  public static var attachedTypeNameRegex: Regex<Substring>? { nil }

}
