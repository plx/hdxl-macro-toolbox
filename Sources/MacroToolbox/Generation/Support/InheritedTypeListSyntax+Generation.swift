import SwiftSyntax

extension InheritedTypeListSyntax {
  
  public static func forTypeNames(_ typeNames: some Sequence<String>) -> Self {
    Self(
      withTrailingCommasInsertedBetween: typeNames.map { typeName in
        InheritedTypeSyntax(
          type: IdentifierTypeSyntax.forType(
            named: typeName
          )
        )
      }
    )
  }
  
}
