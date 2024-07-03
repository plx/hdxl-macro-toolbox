import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


/// ``ContextualizedTypeAttachedMacro`` is a (thin) refinement of ``ContextualizedAttachedMacro`` specifically for macros that're *exclusively* attachable to types.
public protocol ContextualizedTypeAttachedMacro: ContextualizedAttachedMacro {

  /// This property exists to streamline the construction of `attachmentRequirement`.
  static var typeAttachmentRequirement: MacroAttachmentRequirement<TypeDeclarationArchetype> { get }
  
}

extension ContextualizedTypeAttachedMacro {
  
  @inlinable
  public static var typeAttachmentRequirement: MacroAttachmentRequirement<TypeDeclarationArchetype> { .unspecified }
  
  @inlinable
  public static var attachmentRequirement: MacroAttachmentRequirement<DeclarationArchetype> {
    typeAttachmentRequirement.equivalentDeclarationArchetypeRequirement
  }
    
}
