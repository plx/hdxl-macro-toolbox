import SwiftSyntax

extension MemberBlockSyntax {
  
  /// Finds all declarations of type `type` satisfying `predicate` within `self`'s members.
  ///
  /// - Parameters:
  ///   - type: The type of declaration you're tryign to find.
  ///   - predicate: The predicate declarations need to satisfy for inclusion in the result.
  /// - Returns: All declarations within `self`'s members that are of type `type` and satisfy `predicate`.
  ///
  /// - seealso: ``MemberBlockItemListSyntax.allSatisfactoryDeclarations(ofType:predicate:)``
  ///
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
  
  /// `true` iff all declarations of type `type` satisfying `predicate` within `self`'s members.
  ///
  /// - Parameters:
  ///   - type: The type of declaration you're tryign to find.
  ///   - predicate: The predicate declarations need to satisfy for inclusion in the result.
  /// - Returns: `true` iff all declarations of `type`  within `self`'s members satisfy `predicate`.
  ///
  /// - seealso: ``MemberBlockItemListSyntax.predicateHoldsForAllDeclarations(ofType:_:)``
  ///
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
  
  /// Finds all declarations of type `type` within `self`'s members.
  ///
  /// - Parameters:
  ///   - type: The type of declaration you're tryign to find.
  ///   - predicate: The predicate declarations need to satisfy for inclusion in the result.
  /// - Returns: All declarations within `self`'s members that are of type `type` and satisfy `predicate`.
  ///
  /// - seealso: ``MemberBlockItemListSyntax.allDeclarations(ofType:)``
  ///
  @inlinable
  public func allDeclarations<T>(
    ofType type: T.Type
  ) -> some Collection<T> where T: DeclSyntaxProtocol {
    members.allDeclarations(
      ofType: type
    )
  }
  
  @inlinable
  public var storedPropertyDescriptors: [StoredPropertyDescriptor] {
    members.compactMap { member in
      StoredPropertyDescriptor(decl: member.decl)
    }
  }

  @inlinable
  public func allStoredPropertyDescriptors(
    where predicate: (StoredPropertyDescriptor) throws -> Bool
  ) rethrows -> [StoredPropertyDescriptor] {
    var result: [StoredPropertyDescriptor] = []
    for member in members {
      guard
        let descriptor = StoredPropertyDescriptor(decl: member.decl),
        try predicate(descriptor)
      else {
        continue
      }
      
      result.append(descriptor)
    }
    
    return result
  }

}
