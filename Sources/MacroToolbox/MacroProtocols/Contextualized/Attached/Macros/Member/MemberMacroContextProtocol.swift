import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


/// ``MemberMacroContextProtocol`` refines``AttachedMacroContextProtocol`` and specializes it for member macros.
public protocol MemberMacroContextProtocol<Declaration, ExpansionContext> : AttachedMacroContextProtocol
where Declaration: DeclGroupSyntax {
  
  var conformedProtocols: [TypeSyntax] { get }
  
}

