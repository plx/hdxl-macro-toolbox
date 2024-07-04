import Testing
import SwiftSyntax
import SwiftParser
import SwiftSyntaxBuilder
import MacroToolbox
import MacroTransflection
import MacroTransflectionMacroSupport

@Test("Verify fake-attribute parses ok.")
func testFakeAttributeForTransflectionTestingParsesOk() throws {
  let syntax = try AttributeSyntax(
    "@FakeAttribute(.transmogrify, .frobulate, .transmogrifyAndFrobulate)"
  ).validated()
  
  let argumentList = try #require(syntax.argumentList)
  try #require(argumentList.count == 3)
  
  let name = "\(syntax.attributeName.trimmed)"
  #expect(name == "FakeAttribute")
}

@Test("Verify we can transflect source-code-symbol-transflectable arguments.")
func testWeCanReflectSourceCodesymbolTransflectableArguments() throws {
  let syntax = try AttributeSyntax(
    "@FakeAttribute(.transmogrify, .frobulate, .transmogrifyAndFrobulate)"
  ).validated()
  
  let argumentList = Array(try #require(syntax.argumentList))
  try #require(argumentList.count == 3)
  
  let name = "\(syntax.attributeName.trimmed)"
  #expect(name == "FakeAttribute")
  
  let transmogrify = try ExampleTransflectableEnumeration(
    exprSyntax: argumentList[0].expression
  )
  
  let frobulate = try ExampleTransflectableEnumeration(
    exprSyntax: argumentList[1].expression
  )
  
  let transmogrifyAndFrobulate = try ExampleTransflectableEnumeration(
    exprSyntax: argumentList[2].expression
  )
  
  #expect(transmogrify == .transmogrify)
  #expect(frobulate == .frobulate)
  #expect(transmogrifyAndFrobulate == .transmogrifyAndFrobulate)
}

