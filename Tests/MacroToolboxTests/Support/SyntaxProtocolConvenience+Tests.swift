import SwiftSyntax
import Testing
@testable import MacroToolbox

@Test("Generated syntax-element cast conveniences")
func testGeneratedSyntaxElementCastConveniences() throws {
  // Hand-written example: a struct declaration gives one known-positive cast
  // and one known-negative cast, pinning the intended spelling and semantics
  // for the generated `as*`/`is*` conveniences.
  let structDecl = try StructDeclSyntax.onlyParsed(
    from: "public struct Widget { var count: Int }"
  )
  let syntax = Syntax(structDecl)
  
  #expect(syntax.isStructDeclSyntax)
  #expect(!syntax.isEnumDeclSyntax)
  #expect(syntax.asStructDeclSyntax?.name.text == "Widget")
  #expect(syntax.asSyntaxElement(StructDeclSyntax.self)?.name.text == "Widget")
  #expect(syntax.isSyntaxElement(StructDeclSyntax.self))
}

@Test("Syntax tree search conveniences")
func testSyntaxTreeSearchConveniences() throws {
  // Hand-written example: the first-match helper should find the stored
  // property we can name directly, while the all-match helper should preserve
  // enough traversal coverage to find a token nested inside the declaration.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: "public struct Widget { var count: Int }"
  )
  
  let storedProperty = sourceFile.firstSyntaxElement(
    ofType: VariableDeclSyntax.self
  )
  
  #expect(storedProperty?.variableNameIfStoredProperty == "count")
  #expect(
    sourceFile
      .allSyntaxElements(ofType: TokenSyntax.self)
      .contains { $0.text == "Widget" }
  )
}

@Test("Syntax tree search conveniences agree with all-match traversal")
func testSyntaxTreeSearchConveniencesAgreeWithAllMatchTraversal() throws {
  // Property-style test: for several parsed programs and syntax categories,
  // `firstSyntaxElement` must be exactly the first element returned by
  // `allSyntaxElements`, and every all-match result must have the requested
  // type according to SwiftSyntax's generic cast.
  let sourceFiles = try [
    "struct Widget { var count: Int }",
    "enum Choice { case first(Int), second }",
    "func value() -> Int { return 1 }"
  ].map {
    try SourceFileSyntax.onlyParsed(from: $0)
  }
  
  for sourceFile in sourceFiles {
    assertTreeSearchProperty(sourceFile, StructDeclSyntax.self)
    assertTreeSearchProperty(sourceFile, EnumDeclSyntax.self)
    assertTreeSearchProperty(sourceFile, FunctionDeclSyntax.self)
    assertTreeSearchProperty(sourceFile, VariableDeclSyntax.self)
    assertTreeSearchProperty(sourceFile, IdentifierTypeSyntax.self)
    assertTreeSearchProperty(sourceFile, TokenSyntax.self)
  }
}

@Test("Source parsing conveniences cover major syntax categories")
func testSourceParsingConveniencesCoverMajorSyntaxCategories() throws {
  // Hand-written examples: the parser conveniences are intentionally broad,
  // so this pins one representative syntax node from each major SwiftSyntax
  // category the type-erasure helpers also support.
  let declaration = try StructDeclSyntax.onlyParsed(from: "struct Example {}")
  let expression = try BooleanLiteralExprSyntax.firstParsed(from: "let flag = true")
  let pattern = try IdentifierPatternSyntax.firstParsed(from: "let value = 1")
  let statement = try ReturnStmtSyntax.firstParsed(
    from: "func value() -> Int { return 1 }"
  )
  let type = try IdentifierTypeSyntax.firstParsed(from: "let value: Int = 1")
  
  #expect(declaration.name.text == "Example")
  #expect(expression.representedBooleanLiteralValue == true)
  #expect(pattern.identifier.text == "value")
  #expect(statement.returnKeyword.text == "return")
  #expect(type.name.text == "Int")
}

@Test("Source parsing conveniences expose successful and failing parse properties")
func testSourceParsingConveniencesExposeSuccessfulAndFailingParseProperties() throws {
  // Property-style test: for each representative source/type pair, all four
  // parsing entry points must agree on the same syntax text; for failure cases,
  // the helpers must report `MacroExpansionFailure` instead of silently
  // returning an unrelated node.
  try assertSourceParsingProperty(
    "declaration",
    source: "struct Example {}",
    validate: { source in
      let first = try StructDeclSyntax.firstParsed(from: source)
      let firstFromInitializer = try StructDeclSyntax(firstParsedFrom: source)
      let only = try StructDeclSyntax.onlyParsed(from: source)
      let onlyFromInitializer = try StructDeclSyntax(onlyParsedFrom: source)
      
      #expect(first.description == firstFromInitializer.description)
      #expect(first.description == only.description)
      #expect(only.description == onlyFromInitializer.description)
    }
  )
  
  try assertSourceParsingProperty(
    "expression",
    source: "let flag = true",
    validate: { source in
      let first = try BooleanLiteralExprSyntax.firstParsed(from: source)
      let firstFromInitializer = try BooleanLiteralExprSyntax(firstParsedFrom: source)
      let only = try BooleanLiteralExprSyntax.onlyParsed(from: source)
      let onlyFromInitializer = try BooleanLiteralExprSyntax(onlyParsedFrom: source)
      
      #expect(first.description == firstFromInitializer.description)
      #expect(first.description == only.description)
      #expect(only.description == onlyFromInitializer.description)
    }
  )
  
  try assertSourceParsingProperty(
    "pattern",
    source: "let value = 1",
    validate: { source in
      let first = try IdentifierPatternSyntax.firstParsed(from: source)
      let firstFromInitializer = try IdentifierPatternSyntax(firstParsedFrom: source)
      let only = try IdentifierPatternSyntax.onlyParsed(from: source)
      let onlyFromInitializer = try IdentifierPatternSyntax(onlyParsedFrom: source)
      
      #expect(first.description == firstFromInitializer.description)
      #expect(first.description == only.description)
      #expect(only.description == onlyFromInitializer.description)
    }
  )
  
  try assertSourceParsingProperty(
    "statement",
    source: "func value() -> Int { return 1 }",
    validate: { source in
      let first = try ReturnStmtSyntax.firstParsed(from: source)
      let firstFromInitializer = try ReturnStmtSyntax(firstParsedFrom: source)
      let only = try ReturnStmtSyntax.onlyParsed(from: source)
      let onlyFromInitializer = try ReturnStmtSyntax(onlyParsedFrom: source)
      
      #expect(first.description == firstFromInitializer.description)
      #expect(first.description == only.description)
      #expect(only.description == onlyFromInitializer.description)
    }
  )
  
  try assertSourceParsingProperty(
    "type",
    source: "let value: Int = 1",
    validate: { source in
      let first = try IdentifierTypeSyntax.firstParsed(from: source)
      let firstFromInitializer = try IdentifierTypeSyntax(firstParsedFrom: source)
      let only = try IdentifierTypeSyntax.onlyParsed(from: source)
      let onlyFromInitializer = try IdentifierTypeSyntax(onlyParsedFrom: source)
      
      #expect(first.description == firstFromInitializer.description)
      #expect(first.description == only.description)
      #expect(only.description == onlyFromInitializer.description)
    }
  )
  
  expectMacroExpansionFailure {
    _ = try EnumDeclSyntax.firstParsed(from: "struct Example {}")
  }
  
  expectMacroExpansionFailure {
    _ = try VariableDeclSyntax.onlyParsed(
      from: """
      let first = 1
      let second = 2
      """
    )
  }
}

@Test("Syntax type-erasure conveniences cover major syntax categories")
func testSyntaxTypeErasureConveniencesCoverMajorSyntaxCategories() throws {
  // Hand-written examples: each major syntax protocol family gets erased to
  // its matching wrapper and then validated, proving the convenience names map
  // to the intended SwiftSyntax erasure type.
  let declaration = try StructDeclSyntax.onlyParsed(from: "struct Example {}")
  let expression = try BooleanLiteralExprSyntax.firstParsed(from: "let flag = true")
  let pattern = try IdentifierPatternSyntax.firstParsed(from: "let value = 1")
  let statement = try ReturnStmtSyntax.firstParsed(
    from: "func value() -> Int { return 1 }"
  )
  let type = IdentifierTypeSyntax.forType(named: "Int")
  
  #expect(try declaration.eraseToValidatedDeclSyntax().asStructDeclSyntax != nil)
  #expect(try expression.eraseToValidatedExprSyntax().asBooleanLiteralExprSyntax != nil)
  #expect(try pattern.eraseToValidatedPatternSyntax().asIdentifierPatternSyntax != nil)
  #expect(try statement.eraseToValidatedStmtSyntax().asReturnStmtSyntax != nil)
  #expect(try type.eraseToValidatedTypeSyntax().asIdentifierTypeSyntax != nil)
  #expect(try type.eraseToValidatedSyntax().asIdentifierTypeSyntax != nil)
}

@Test("Syntax type-erasure conveniences preserve syntax text")
func testSyntaxTypeErasureConveniencesPreserveSyntaxText() throws {
  // Property-style test: across the major syntax protocol families, plain and
  // validating erasure must preserve the original syntax text. This catches
  // accidental cross-family erasure while checking more examples than the
  // focused hand-written test above.
  let declaration = try StructDeclSyntax.onlyParsed(from: "struct Example {}")
  let expression = try BooleanLiteralExprSyntax.firstParsed(from: "let flag = true")
  let pattern = try IdentifierPatternSyntax.firstParsed(from: "let value = 1")
  let statement = try ReturnStmtSyntax.firstParsed(
    from: "func value() -> Int { return 1 }"
  )
  let type = IdentifierTypeSyntax.forType(named: "Int")
  
  #expect(declaration.eraseToDeclSyntax().description == declaration.description)
  #expect(try declaration.eraseToValidatedDeclSyntax().description == declaration.description)
  
  #expect(expression.eraseToExprSyntax().description == expression.description)
  #expect(try expression.eraseToValidatedExprSyntax().description == expression.description)
  
  #expect(pattern.eraseToPatternSyntax().description == pattern.description)
  #expect(try pattern.eraseToValidatedPatternSyntax().description == pattern.description)
  
  #expect(statement.eraseToStmtSyntax().description == statement.description)
  #expect(try statement.eraseToValidatedStmtSyntax().description == statement.description)
  
  #expect(type.eraseToTypeSyntax().description == type.description)
  #expect(try type.eraseToValidatedTypeSyntax().description == type.description)
  #expect(type.eraseToSyntax().description == type.description)
  #expect(try type.eraseToValidatedSyntax().description == type.description)
}

private func assertTreeSearchProperty<T>(
  _ sourceFile: SourceFileSyntax,
  _ type: T.Type
) where T: SyntaxProtocol {
  let allMatches = sourceFile.allSyntaxElements(ofType: type)
  
  #expect(
    sourceFile.firstSyntaxElement(ofType: type)?.description
    ==
    allMatches.first?.description
  )
  #expect(allMatches.allSatisfy { Syntax($0).is(type) })
}

private func assertSourceParsingProperty(
  _ name: String,
  source: String,
  validate: (String) throws -> Void
) throws {
  _ = name
  try validate(source)
}

private func expectMacroExpansionFailure(
  _ operation: () throws -> Void
) {
  do {
    try operation()
    Issue.record("Expected MacroExpansionFailure")
  } catch {
    #expect(error is MacroExpansionFailure)
  }
}
