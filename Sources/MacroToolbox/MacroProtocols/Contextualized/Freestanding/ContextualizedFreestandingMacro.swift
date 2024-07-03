import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


public protocol ContextualizedFreestandingMacro: FreestandingMacro, DiagnosticDomainAwareMacro {

  static func validateMacroInvocationNode(
    _ freestandingMacroExpansion: some FreestandingMacroExpansionSyntax
  ) throws

}

extension ContextualizedFreestandingMacro {
  
  @inlinable
  public static func validateMacroInvocationNode(
    _ freestandingMacroExpansion: some FreestandingMacroExpansionSyntax
  ) throws {
    return // default: everything allowed
  }

}
