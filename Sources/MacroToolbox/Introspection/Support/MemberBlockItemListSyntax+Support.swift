import SwiftSyntax

extension MemberBlockItemListSyntax {
  
  @inlinable
  public func allSatisfactoryDeclarations<T>(
    ofType type: T.Type,
    where predicate: (T) throws -> Bool
  ) rethrows -> [T] where T: DeclSyntaxProtocol {
    var result: [T] = []
    for candidate in self {
      guard
        let declaration = candidate.decl.as(type),
        try predicate(declaration)
      else {
        continue
      }
      result.append(declaration)
    }
    
    return result
  }

  @inlinable
  public func predicateHoldsForAllDeclarations<T>(
    ofType type: T.Type,
    _ predicate: (T) throws -> Bool
  ) rethrows -> Bool where T: DeclSyntaxProtocol {
    for candidate in self {
      guard let declaration = candidate.decl.as(type) else {
        continue
      }
      
      guard try predicate(declaration) else {
        return false
      }
    }
    return true
  }
  
  @inlinable
  public func allDeclarations<T>(
    ofType type: T.Type
  ) -> some Collection<T> where T: DeclSyntaxProtocol {
    lazy.compactMap { candidate in
      candidate.decl.as(type)
    }
  }
}
