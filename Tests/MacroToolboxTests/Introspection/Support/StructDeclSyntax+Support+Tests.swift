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
func testStructDeclSyntaxSimpleGenericParameterNames() throws {
  // Helper function to create StructDeclSyntax from source code
  func makeStructDecl(_ source: String) throws -> StructDeclSyntax {
    let parsed = Parser.parse(source: source)
    let statement = try #require(parsed.statements.first?.item)
    let structDecl = try #require(statement.as(DeclSyntax.self))
    return try #require(structDecl.as(StructDeclSyntax.self))
  }
  
  // Test struct with single generic parameter
  let singleGenericStruct = try makeStructDecl("struct Example<T> {}")
  #expect(["T"] == singleGenericStruct.simpleGenericParameterNames)
  
  // Test struct with multiple generic parameters
  let multipleGenericStruct = try makeStructDecl("struct Example<K, V> {}")
  #expect(["K", "V"] == multipleGenericStruct.simpleGenericParameterNames)
  
  // Test struct with no generic parameters
  let noGenericStruct = try makeStructDecl("struct Example {}")
  #expect(nil == noGenericStruct.simpleGenericParameterNames)
  
  // Test struct with complex generic parameters (including constraints)
  let complexGenericStruct = try makeStructDecl("struct Example<T: Comparable, U> where T: Hashable {}")
  #expect(["T", "U"] == complexGenericStruct.simpleGenericParameterNames)
}