import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

/// Protocol for adoption by "pure-marker" macros (e.g. macros that just tag a declaration w/metadata, but don't actually expand into anything useful).
public protocol MarkerMacroProtocol: DiagnosticDomainAwareMacro, ContextualizedPeerMacro {
  
}

extension MarkerMacroProtocol {
  
  @inlinable
  public static func contextualizedExpansion(
    in attachmentContext: some PeerMacroContextProtocol
  ) throws -> [DeclSyntax] {
    return []
  }
  
}
