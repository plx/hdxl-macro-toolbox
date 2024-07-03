import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


/// Convenience that refines ``ContextualizedTypeAttachedMacro`` and defaults to being compatible with everything but protocol declarations.
///
/// - note: This exists due to how often this requirement crops up in practice; for similar reasons, it *may eventually* make sense to introduce "exclusive" protocols for struct, class, enum, and so on.
public protocol ProtocolIncompatibleContextualizedTypeAttachedMacro : ContextualizedTypeAttachedMacro {
}

extension ProtocolIncompatibleContextualizedTypeAttachedMacro {
  
  @inlinable
  public static var typeAttachmentRequirement: MacroAttachmentRequirement<TypeDeclarationArchetype> {
    .anythingBut([.protocol])
  }
    
}
