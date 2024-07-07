import SwiftSyntax

extension MemberBlockSyntax {
  
  @inlinable
  public func allSatisfactoryDeclarations<T>(
    ofType type: T.Type,
    where predicate: (T) throws -> Bool
  ) rethrows -> [T] where T: DeclSyntaxProtocol {
    try members.allSatisfactoryDeclarations(
      ofType: type,
      where: predicate
    )
  }
  
  @inlinable
  public func predicateHoldsForAllDeclarations<T>(
    ofType type: T.Type,
    _ predicate: (T) throws -> Bool
  ) rethrows -> Bool where T: DeclSyntaxProtocol {
    try members.predicateHoldsForAllDeclarations(
      ofType: type,
      predicate
    )
  }
  
  @inlinable
  public func allDeclarations<T>(
    ofType type: T.Type
  ) -> some Collection<T> where T: DeclSyntaxProtocol {
    members.allDeclarations(
      ofType: type
    )
  }
  
}
