import SwiftBasicFormat
import SwiftSyntax
import SwiftSyntaxBuilder
import Testing
@testable import MacroToolbox

@Test("Stored property declarations render modifiers, attributes, and initializers")
func testStoredPropertyDeclarationsRenderModifiersAttributesAndInitializers() throws {
  // Hand-written examples: stored-property generation should include attributes,
  // isolation, public visibility, independent setter visibility, type, and initial
  // value in the emitted variable declaration.
  let property = StoredProperty(
    name: "value",
    typeName: "Int",
    visibility: .public,
    setterVisibility: .private,
    isolation: .nonisolated,
    attributes: ["@usableFromInline"],
    initialValueExpression: "42"
  )
  let syntax = try property.makeSyntaxRepresentation()
  
  #expect(property.visibilityDeclaration == "public")
  #expect(property.setterVisibilityDeclaration == "private(set)")
  #expect(property.isolationDeclaration == "nonisolated")
  #expect(property.modifierDeclaration == "nonisolated public private(set)")
  #expect(property.attributeDeclaration == "@usableFromInline")
  #expect(syntax.trimmedDescription == "@usableFromInline\nnonisolated public private(set) var value: Int = 42")
  #expect(try property.makeDeclSyntax().trimmedDescription == syntax.trimmedDescription)
}

@Test("Stored property declaration defaults omit optional syntax")
func testStoredPropertyDeclarationDefaultsOmitOptionalSyntax() throws {
  // Property-style test: independent combinations of visibility, setter
  // visibility, isolation, attributes, and initializers should render only the
  // pieces that are present.
  let samples: [(StoredProperty, [String], [String])] = [
    (
      StoredProperty(name: "plain", typeName: "String"),
      ["var plain: String"],
      ["nonisolated", "(set)", "="]
    ),
    (
      StoredProperty(name: "configured", typeName: "Bool", setterVisibility: .fileprivate),
      ["fileprivate(set) var configured: Bool"],
      ["public", "nonisolated", "="]
    ),
    (
      StoredProperty(name: "initialized", typeName: "Double", attributes: ["@MainActor"], initialValueExpression: "1.0"),
      ["@MainActor", "var initialized: Double = 1.0"],
      ["nonisolated", "(set)"]
    )
  ]
  
  for (property, includedFragments, excludedFragments) in samples {
    let rendered = try property.makeSyntaxRepresentation().trimmedDescription
    
    for fragment in includedFragments {
      #expect(rendered.contains(fragment))
    }
    for fragment in excludedFragments {
      #expect(!rendered.contains(fragment))
    }
  }
}

@Test("Generation builders collect stored properties and foreach declarations")
func testGenerationBuildersCollectStoredPropertiesAndForEachDeclarations() throws {
  // Hand-written examples: the result-builder pieces should collect stored
  // properties directly, flatten component arrays, and evaluate `ForEach` into
  // declaration syntax values.
  let first = StoredProperty(name: "first", typeName: "Int")
  let second = StoredProperty(name: "second", typeName: "String")
  let repeated = ForEach(source: [1, 2]) { index in
    [
      DeclSyntax(
        try! VariableDeclSyntax("var generated\(raw: index): Int")
      )
    ]
  }
  let storedComponent = DataTypeBodyBuilder.buildExpression(first)
  let repeatedComponent = DataTypeBodyBuilder.buildExpression(repeated)
  let combined = DataTypeBodyBuilder.buildBlock(
    storedComponent,
    DataTypeBodyBuilder.buildExpression(second),
    repeatedComponent
  )
  
  #expect(storedComponent.count == 1)
  #expect(repeated.evaluate().map(\.trimmedDescription) == ["var generated1: Int", "var generated2: Int"])
  #expect(combined.count == 4)
  #expect(try combined.map { try $0.makeDeclSyntax().trimmedDescription } == [
    "var first: Int",
    "var second: String",
    "var generated1: Int",
    "var generated2: Int"
  ])
}

@Test("Declaration syntax wrappers validate and erase generated declarations")
func testDeclarationSyntaxWrappersValidateAndEraseGeneratedDeclarations() throws {
  // Property-style test: concrete SwiftSyntax declarations, `DeclSyntax`, and
  // custom concrete declaration wrappers should all erase to the same validated
  // declaration text used by member-block generation.
  let variable = try VariableDeclSyntax("var value: Int")
  let erased = try variable.makeDeclSyntax()
  let existingDeclSyntax = try erased.makeDeclSyntax()
  let generated = try StoredProperty(name: "name", typeName: "String").makeDeclSyntax()
  let memberBlock = MemberBlockSyntax(declarations: [variable, generated.as(VariableDeclSyntax.self)!])
  
  #expect(erased.trimmedDescription == "var value: Int")
  #expect(existingDeclSyntax.trimmedDescription == "var value: Int")
  #expect(generated.trimmedDescription == "var name: String")
  #expect(memberBlock.members.map { $0.decl.trimmedDescription } == ["var value: Int", "var name: String"])
}

@Test("Generic and inheritance generation helpers insert trailing commas correctly")
func testGenericAndInheritanceGenerationHelpersInsertTrailingCommasCorrectly() {
  // Hand-written examples: inheritance and generic where-clause helpers should
  // produce comma-separated syntax without a trailing comma on the final element.
  let inheritedTypes = InheritedTypeListSyntax.forTypeNames(["Base", "Sendable", "Codable"])
  let inheritanceClause = InheritanceClauseSyntax.forInheritedTypeNames(["Base", "Sendable"])
  let requirement = GenericRequirementSyntax.requirement(that: "Element", inheritsFrom: "Sendable")
  let whereClause = GenericWhereClauseSyntax(requirements: [
    requirement,
    .requirement(that: "Value", inheritsFrom: "Codable")
  ])
  
  #expect(inheritedTypes.trimmedDescription == "Base, Sendable, Codable")
  #expect(inheritanceClause.trimmedDescription == ": Base, Sendable")
  #expect(requirement.trimmedDescription == "Element: Sendable")
  #expect(whereClause.trimmedDescription == "where Element: Sendable, Value: Codable")
}

@Test("Generic where clauses cover cartesian product generation")
func testGenericWhereClausesCoverCartesianProductGeneration() {
  // Property-style test: cartesian-product helpers should visit every ordered pair
  // exactly once, and the failably-transformed variant should omit nil results.
  let leftTypes = ["A", "B"]
  let rightTypes = ["Sendable", "Codable"]
  let fullProduct = GenericWhereClauseSyntax.withTransformedCartesianProduct(
    of: (leftTypes, rightTypes)
  ) { left, right in
    GenericRequirementSyntax.requirement(that: left, inheritsFrom: right)
  }
  let filteredProduct = GenericWhereClauseSyntax.withFailablyTransformedCartesianProduct(
    of: (leftTypes, rightTypes)
  ) { left, right in
    guard right == "Sendable" else { return nil }
    return GenericRequirementSyntax.requirement(that: left, inheritsFrom: right)
  }
  
  #expect(fullProduct.trimmedDescription == "where A: Sendable, A: Codable, B: Sendable, B: Codable")
  #expect(fullProduct.requirements.map(\.trimmedDescription) == [
    "A: Sendable,",
    "A: Codable,",
    "B: Sendable,",
    "B: Codable"
  ])
  #expect(filteredProduct.trimmedDescription == "where A: Sendable, B: Sendable")
  #expect(filteredProduct.requirements.map(\.trimmedDescription) == [
    "A: Sendable,",
    "B: Sendable"
  ])
}

@Test("Autoformatting helpers preserve syntax shape")
func testAutoformattingHelpersPreserveSyntaxShape() throws {
  // Hand-written examples: current autoformatting intentionally returns the same
  // syntax shape, but the wrapper APIs should still call through and preserve
  // single syntax values and sequences.
  let variable = try VariableDeclSyntax("var value: Int")
  let function = try FunctionDeclSyntax("func run(){}")
  let formattedVariable = try autoformattedEquivalent(of: variable)
  let formattedFunction = try withAutomaticReformatting {
    function
  }
  let formattedSequence: [VariableDeclSyntax] = try withAutomaticReformatting {
    [
      try VariableDeclSyntax("var first: Int"),
      try VariableDeclSyntax("var second: String")
    ]
  }
  
  _ = BasicFormat.hdxlProjectFormatting(
    initialIndentation: .spaces(2),
    viewMode: .sourceAccurate
  )
  _ = BasicFormat.hdxlProjectFormatting()
  let validatedVariable = try variable.validated()
  
  #expect(formattedVariable.trimmedDescription == "var value: Int")
  #expect(validatedVariable.trimmedDescription == "var value: Int")
  #expect(formattedFunction.trimmedDescription == "func run(){}")
  #expect(formattedSequence.map(\.trimmedDescription) == ["var first: Int", "var second: String"])
}

@Test("Syntax collection comma insertion handles empty, single, and multiple elements")
func testSyntaxCollectionCommaInsertionHandlesEmptySingleAndMultipleElements() {
  // Property-style test: collections with comma-bearing elements should never add
  // a trailing comma to the final element, and should add commas between every
  // adjacent pair.
  let empty = InheritedTypeListSyntax.forTypeNames([])
  let single = InheritedTypeListSyntax.forTypeNames(["Only"])
  let multiple = InheritedTypeListSyntax.forTypeNames(["First", "Second", "Third"])
  
  #expect(empty.trimmedDescription.isEmpty)
  #expect(single.trimmedDescription == "Only")
  #expect(multiple.trimmedDescription == "First, Second, Third")
}
