import SwiftSyntax
import SwiftSyntaxMacros


/// ``MemberAttributeMacroContextProtocol`` refines``AttachedMacroContextProtocol`` and specializes it for member-attribute macros.
public protocol MemberAttributeMacroContextProtocol<Declaration, ExpansionContext, Member> : AttachedMacroContextProtocol
where Declaration: DeclGroupSyntax {
  associatedtype Member: DeclSyntaxProtocol
  
  var member: Member { get }
}

extension MemberAttributeMacroContextProtocol {
  
  @inlinable
  public func requireMemberAsConcreteDeclSyntax(
    messageIdentifier: @autoclosure () -> String = .declarationOfIncorrectType,
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> ConcreteDeclSyntax {
    try requireValue(
      "Need to be attached to a concrete declaration.",
      messageIdentifier: messageIdentifier(),
      function: function,
      fileID: fileID,
      line: line,
      column: column
    ) {
      ConcreteDeclSyntax(decl: member)
    }
  }

  @inlinable
  public func requireMemberAsConcreteTypeDeclaration(
    messageIdentifier: @autoclosure () -> String = .declarationOfIncorrectType,
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> ConcreteTypeDeclaration {
    try requireValue(
      "Need to be attached to a concrete type.",
      messageIdentifier: messageIdentifier(),
      function: function,
      fileID: fileID,
      line: line,
      column: column
    ) {
      ConcreteTypeDeclaration(decl: member)
    }
  }

}
