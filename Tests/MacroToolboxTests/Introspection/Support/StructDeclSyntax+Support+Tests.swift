import Testing
import SwiftSyntax
import SwiftParser
import MacroToolboxTestSupport
@testable import MacroToolbox


@Test(
  "`StructDeclSyntax.simpleGenericParameterNames`",
  .tags(
    .syntaxIntrospection,
    .structDeclSyntax
  )
)
func testStructDeclSyntaxSimpleGenericParameterNames() {
  // Helper function to create StructDeclSyntax from source code
  func makeStructDecl(_ source: String) -> StructDeclSyntax {
    let parsed = Parser.parse(source: source)
    let structDecl = parsed.statements.first!.item.as(DeclSyntax.self)!
    return structDecl.as(StructDeclSyntax.self)!
  }
  
  // Test struct with single generic parameter
  #expect(
    ["T"]
    ==
    makeStructDecl("struct Example<T> {}").simpleGenericParameterNames
  )
  
  // Test struct with multiple generic parameters
  #expect(
    ["K", "V"]
    ==
    makeStructDecl("struct Example<K, V> {}").simpleGenericParameterNames
  )
  
  // Test struct with no generic parameters
  #expect(
    nil
    ==
    makeStructDecl("struct Example {}").simpleGenericParameterNames
  )
  
  // Test struct with complex generic parameters (including constraints)
  #expect(
    ["T", "U"]
    ==
    makeStructDecl("struct Example<T: Comparable, U> where T: Hashable {}").simpleGenericParameterNames
  )
}