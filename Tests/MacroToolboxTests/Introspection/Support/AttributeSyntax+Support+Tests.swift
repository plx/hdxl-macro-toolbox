import Testing
import SwiftSyntax
import SwiftParser
import MacroToolboxTestSupport
@testable import MacroToolbox

@Test(
  "`AttributeSyntax` functionality",
  .tags(
    .syntaxIntrospection,
    .attributeSyntax
  )
)
func testAttributeSyntaxFunctionality() throws {
  // Use parsing to create the attributes since direct construction is version-sensitive
  let inlinableSource = "@inlinable func test() {}"
  let sourceFile = Parser.parse(source: inlinableSource)
  let statement = try #require(sourceFile.statements.first?.item)
  let inlinableDecl = try #require(statement.as(DeclSyntax.self))
  let funcDecl = try #require(inlinableDecl.as(FunctionDeclSyntax.self))
  let attribute = try #require(funcDecl.attributes.first)
  let inlinableAttr = try #require(attribute.as(AttributeSyntax.self))
  
  // Test hasName
  #expect(inlinableAttr.hasName("inlinable") == true)
  #expect(inlinableAttr.hasName("available") == false)
  
  // Test hasNoArguments
  #expect(inlinableAttr.hasNoArguments == true)
  
  // Test inlinabilityDisposition
  #expect(inlinableAttr.inlinabilityDisposition == InlinabilityDisposition.inlinable)
  
  // Create attribute with proper arguments format - using a different attribute format
  let macroSource = "@CustomStringConvertible(arg1: 123, arg2: \"test\") func test() {}"
  let macroSourceFile = Parser.parse(source: macroSource)
  let macroStatement = try #require(macroSourceFile.statements.first?.item)
  let macroDecl = try #require(macroStatement.as(DeclSyntax.self))
  let macroFuncDecl = try #require(macroDecl.as(FunctionDeclSyntax.self))
  let macroAttribute = try #require(macroFuncDecl.attributes.first)
  let macroAttr = try #require(macroAttribute.as(AttributeSyntax.self))
  
  // Test hasNoArguments for attribute with arguments
  #expect(macroAttr.hasNoArguments == false)
  
  // Test argumentListAsLabeledExprList - validate we can get the argument list
  if let argList = macroAttr.argumentListAsLabeledExprList {
    #expect(argList.count >= 1)
  } else {
    #expect(Bool(false), "argumentListAsLabeledExprList should not be nil")
  }
  
  // Test inlinabilityDisposition for non-inlinable attribute
  #expect(macroAttr.inlinabilityDisposition == nil)
  
  // Test hasAtSign
  #expect(inlinableAttr.hasAtSign == true)
}
