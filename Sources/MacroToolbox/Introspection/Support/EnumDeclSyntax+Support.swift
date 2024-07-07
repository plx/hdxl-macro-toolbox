import SwiftSyntax

extension EnumDeclSyntax {
  
  @inlinable
  public var simpleGenericParameterNames: [String]? {
    genericParameterClause?.simpleGenericParameterNames
  }
  
  @inlinable
  public func allCaseDeclarationsSatisfy(
    _ predicate: (EnumCaseDeclSyntax) throws -> Bool
  ) rethrows -> Bool {
    try memberBlock.predicateHoldsForAllDeclarations(
      ofType: EnumCaseDeclSyntax.self,
      predicate
    )
  }
  
  @inlinable
  public var allCasesAreSimpleWithoutPayload: Bool {
    allCaseDeclarationsSatisfy(\.isSimpleCaseWithoutPayload)
  }
  
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

