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
func testAttributeSyntaxFunctionality() {
  // Use parsing to create the attributes since direct construction is version-sensitive
  let inlinableSource = "@inlinable func test() {}"
  let inlinableDecl = Parser.parse(source: inlinableSource).statements.first!.item.as(DeclSyntax.self)!
  let funcDecl = inlinableDecl.as(FunctionDeclSyntax.self)!
  let inlinableAttr = funcDecl.attributes.first!.as(AttributeSyntax.self)!
  
  // Test hasName
  #expect(inlinableAttr.hasName("inlinable") == true)
  #expect(inlinableAttr.hasName("available") == false)
  
  // Test hasNoArguments
  #expect(inlinableAttr.hasNoArguments == true)
  
  // Test inlinabilityDisposition
  #expect(inlinableAttr.inlinabilityDisposition == InlinabilityDisposition.inlinable)
  
  // Create attribute with arguments
  let availableSource = "@available(iOS 13.0, *) func test() {}"
  let availableDecl = Parser.parse(source: availableSource).statements.first!.item.as(DeclSyntax.self)!
  let availableFuncDecl = availableDecl.as(FunctionDeclSyntax.self)!
  let availableAttr = availableFuncDecl.attributes.first!.as(AttributeSyntax.self)!
  
  // Test hasNoArguments for attribute with arguments
  #expect(availableAttr.hasNoArguments == false)
  
  // Test argumentListAsLabeledExprList
  #expect(availableAttr.argumentListAsLabeledExprList != nil)
  
  // Test inlinabilityDisposition for non-inlinable attribute
  #expect(availableAttr.inlinabilityDisposition == nil)
  
  // Test hasAtSign
  #expect(inlinableAttr.hasAtSign == true)
}