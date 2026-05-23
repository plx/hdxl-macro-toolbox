import SwiftSyntax

extension MemberBlockSyntax {
  
  @inlinable
  public init(declarations: some Sequence<some DeclSyntaxProtocol>) {
    self.init(
      leftBrace: .leftBraceToken(leadingTrivia: .space),
      members: MemberBlockItemListSyntax(
        declarations.map { declaration in
          MemberBlockItemSyntax(decl: declaration)
        }
      )
    )
  }
  
}
