import SwiftSyntax
import SwiftSyntaxMacros


/// ``MemberAttributeMacroContextProtocol`` refines``AttachedMacroContextProtocol`` and specializes it for member-attribute macros.
public protocol MemberAttributeMacroContextProtocol<Declaration, ExpansionContext, Member> : AttachedMacroContextProtocol
where Declaration: DeclGroupSyntax {
  associatedtype Member: DeclSyntaxProtocol
  
  var member: Member { get }
}
