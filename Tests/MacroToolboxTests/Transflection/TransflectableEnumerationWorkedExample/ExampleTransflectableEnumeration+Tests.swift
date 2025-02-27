import Testing
import SwiftSyntax
import SwiftParser
import SwiftSyntaxBuilder
import MacroTransflection
import MacroToolboxTestSupport
@testable import MacroToolbox

@Test(
  "Verify fake-attribute parses ok.",
  .tags(
    .attributeSyntax,
    .transflection,
    .enumerationTransflections
  )
)
func testFakeAttributeForTransflectionTestingParsesOk() throws {
  let syntax = try AttributeSyntax(
    "@FakeAttribute(.transmogrify, .frobulate, .transmogrifyAndFrobulate)"
  ).validated()
  
  let argumentList = try #require(syntax.argumentListAsLabeledExprList)
  try #require(argumentList.count == 3)
  
  let name = "\(syntax.attributeName.trimmed)"
  #expect(name == "FakeAttribute")
}

@Test(
  "Verify we can transflect source-code-symbol-transflectable arguments.",
  .tags(
    .attributeSyntax,
    .transflection,
    .enumerationTransflections
  )
)
func testWeCanReflectSourceCodesymbolTransflectableArguments() throws {
  let syntax = try AttributeSyntax(
    "@FakeAttribute(.transmogrify, .frobulate, .transmogrifyAndFrobulate)"
  ).validated()
  
  let argumentList = Array(try #require(syntax.argumentListAsLabeledExprList))
  try #require(argumentList.count == 3)
  
  let name = "\(syntax.attributeName.trimmed)"
  #expect(name == "FakeAttribute")
  
  let transmogrify = try ExampleTransflectableEnumeration(
    transflectingExprSyntax: argumentList[0].expression
  )
  
  let frobulate = try ExampleTransflectableEnumeration(
    transflectingExprSyntax: argumentList[1].expression
  )
  
  let transmogrifyAndFrobulate = try ExampleTransflectableEnumeration(
    transflectingExprSyntax: argumentList[2].expression
  )
  
  #expect(transmogrify == .transmogrify)
  #expect(frobulate == .frobulate)
  #expect(transmogrifyAndFrobulate == .transmogrifyAndFrobulate)
}

