import SwiftSyntax
import SwiftSyntaxMacros


public protocol SingleProtocolUnconditionalConformanceMacro: UnconditionalConformanceMacro, ContextualizedExtensionMacro, DiagnosticDomainAwareMacro {
  
  static var associatedProtocol: String { get }

  static func unconditionalExtension(
    in attachmentContext: some ExtensionMacroContextProtocol
  ) throws -> ExtensionDeclSyntax

}

extension SingleProtocolUnconditionalConformanceMacro {
    
  public static var conformedProtocolNames: [String] { [associatedProtocol]  }
 
  public static func unconditionalExtension(
    in attachmentContext: some ExtensionMacroContextProtocol
  ) throws -> ExtensionDeclSyntax {
    ExtensionDeclSyntax(
      extendedType: attachmentContext.extendedType,
      inheritanceClause: try unconditionalInheritanceClause(
        in: attachmentContext
      ),
      memberBlock: MemberBlockSyntax(
        declarations: try conditionalConformanceDeclarations(
          in: attachmentContext
        )
      )
    )
  }
  
  public static func unconditionalExtensions(
    in attachmentContext: some ExtensionMacroContextProtocol
  ) throws -> [ExtensionDeclSyntax] {
    [
      try unconditionalExtension(
        in: attachmentContext
      )
    ]
  }

}
