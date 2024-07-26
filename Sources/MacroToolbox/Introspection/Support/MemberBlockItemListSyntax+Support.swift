import SwiftSyntax

extension MemberBlockItemListSyntax {
  
  /// Finds all declarations of type `type` satisfying `predicate`.
  ///
  /// - Parameters:
  ///   - type: The type of declaration you're tryign to find.
  ///   - predicate: The predicate declarations need to satisfy for inclusion in the result.
  /// - Returns: All declarations within `self` that are of type `type` and satisfy `predicate`.
  ///
  /// - seealso: ``MemberBlockItemListSyntax.allDeclarations(ofType:)``
  /// - seealso: ``MemberBlockItemListSyntax.predicateHoldsForAllDeclarations(ofType:predicate:)``
  ///
  /// - note: This exists as a convenient fusion of two independent filter steps (type-checking then applying `predicate`).
  ///
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
  
  /// `true` iff all declarations of type `type` within `self` satisfy `predicate`.
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
  
  /// Returns all declarations from `self` that're of type `type`.
  @inlinable
  public func allDeclarations<T>(
    ofType type: T.Type
  ) -> some Collection<T> where T: DeclSyntaxProtocol {
    lazy.compactMap { candidate in
      candidate.decl.as(type)
    }
  }
  
}
