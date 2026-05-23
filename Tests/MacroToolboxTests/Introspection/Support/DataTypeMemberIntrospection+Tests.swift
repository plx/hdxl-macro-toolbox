import SwiftSyntax
import Testing
@testable import MacroToolbox

@Test("Variable declarations classify stored-property shapes")
func testVariableDeclarationsClassifyStoredPropertyShapes() throws {
  // Hand-written examples: the stored-property detector should accept plain
  // stored declarations and observing accessors, but reject multi-bindings,
  // getter-only computed properties, and non-identifier patterns.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    struct Fixture {
      var stored: Int
      var multiA = 1, multiB = 2
      var tuplePattern: (Int, Int) {
        get { (1, 2) }
      }
      var observed: Int {
        willSet {}
        didSet {}
      }
      var computed: Int {
        get { 1 }
      }
      var shorthandComputed: Int { 1 }
      var (x, y): (Int, Int)
    }
    """
  )
  let declarations = sourceFile.variableDeclarationsByFirstIdentifier()

  #expect(declarations["stored"]?.isStoredProperty == true)
  #expect(declarations["stored"]?.variableNameIfStoredProperty == "stored")
  #expect(declarations["multiA"]?.isStoredProperty == false)
  #expect(declarations["multiA"]?.variableNameIfStoredProperty == nil)
  #expect(declarations["observed"]?.isStoredProperty == true)
  #expect(declarations["observed"]?.variableNameIfStoredProperty == "observed")
  #expect(declarations["computed"]?.isStoredProperty == false)
  #expect(declarations["computed"]?.variableNameIfStoredProperty == nil)
  #expect(declarations["shorthandComputed"]?.isStoredProperty == false)
  #expect(declarations["shorthandComputed"]?.variableNameIfStoredProperty == nil)
  
  let tuplePattern = try #require(
    sourceFile.allSyntaxElements(ofType: VariableDeclSyntax.self).first {
      $0.bindings.first?.pattern.as(TuplePatternSyntax.self) != nil
    }
  )
  #expect(tuplePattern.isStoredProperty)
  #expect(tuplePattern.variableNameIfStoredProperty == nil)
}

@Test("Variable stored-property classification agrees with descriptor construction")
func testVariableStoredPropertyClassificationAgreesWithDescriptorConstruction() throws {
  // Property-style test: for a range of declaration shapes, a stored-property
  // descriptor should exist exactly when the variable is stored and has a
  // simple identifier name.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    struct Fixture {
      var stored: Int
      let constant: String
      var observed: Int {
        willSet {}
        didSet {}
      }
      var computed: Int {
        get { 1 }
      }
      var multiA = 1, multiB = 2
      var (x, y): (Int, Int)
    }
    """
  )
  
  for declaration in sourceFile.allSyntaxElements(ofType: VariableDeclSyntax.self) {
    let expectedName = declaration.expectedStoredPropertyName
    let descriptor = StoredPropertyDescriptor(variableDeclaration: declaration)
    
    #expect(declaration.variableNameIfStoredProperty == expectedName)
    #expect((descriptor != nil) == (expectedName != nil))
    #expect(descriptor?.storage.variableName == expectedName)
  }
}

@Test("Member blocks expose typed declarations and stored properties")
func testMemberBlocksExposeTypedDeclarationsAndStoredProperties() throws {
  // Hand-written examples: member-block helpers should find declarations by
  // concrete syntax type, filter them with predicates, and derive stored
  // property descriptors only from stored property declarations.
  let structure = try StructDeclSyntax.onlyParsed(
    from: """
    struct Fixture {
      var first: Int
      var second: String
      var computed: Int { get { 1 } }
      func run() {}
      enum Nested { case value }
    }
    """
  )
  let members = structure.memberBlock.members
  
  #expect(Array(structure.memberBlock.allDeclarations(ofType: VariableDeclSyntax.self)).count == 3)
  #expect(Array(members.allDeclarations(ofType: FunctionDeclSyntax.self)).count == 1)
  #expect(
    structure.memberBlock
      .allSatisfactoryDeclarations(ofType: VariableDeclSyntax.self) {
        $0.variableNameIfStoredProperty?.hasPrefix("s") == true
      }
      .map(\.variableNameIfStoredProperty)
    ==
    ["second"]
  )
  #expect(
    members
      .allSatisfactoryDeclarations(ofType: VariableDeclSyntax.self) {
        $0.variableNameIfStoredProperty != nil
      }
      .map(\.variableNameIfStoredProperty)
    ==
    ["first", "second"]
  )
  #expect(
    structure.memberBlock.predicateHoldsForAllDeclarations(
      ofType: FunctionDeclSyntax.self
    ) {
      $0.name.text == "run"
    }
  )
  #expect(
    !members.predicateHoldsForAllDeclarations(
      ofType: VariableDeclSyntax.self
    ) {
      $0.variableNameIfStoredProperty != nil
    }
  )
  #expect(structure.memberBlock.storedPropertyDescriptors.map(\.storage.variableName) == ["first", "second"])
  #expect(
    structure.memberBlock
      .allStoredPropertyDescriptors { $0.storage.variableName == "second" }
      .map(\.storage.variableName)
    ==
    ["second"]
  )
}

@Test("Member-block declaration helpers agree with standard collection operations")
func testMemberBlockDeclarationHelpersAgreeWithStandardCollectionOperations() throws {
  // Property-style test: across several type declarations, the convenience
  // helpers should match the same compact-map, filter, and allSatisfy logic
  // written directly over the member list.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    struct StructFixture {
      var first: Int
      var computed: Int { get { 1 } }
      func run() {}
    }
    class ClassFixture {
      var first: Int
      var second: String
      convenience init() { self.init(value: 0) }
      init(value: Int) { self.first = value; self.second = "" }
    }
    actor ActorFixture {
      var first: Int
      func run() {}
    }
    """
  )
  
  for declaration in sourceFile.allSyntaxElements(ofType: StructDeclSyntax.self) {
    assertMemberBlockProperties(declaration.memberBlock)
  }
  for declaration in sourceFile.allSyntaxElements(ofType: ClassDeclSyntax.self) {
    assertMemberBlockProperties(declaration.memberBlock)
  }
  for declaration in sourceFile.allSyntaxElements(ofType: ActorDeclSyntax.self) {
    assertMemberBlockProperties(declaration.memberBlock)
  }
}

@Test("Data type declarations forward generic and stored-property helpers")
func testDataTypeDeclarationsForwardGenericAndStoredPropertyHelpers() throws {
  // Hand-written examples: struct, class, and actor declarations should expose
  // their generic parameter names and stored-property descriptors through the
  // declaration-specific forwarding conveniences.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    struct StructBox<T> {
      var value: T
      var computed: Int { get { 1 } }
    }
    class ClassBox<Element> {
      var value: Element
      convenience init() { self.init(value: fatalError()) }
      required init(value: Element) { self.value = value }
    }
    actor ActorBox<State> {
      var state: State
    }
    """
  )
  let structure = try #require(sourceFile.firstSyntaxElement(ofType: StructDeclSyntax.self))
  let classDecl = try #require(sourceFile.firstSyntaxElement(ofType: ClassDeclSyntax.self))
  let actor = try #require(sourceFile.firstSyntaxElement(ofType: ActorDeclSyntax.self))
  
  #expect(structure.simpleGenericParameterNames == ["T"])
  #expect(structure.storedPropertyDescriptors.map(\.storage.variableName) == ["value"])
  #expect(structure.allStoredPropertyDescriptors { $0.storage.variableName == "value" }.count == 1)
  #expect(classDecl.simpleGenericParameterNames == ["Element"])
  #expect(classDecl.storedPropertyDescriptors.map(\.storage.variableName) == ["value"])
  #expect(classDecl.allStoredPropertyDescriptors { $0.storage.variableName == "value" }.count == 1)
  #expect(classDecl.preferredDesignatedInitializerDeclarationIfAvailable?.signature.description.contains("value: Element") == true)
  #expect(actor.simpleGenericParameterNames == ["State"])
  #expect(actor.storedPropertyDescriptors.map(\.storage.variableName) == ["state"])
  #expect(actor.allStoredPropertyDescriptors { $0.storage.variableName == "state" }.count == 1)
}

@Test("Data type declaration helpers agree with member-block helpers")
func testDataTypeDeclarationHelpersAgreeWithMemberBlockHelpers() throws {
  // Property-style test: for each supported data-type declaration, forwarded
  // stored-property helpers should equal the result from its own member block.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    struct StructBox<T> {
      var value: T
    }
    class ClassBox<Element> {
      var value: Element
      init(value: Element) { self.value = value }
    }
    actor ActorBox<State> {
      var state: State
    }
    """
  )
  
  for structure in sourceFile.allSyntaxElements(ofType: StructDeclSyntax.self) {
    #expect(structure.simpleGenericParameterNames == structure.genericParameterClause?.simpleGenericParameterNames)
    #expect(structure.storedPropertyDescriptors == structure.memberBlock.storedPropertyDescriptors)
    #expect(
      structure.allStoredPropertyDescriptors { $0.storage.variableName.hasSuffix("e") }
      ==
      structure.memberBlock.allStoredPropertyDescriptors { $0.storage.variableName.hasSuffix("e") }
    )
  }
  for classDecl in sourceFile.allSyntaxElements(ofType: ClassDeclSyntax.self) {
    #expect(classDecl.simpleGenericParameterNames == classDecl.genericParameterClause?.simpleGenericParameterNames)
    #expect(classDecl.storedPropertyDescriptors == classDecl.memberBlock.storedPropertyDescriptors)
    #expect(
      classDecl.allStoredPropertyDescriptors { $0.storage.variableName.hasSuffix("e") }
      ==
      classDecl.memberBlock.allStoredPropertyDescriptors { $0.storage.variableName.hasSuffix("e") }
    )
  }
  for actor in sourceFile.allSyntaxElements(ofType: ActorDeclSyntax.self) {
    #expect(actor.simpleGenericParameterNames == actor.genericParameterClause?.simpleGenericParameterNames)
    #expect(actor.storedPropertyDescriptors == actor.memberBlock.storedPropertyDescriptors)
    #expect(
      actor.allStoredPropertyDescriptors { $0.storage.variableName.hasSuffix("e") }
      ==
      actor.memberBlock.allStoredPropertyDescriptors { $0.storage.variableName.hasSuffix("e") }
    )
  }
}

@Test("Initializer helpers identify preferred and plausible memberwise initializers")
func testInitializerHelpersIdentifyPreferredAndPlausibleMemberwiseInitializers() throws {
  // Hand-written examples: preferred initializers are detected by attribute, and
  // plausible memberwise matching accepts both labeled and unlabeled parameters
  // that correspond to stored property names.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    struct Fixture {
      var first: Int
      var second: String
      @PreferredMemberwiseInitializer
      init(first: Int, _ second: String) {
        self.first = first
        self.second = second
      }
      init(first: Int) {
        self.first = first
        self.second = ""
      }
    }
    """
  )
  let structure = try #require(sourceFile.firstSyntaxElement(ofType: StructDeclSyntax.self))
  let initializers = sourceFile.allSyntaxElements(ofType: InitializerDeclSyntax.self)
  let preferred = try #require(initializers.first)
  let incomplete = try #require(initializers.dropFirst().first)
  let storedProperties = Array(structure.memberBlock.allDeclarations(ofType: VariableDeclSyntax.self))
  
  #expect(preferred.isPreferredMemberwiseInitializer)
  #expect(preferred.isPlausibleMemberwiseInitializer(forStoredProperties: storedProperties))
  #expect(!incomplete.isPreferredMemberwiseInitializer)
  #expect(!incomplete.isPlausibleMemberwiseInitializer(forStoredProperties: storedProperties))
}

@Test("Initializer plausibility matches stored-property name coverage")
func testInitializerPlausibilityMatchesStoredPropertyNameCoverage() throws {
  // Property-style test: an initializer is plausible exactly when its parameter
  // name set covers every simple stored-property name and the counts match.
  let fixtures: [(source: String, expected: Bool)] = [
    (
      """
      struct Fixture {
        var value: Int
        init(value: Int) {}
      }
      """,
      true
    ),
    (
      """
      struct Fixture {
        var value: Int
        init(_ value: Int) {}
      }
      """,
      true
    ),
    (
      """
      struct Fixture {
        var value: Int
        var other: Int
        init(value: Int) {}
      }
      """,
      false
    ),
    (
      """
      struct Fixture {
        var (x, y): (Int, Int)
        init(value: (Int, Int)) {}
      }
      """,
      false
    )
  ]
  
  for fixture in fixtures {
    let structure = try StructDeclSyntax.onlyParsed(from: fixture.source)
    let initializer = try #require(structure.memberBlock.allDeclarations(ofType: InitializerDeclSyntax.self).first)
    let storedProperties = Array(structure.memberBlock.allDeclarations(ofType: VariableDeclSyntax.self))
    
    #expect(
      initializer.isPlausibleMemberwiseInitializer(forStoredProperties: storedProperties)
      ==
      fixture.expected
    )
  }
}

@Test("Class preferred initializer chooses required or designated initializers")
func testClassPreferredInitializerChoosesRequiredOrDesignatedInitializers() throws {
  // Hand-written examples: classes without initializers or with only convenience
  // initializers have no preferred designated initializer, while designated and
  // required initializers are accepted candidates.
  let noInitializer = try ClassDeclSyntax.onlyParsed(from: "class Empty {}")
  let convenienceOnly = try ClassDeclSyntax.onlyParsed(
    from: "class ConvenienceOnly { convenience init() { self.init() } }"
  )
  let designated = try ClassDeclSyntax.onlyParsed(
    from: "class Designated { init(value: Int) {} convenience init() { self.init(value: 0) } }"
  )
  let required = try ClassDeclSyntax.onlyParsed(
    from: "class Required { required convenience init(value: Int) { self.init() } init() {} }"
  )
  
  #expect(noInitializer.preferredDesignatedInitializerDeclarationIfAvailable == nil)
  #expect(convenienceOnly.preferredDesignatedInitializerDeclarationIfAvailable == nil)
  #expect(
    designated.preferredDesignatedInitializerDeclarationIfAvailable?
      .signature
      .parameterClause
      .parameters
      .first?
      .firstName
      .text
    ==
    "value"
  )
  #expect(
    required.preferredDesignatedInitializerDeclarationIfAvailable?
      .modifiers
      .contains { $0.name.text == "required" }
    ==
    true
  )
}

@Test("Class preferred initializer matches filtering rule")
func testClassPreferredInitializerMatchesFilteringRule() throws {
  // Property-style test: the class convenience should return the first parsed
  // initializer that is required or not convenience, matching the documented
  // filtering rule used by the implementation.
  let classes = try SourceFileSyntax.onlyParsed(
    from: """
    class Empty {}
    class ConvenienceOnly {
      convenience init() { self.init() }
    }
    class Designated {
      convenience init() { self.init(value: 0) }
      init(value: Int) {}
    }
    class Required {
      required convenience init(value: Int) { self.init() }
      init() {}
    }
    """
  ).allSyntaxElements(ofType: ClassDeclSyntax.self)
  
  for classDecl in classes {
    let expected = classDecl.memberBlock.members
      .compactMap { $0.decl.as(InitializerDeclSyntax.self) }
      .filter { initializer in
        let isRequired = initializer.modifiers.contains { $0.name.text == "required" }
        let isConvenience = initializer.modifiers.contains { $0.name.text == "convenience" }
        return isRequired || !isConvenience
      }
      .first
    
    #expect(classDecl.preferredDesignatedInitializerDeclarationIfAvailable == expected)
  }
}

@Test("Declaration archetype helpers map concrete declaration types")
func testDeclarationArchetypeHelpersMapConcreteDeclarationTypes() throws {
  // Hand-written examples: declaration mapping should return the matching model
  // value for concrete declarations and nil for declarations outside a mapping.
  let structure = try StructDeclSyntax.onlyParsed(from: "struct Fixture { var value: Int }")
  let genericStructure = try StructDeclSyntax.onlyParsed(from: "struct GenericFixture<Value> {}")
  let variable = try VariableDeclSyntax.onlyParsed(from: "let value = 1")
  
  #expect(structure.typeDeclarationArchetype == .struct)
  #expect(variable.typeDeclarationArchetype == nil)
  #expect(variable.declarationArchetype == .variable)
  #expect(
    structure.applyConcreteTypeMapping(
      associations: (
        ("class", ClassDeclSyntax.self),
        ("struct", StructDeclSyntax.self)
      )
    )
    ==
    "struct"
  )
  #expect(
    structure.applyConcreteTypeMapping(
      associations: (
        ("struct", StructDeclSyntax.self),
        ("class", ClassDeclSyntax.self)
      )
    )
    ==
    "struct"
  )
  #expect(
    variable.applyConcreteTypeMapping(
      associations: (
        ("struct", StructDeclSyntax.self),
        ("class", ClassDeclSyntax.self)
      )
    )
    ==
    nil
  )
  // Empty associations are legal and should behave like "no matching type"; this
  // guards the variadic-pack loop's zero-element path.
  let emptyMapping: String? = structure.applyConcreteTypeMapping(associations: ())
  #expect(emptyMapping == nil)
  
  // A matched optional value still counts as the first match even when that
  // value is nil; later duplicate associations must not replace it.
  let nilOptionalMapping: String?? = structure.applyConcreteTypeMapping(
    associations: (
      (String?.none, StructDeclSyntax.self),
      (String?.some("fallback"), StructDeclSyntax.self)
    )
  )
  #expect(nilOptionalMapping.map { $0 == nil } == true)
  #expect(
    structure.extractHomogeneousValues(
      using: (
        (\StructDeclSyntax.name, StructDeclSyntax.self),
        (\ClassDeclSyntax.name, ClassDeclSyntax.self)
      )
    )?
      .text
    ==
    "Fixture"
  )
  #expect(
    variable.extractHomogeneousValues(
      using: (
        (\StructDeclSyntax.name, StructDeclSyntax.self),
        (\VariableDeclSyntax.bindingSpecifier, VariableDeclSyntax.self)
      )
    )?
      .text
    ==
    "let"
  )
  #expect(
    structure.extractHomogeneousValues(
      using: (
        (\StructDeclSyntax.genericParameterClause, StructDeclSyntax.self),
        (\ClassDeclSyntax.genericParameterClause, ClassDeclSyntax.self)
      )
    )
    ==
    nil
  )
  #expect(
    genericStructure.extractHomogeneousValues(
      using: (
        (\StructDeclSyntax.genericParameterClause, StructDeclSyntax.self),
        (\ClassDeclSyntax.genericParameterClause, ClassDeclSyntax.self)
      )
    )?
      .trimmedDescription
    ==
    "<Value>"
  )
  
  let missingRequiredExtraction: TokenSyntax? = variable.extractHomogeneousValues(
    using: (
      (\StructDeclSyntax.name, StructDeclSyntax.self),
      (\ClassDeclSyntax.name, ClassDeclSyntax.self)
    )
  )
  let missingOptionalExtraction: GenericParameterClauseSyntax? = variable.extractHomogeneousValues(
    using: (
      (\StructDeclSyntax.genericParameterClause, StructDeclSyntax.self),
      (\ClassDeclSyntax.genericParameterClause, ClassDeclSyntax.self)
    )
  )
  
  #expect(missingRequiredExtraction == nil)
  #expect(missingOptionalExtraction == nil)
}

@Test("Declaration archetype helpers agree with SwiftSyntax casting")
func testDeclarationArchetypeHelpersAgreeWithSwiftSyntaxCasting() throws {
  // Property-style test: for a representative set of declarations, the model
  // archetypes should agree with the declaration's concrete SwiftSyntax type.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    import Foundation
    #sourceLocation(file: "Fixture.swift", line: 10)
    public actor Worker {}
    final class Box {
      init() {}
      deinit {}
      subscript(index: Int) -> Int { index }
      var value: Int { 0 }
      func run() {}
    }
    enum Choice { case one }
    extension Choice {}
    protocol Service { associatedtype Output }
    struct Pair {}
    typealias Alias = Int
    operator infix +++
    precedencegroup CustomPrecedence {}
    macro generated() = #externalMacro(module: "M", type: "T")
    #if os(macOS)
    let conditional = true
    #endif
    let value = 1
    """
  )
  let macroExpansion = MacroExpansionDeclSyntax(
    macroName: .identifier("expand"),
    arguments: []
  )
  let expectedTypeArchetypes: [(any DeclSyntaxProtocol, TypeDeclarationArchetype?)] = [
    (try #require(sourceFile.firstSyntaxElement(ofType: ActorDeclSyntax.self)), .actor),
    (try #require(sourceFile.firstSyntaxElement(ofType: ClassDeclSyntax.self)), .class),
    (try #require(sourceFile.firstSyntaxElement(ofType: EnumDeclSyntax.self)), .enum),
    (try #require(sourceFile.firstSyntaxElement(ofType: ProtocolDeclSyntax.self)), .protocol),
    (try #require(sourceFile.firstSyntaxElement(ofType: StructDeclSyntax.self)), .struct),
    (try #require(sourceFile.firstSyntaxElement(ofType: VariableDeclSyntax.self)), nil)
  ]
  let expectedDeclarationArchetypes: [(any DeclSyntaxProtocol, DeclarationArchetype)] = [
    (try #require(sourceFile.firstSyntaxElement(ofType: ActorDeclSyntax.self)), .actor),
    (try #require(sourceFile.firstSyntaxElement(ofType: AssociatedTypeDeclSyntax.self)), .associatedtype),
    (try #require(sourceFile.firstSyntaxElement(ofType: ClassDeclSyntax.self)), .class),
    (try #require(sourceFile.firstSyntaxElement(ofType: DeinitializerDeclSyntax.self)), .deinitializer),
    (try #require(sourceFile.firstSyntaxElement(ofType: EnumCaseDeclSyntax.self)), .enumCase),
    (try #require(sourceFile.firstSyntaxElement(ofType: EnumDeclSyntax.self)), .enum),
    (try #require(sourceFile.firstSyntaxElement(ofType: ExtensionDeclSyntax.self)), .extension),
    (try #require(sourceFile.firstSyntaxElement(ofType: FunctionDeclSyntax.self)), .function),
    (try #require(sourceFile.firstSyntaxElement(ofType: IfConfigDeclSyntax.self)), .ifConfig),
    (try #require(sourceFile.firstSyntaxElement(ofType: ImportDeclSyntax.self)), .import),
    (try #require(sourceFile.firstSyntaxElement(ofType: InitializerDeclSyntax.self)), .initializer),
    (try #require(sourceFile.firstSyntaxElement(ofType: MacroDeclSyntax.self)), .macro),
    (macroExpansion, .macroExpansion),
    (try #require(sourceFile.firstSyntaxElement(ofType: OperatorDeclSyntax.self)), .operator),
    (try #require(sourceFile.firstSyntaxElement(ofType: PoundSourceLocationSyntax.self)), .poundSourceLocation),
    (try #require(sourceFile.firstSyntaxElement(ofType: PrecedenceGroupDeclSyntax.self)), .precedenceGroup),
    (try #require(sourceFile.firstSyntaxElement(ofType: ProtocolDeclSyntax.self)), .protocol),
    (try #require(sourceFile.firstSyntaxElement(ofType: StructDeclSyntax.self)), .struct),
    (try #require(sourceFile.firstSyntaxElement(ofType: SubscriptDeclSyntax.self)), .subscript),
    (try #require(sourceFile.firstSyntaxElement(ofType: TypeAliasDeclSyntax.self)), .typealias),
    (try #require(sourceFile.firstSyntaxElement(ofType: VariableDeclSyntax.self)), .variable)
  ]
  
  for (declaration, expected) in expectedTypeArchetypes {
    #expect(declaration.typeDeclarationArchetype == expected)
  }
  
  for (declaration, expected) in expectedDeclarationArchetypes {
    #expect(declaration.declarationArchetype == expected)
  }
}

private func assertMemberBlockProperties(
  _ memberBlock: MemberBlockSyntax
) {
  let members = memberBlock.members
  let variables = members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
  let storedNames = variables.compactMap(\.variableNameIfStoredProperty)
  let expectedStoredDescriptors = variables.compactMap {
    StoredPropertyDescriptor(variableDeclaration: $0)
  }
  let expectedFunctionNames = members
    .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
    .map(\.name.text)
  
  #expect(Array(memberBlock.allDeclarations(ofType: VariableDeclSyntax.self)) == variables)
  #expect(Array(members.allDeclarations(ofType: VariableDeclSyntax.self)) == variables)
  #expect(memberBlock.storedPropertyDescriptors == expectedStoredDescriptors)
  #expect(memberBlock.storedPropertyDescriptors.map(\.storage.variableName) == storedNames)
  #expect(
    memberBlock.allStoredPropertyDescriptors { $0.storage.variableName.hasPrefix("f") }
    ==
    expectedStoredDescriptors.filter { $0.storage.variableName.hasPrefix("f") }
  )
  #expect(
    memberBlock
      .allSatisfactoryDeclarations(ofType: FunctionDeclSyntax.self) { _ in true }
      .map(\.name.text)
    ==
    expectedFunctionNames
  )
  #expect(
    members
      .allSatisfactoryDeclarations(ofType: VariableDeclSyntax.self) {
        $0.variableNameIfStoredProperty != nil
      }
    ==
    variables.filter { $0.variableNameIfStoredProperty != nil }
  )
  #expect(
    memberBlock.predicateHoldsForAllDeclarations(
      ofType: VariableDeclSyntax.self
    ) {
      $0.bindings.count == 1
    }
    ==
    variables.allSatisfy { $0.bindings.count == 1 }
  )
  #expect(
    members.predicateHoldsForAllDeclarations(
      ofType: FunctionDeclSyntax.self
    ) {
      !$0.name.text.isEmpty
    }
    ==
    members.compactMap { $0.decl.as(FunctionDeclSyntax.self) }.allSatisfy {
      !$0.name.text.isEmpty
    }
  )
}

private extension SourceFileSyntax {
  
  func variableDeclarationsByFirstIdentifier() -> [String: VariableDeclSyntax] {
    Dictionary(
      uniqueKeysWithValues: allSyntaxElements(ofType: VariableDeclSyntax.self).compactMap { declaration in
        guard
          let identifier = declaration.bindings.first?.pattern.as(IdentifierPatternSyntax.self)
        else {
          return nil
        }
        
        return (identifier.identifier.text, declaration)
      }
    )
  }
  
}

private extension VariableDeclSyntax {
  
  var expectedStoredPropertyName: String? {
    guard
      bindings.count == 1,
      let binding = bindings.first,
      binding.hasAccessorsCompatibleWithStoredProperty,
      let identifier = binding.pattern.as(IdentifierPatternSyntax.self)
    else {
      return nil
    }
    
    return identifier.identifier.trimmed.text
  }
  
}

private extension PatternBindingSyntax {
  
  var hasAccessorsCompatibleWithStoredProperty: Bool {
    switch accessorBlock?.accessors {
    case .none:
      true
    case .some(.getter):
      false
    case .some(.accessors(let accessors)):
      accessors.allSatisfy(\.isCompatibleWithStoredProperty)
    }
  }
  
}
