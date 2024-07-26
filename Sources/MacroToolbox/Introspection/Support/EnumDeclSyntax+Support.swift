import SwiftSyntax

extension EnumDeclSyntax {
  
  @inlinable
  public var simpleGenericParameterNames: [String]? {
    genericParameterClause?.simpleGenericParameterNames
  }
  
  /// `true` iff all of our case-declarations satisfy `predicate`.
  @inlinable
  public func allCaseDeclarationsSatisfy(
    _ predicate: (EnumCaseDeclSyntax) throws -> Bool
  ) rethrows -> Bool {
    try memberBlock.predicateHoldsForAllDeclarations(
      ofType: EnumCaseDeclSyntax.self,
      predicate
    )
  }
  
  /// `true` iff all of our cases are simple and payload-free.
  @inlinable
  public var allCasesAreSimpleWithoutPayload: Bool {
    allCaseDeclarationsSatisfy(\.isSimpleCaseWithoutPayload)
  }
  
  /// Returns all case-declarations satisfying `predicate`.
  @inlinable
  public func allCaseDeclarationsSatisfying(
    _ predicate: (EnumCaseDeclSyntax) throws -> Bool
  ) rethrows -> some Collection<EnumCaseDeclSyntax> {
    try memberBlock.allSatisfactoryDeclarations(
      ofType: EnumCaseDeclSyntax.self,
      where: predicate
    )
  }
  
}

