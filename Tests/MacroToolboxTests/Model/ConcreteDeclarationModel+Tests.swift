import SwiftSyntax
import Testing
@testable import MacroToolbox

@Test("Concrete declaration wrappers preserve SwiftSyntax declaration cases")
func testConcreteDeclarationWrappersPreserveSwiftSyntaxDeclarationCases() throws {
  // Hand-written examples: every SwiftSyntax declaration kind supported by
  // ConcreteDeclSyntax should initialize into the matching enum case, including
  // declarations that need to be constructed manually rather than parsed.
  let fixtures = try concreteDeclarationFixtures()
  
  for fixture in fixtures {
    let concrete = try #require(concreteDeclSyntax(from: fixture.declaration))
    
    #expect(concrete.caseName == fixture.expectedCaseName)
    #expect(concrete.isConcreteTypeDeclaration == (fixture.expectedTypeDeclarationArchetype != nil))
    #expect(concrete.concreteTypeDeclaration?.caseName == fixture.expectedTypeDeclarationArchetype)
  }
  
  let accessor = try #require(fixtures.first { $0.expectedCaseName == "accessor" })
  let concreteAccessor = try #require(concreteDeclSyntax(from: accessor.declaration))
  #expect(concreteAccessor.modifiers == nil)
  #expect(concreteAccessor.attributes?.isEmpty == true)
}

@Test("Concrete declaration wrapper forwarding matches wrapped syntax")
func testConcreteDeclarationWrapperForwardingMatchesWrappedSyntax() throws {
  // Property-style test: for all supported concrete declaration cases, forwarded
  // modifiers, visibility, attributes, and type-declaration projection should
  // agree with the same information read directly from the wrapped syntax.
  let fixtures = try concreteDeclarationFixtures()
  
  for fixture in fixtures {
    let concrete = try #require(concreteDeclSyntax(from: fixture.declaration))
    
    #expect(concrete.modifiers?.map(\.name.text) == fixture.expectedModifierNames)
    #expect(concrete.visibilityLevel == fixture.expectedVisibilityLevel)
    #expect(concrete.attributes?.count == fixture.expectedAttributeCount)
    #expect(concrete.concreteTypeDeclaration?.name == fixture.expectedTypeName)
  }
}

@Test("Concrete type declaration wrappers expose shared type metadata")
func testConcreteTypeDeclarationWrappersExposeSharedTypeMetadata() throws {
  // Hand-written examples: actor, class, enum, and struct wrappers should expose
  // the wrapped declaration's name, modifiers, inheritance, generics, where
  // clause, attributes, visibility, and corresponding ConcreteDeclSyntax case.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    @usableFromInline
    internal actor Worker<State>: Sendable where State: Sendable {}
    public class Box<Element>: NSObject {}
    enum Choice<Value>: Sendable where Value: Sendable { case value(Value) }
    private struct Pair<First, Second>: Sendable {}
    """
  )
  let actor = try #require(sourceFile.firstSyntaxElement(ofType: ActorDeclSyntax.self))
  let classDecl = try #require(sourceFile.firstSyntaxElement(ofType: ClassDeclSyntax.self))
  let enumDecl = try #require(sourceFile.firstSyntaxElement(ofType: EnumDeclSyntax.self))
  let structDecl = try #require(sourceFile.firstSyntaxElement(ofType: StructDeclSyntax.self))
  
  let declarations = [
    try #require(ConcreteTypeDeclaration(decl: actor)),
    try #require(ConcreteTypeDeclaration(decl: classDecl)),
    try #require(ConcreteTypeDeclaration(decl: enumDecl)),
    try #require(ConcreteTypeDeclaration(decl: structDecl))
  ]
  
  #expect(declarations.map(\.name) == ["Worker", "Box", "Choice", "Pair"])
  #expect(declarations.map(\.explicitVisibilityLevel) == [.internal, .public, nil, .private])
  #expect(declarations.map(\.inlinabilityDisposition) == [.usableFromInline, nil, nil, nil])
  #expect(declarations.map { $0.genericParameterClause != nil } == [true, true, true, true])
  #expect(declarations.map { $0.inheritanceClause != nil } == [true, true, true, true])
  #expect(declarations.map { $0.genericWhereClause != nil } == [true, false, true, false])
  #expect(declarations.map(\.concreteDeclSyntax.caseName) == ["actor", "class", "enum", "struct"])
  #expect(ConcreteTypeDeclaration(decl: try VariableDeclSyntax.onlyParsed(from: "let value = 1")) == nil)
}

@Test("Concrete type declaration wrappers match direct SwiftSyntax access")
func testConcreteTypeDeclarationWrappersMatchDirectSwiftSyntaxAccess() throws {
  // Property-style test: the type wrapper is a lossless projection over the
  // supported declaration nodes, so each property should match a direct switch
  // over the concrete SwiftSyntax declaration.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    actor Worker<State>: Sendable where State: Sendable {}
    class Box<Element>: NSObject {}
    enum Choice<Value>: Sendable where Value: Sendable { case value(Value) }
    struct Pair<First, Second>: Sendable {}
    """
  )
  let actor = try #require(sourceFile.firstSyntaxElement(ofType: ActorDeclSyntax.self))
  let classDecl = try #require(sourceFile.firstSyntaxElement(ofType: ClassDeclSyntax.self))
  let enumDecl = try #require(sourceFile.firstSyntaxElement(ofType: EnumDeclSyntax.self))
  let structDecl = try #require(sourceFile.firstSyntaxElement(ofType: StructDeclSyntax.self))
  let declarations = [
    try #require(ConcreteTypeDeclaration(decl: actor)),
    try #require(ConcreteTypeDeclaration(decl: classDecl)),
    try #require(ConcreteTypeDeclaration(decl: enumDecl)),
    try #require(ConcreteTypeDeclaration(decl: structDecl))
  ]
  
  for declaration in declarations {
    #expect(declaration.name == declaration.nameSyntax.text)
    #expect(declaration.explicitVisibilityLevel == declaration.modifiers.visibilityLevel)
    #expect(declaration.inlinabilityDisposition == declaration.attributes.inlinabilityDisposition)
    #expect(declaration.concreteDeclSyntax.concreteTypeDeclaration == declaration)
  }
}

@Test("Concrete data type declaration wrappers expose stored-property metadata")
func testConcreteDataTypeDeclarationWrappersExposeStoredPropertyMetadata() throws {
  // Hand-written examples: data-type wrappers should accept only actor, class,
  // and struct declarations, and should expose names, generics, inheritance,
  // attributes, visibility, where clauses, and stored-property descriptors.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    @usableFromInline
    internal actor Worker<State>: Sendable where State: Sendable {
      var state: State
    }
    public class Box<Element>: NSObject {
      var value: Element
    }
    private struct Pair<First, Second>: Sendable {
      var first: First
      var computed: Int { get { 1 } }
    }
    enum Choice { case value }
    """
  )
  let actor = try #require(sourceFile.firstSyntaxElement(ofType: ActorDeclSyntax.self))
  let classDecl = try #require(sourceFile.firstSyntaxElement(ofType: ClassDeclSyntax.self))
  let structDecl = try #require(sourceFile.firstSyntaxElement(ofType: StructDeclSyntax.self))
  let enumDecl = try #require(sourceFile.firstSyntaxElement(ofType: EnumDeclSyntax.self))
  
  let declarations = [
    try #require(ConcreteDataTypeDeclaration(decl: actor)),
    try #require(ConcreteDataTypeDeclaration(decl: classDecl)),
    try #require(ConcreteDataTypeDeclaration(decl: structDecl))
  ]
  
  #expect(declarations.map(\.name) == ["Worker", "Box", "Pair"])
  #expect(declarations.map(\.explicitVisibilityLevel) == [.internal, .public, .private])
  #expect(declarations.map(\.inlinabilityDisposition) == [.usableFromInline, nil, nil])
  #expect(declarations.map(\.concreteDeclSyntax.caseName) == ["actor", "class", "struct"])
  #expect(declarations.map { $0.genericParameterClause != nil } == [true, true, true])
  #expect(declarations.map { $0.inheritanceClause != nil } == [true, true, true])
  #expect(declarations.map { $0.genericWhereClause != nil } == [true, false, false])
  #expect(declarations.map { $0.storedPropertyDescriptors.map(\.storage.variableName) } == [["state"], ["value"], ["first"]])
  #expect(ConcreteDataTypeDeclaration(decl: enumDecl) == nil)
}

@Test("Concrete data type declaration wrappers match direct SwiftSyntax access")
func testConcreteDataTypeDeclarationWrappersMatchDirectSwiftSyntaxAccess() throws {
  // Property-style test: each data-type wrapper should forward exactly to the
  // corresponding actor/class/struct declaration for shared metadata and stored
  // properties.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    actor Worker<State>: Sendable where State: Sendable { var state: State }
    class Box<Element>: NSObject { var value: Element }
    struct Pair<First, Second>: Sendable { var first: First }
    """
  )
  let actor = try #require(sourceFile.firstSyntaxElement(ofType: ActorDeclSyntax.self))
  let classDecl = try #require(sourceFile.firstSyntaxElement(ofType: ClassDeclSyntax.self))
  let structDecl = try #require(sourceFile.firstSyntaxElement(ofType: StructDeclSyntax.self))
  let declarations = [
    try #require(ConcreteDataTypeDeclaration(decl: actor)),
    try #require(ConcreteDataTypeDeclaration(decl: classDecl)),
    try #require(ConcreteDataTypeDeclaration(decl: structDecl))
  ]
  
  for declaration in declarations {
    let projectedStoredProperties = try #require(
      declaration
        .concreteDeclSyntax
        .concreteTypeDeclaration?
        .storedPropertyDescriptorsForDataTypes
    )
    
    #expect(declaration.name == declaration.nameSyntax.text)
    #expect(declaration.explicitVisibilityLevel == declaration.modifiers.visibilityLevel)
    #expect(declaration.inlinabilityDisposition == declaration.attributes.inlinabilityDisposition)
    #expect(declaration.storedPropertyDescriptors == projectedStoredProperties)
  }
}

@Test("Data type field structure descriptors summarize stored fields")
func testDataTypeFieldStructureDescriptorsSummarizeStoredFields() throws {
  // Hand-written examples: a field-structure descriptor should be available for
  // data types, expose cloned storage-equivalent snapshots, and ignore computed
  // properties when listing stored fields.
  let structure = try StructDeclSyntax.onlyParsed(
    from: """
    @usableFromInline
    internal struct Record<Value>: Sendable where Value: Sendable {
      @usableFromInline
      internal var first: Value
      private var second: String
      var computed: Int { get { 1 } }
    }
    """
  )
  let enumDecl = try EnumDeclSyntax.onlyParsed(from: "enum Choice { case value }")
  let descriptor = try #require(DataTypeFieldStructureDescriptor(decl: structure))
  let otherDescriptor = try #require(
    DataTypeFieldStructureDescriptor(
      decl: try StructDeclSyntax.onlyParsed(from: "struct Other { var value: Int }")
    )
  )
  let clone = descriptor.makeClone()
  let firstProperty = try #require(descriptor.storedPropertyDescriptors.first)
  let secondProperty = try #require(descriptor.storedPropertyDescriptors.dropFirst().first)
  let duplicateFirstPropertyStorage = StoredPropertyDescriptor.Storage(
    variableName: firstProperty.storage.variableName,
    primaryBinding: firstProperty.storage.primaryBinding,
    variableDeclaration: firstProperty.storage.variableDeclaration
  )
  
  #expect(descriptor.name == "Record")
  #expect(descriptor.dataTypeDeclaration.name == "Record")
  #expect(descriptor.genericParameterClause?.simpleGenericParameterNames == ["Value"])
  #expect(descriptor.inheritanceClause != nil)
  #expect(descriptor.genericWhereClause != nil)
  #expect(descriptor.storedPropertyDescriptors.map(\.storage.variableName) == ["first", "second"])
  #expect(descriptor.storage.modifierList.visibilityLevel == .internal)
  #expect(descriptor.storage.attributeList.inlinabilityDisposition == .usableFromInline)
  #expect(descriptor.storage.nonConfigurationAttributes.count == 1)
  #expect(descriptor.storage.visibilityLevel == .internal)
  #expect(descriptor.storage == descriptor.storage)
  #expect(!(descriptor.storage == otherDescriptor.storage))
  #expect(firstProperty.storage.modifierList.visibilityLevel == .internal)
  #expect(firstProperty.storage.attributeList.inlinabilityDisposition == .usableFromInline)
  #expect(firstProperty.storage.nonConfigurationAttributes.count == 1)
  #expect(firstProperty.storage.visibilityLevel == .internal)
  #expect(firstProperty.storage == duplicateFirstPropertyStorage)
  #expect(!(firstProperty.storage == firstProperty.storage))
  #expect(!(firstProperty.storage == secondProperty.storage))
  #expect(firstProperty.hashValue == firstProperty.hashValue)
  #expect(descriptor.conditionallyMapFields(transformation: \.storage.variableName) { $0.storage.variableName.hasPrefix("s") } == ["second"])
  #expect(clone == descriptor)
  #expect(clone.hashValue == descriptor.hashValue)
  #expect(DataTypeFieldStructureDescriptor(decl: enumDecl) == nil)
}

@Test("Data type field structure descriptors match data-type declarations")
func testDataTypeFieldStructureDescriptorsMatchDataTypeDeclarations() throws {
  // Property-style test: for every supported data-type declaration, the
  // field-structure descriptor should match the wrapped declaration's name,
  // generic syntax, inheritance syntax, and stored-property descriptor list.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    actor Worker<State>: Sendable where State: Sendable { var state: State }
    class Box<Element>: NSObject { var value: Element }
    struct Pair<First, Second>: Sendable { var first: First }
    enum Choice { case value }
    """
  )
  let actor = try #require(sourceFile.firstSyntaxElement(ofType: ActorDeclSyntax.self))
  let classDecl = try #require(sourceFile.firstSyntaxElement(ofType: ClassDeclSyntax.self))
  let structDecl = try #require(sourceFile.firstSyntaxElement(ofType: StructDeclSyntax.self))
  let pairs = [
    (
      try #require(ConcreteDataTypeDeclaration(decl: actor)),
      try #require(DataTypeFieldStructureDescriptor(decl: actor))
    ),
    (
      try #require(ConcreteDataTypeDeclaration(decl: classDecl)),
      try #require(DataTypeFieldStructureDescriptor(decl: classDecl))
    ),
    (
      try #require(ConcreteDataTypeDeclaration(decl: structDecl)),
      try #require(DataTypeFieldStructureDescriptor(decl: structDecl))
    )
  ]
  
  for (dataType, descriptor) in pairs {
    #expect(descriptor.dataTypeDeclaration == dataType)
    #expect(descriptor.name == dataType.name)
    #expect(descriptor.genericParameterClause == dataType.genericParameterClause)
    #expect(descriptor.inheritanceClause == dataType.inheritanceClause)
    #expect(descriptor.genericWhereClause == dataType.genericWhereClause)
    #expect(descriptor.storedPropertyDescriptors == dataType.storedPropertyDescriptors)
  }
  
  #expect(DataTypeFieldStructureDescriptor(decl: try #require(sourceFile.firstSyntaxElement(ofType: EnumDeclSyntax.self))) == nil)
}

private struct ConcreteDeclarationFixture {
  var declaration: any DeclSyntaxProtocol
  var expectedCaseName: String
  var expectedTypeDeclarationArchetype: String?
  var expectedModifierNames: [String]?
  var expectedVisibilityLevel: VisibilityLevel?
  var expectedAttributeCount: Int?
  var expectedTypeName: String?
}

private func concreteDeclSyntax(
  from declaration: any DeclSyntaxProtocol
) -> ConcreteDeclSyntax? {
  if let declaration = declaration.as(AccessorDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(ActorDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(AssociatedTypeDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(ClassDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(DeinitializerDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(EditorPlaceholderDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(EnumCaseDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(EnumDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(ExtensionDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(FunctionDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(IfConfigDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(ImportDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(InitializerDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(MacroDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(MacroExpansionDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(MissingDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(OperatorDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(PoundSourceLocationSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(PrecedenceGroupDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(ProtocolDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(StructDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(SubscriptDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(TypeAliasDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else if let declaration = declaration.as(VariableDeclSyntax.self) {
    ConcreteDeclSyntax(decl: declaration)
  } else {
    nil
  }
}

private func concreteDeclarationFixtures() throws -> [ConcreteDeclarationFixture] {
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    import Foundation
    #sourceLocation(file: "Fixture.swift", line: 10)
    public actor Worker {}
    final class Box {
      init() {}
      deinit {}
      subscript(index: Int) -> Int { index }
      var value: Int { get { 0 } }
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
  let editorPlaceholder = EditorPlaceholderDeclSyntax(
    modifiers: [DeclModifierSyntax(name: .keyword(.public))],
    placeholder: .identifier("<#code#>")
  )
  let missing = MissingDeclSyntax(
    attributes: [.attribute(AttributeSyntax(attributeName: IdentifierTypeSyntax.forType(named: "MissingAttribute")))],
    modifiers: [DeclModifierSyntax(name: .keyword(.private))],
    placeholder: .identifier("<#missing#>")
  )
  
  return [
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: AccessorDeclSyntax.self)),
      expectedCaseName: "accessor",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: nil,
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: ActorDeclSyntax.self)),
      expectedCaseName: "actor",
      expectedTypeDeclarationArchetype: "actor",
      expectedModifierNames: ["public"],
      expectedVisibilityLevel: .public,
      expectedAttributeCount: 0,
      expectedTypeName: "Worker"
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: AssociatedTypeDeclSyntax.self)),
      expectedCaseName: "associatedtype",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: ClassDeclSyntax.self)),
      expectedCaseName: "class",
      expectedTypeDeclarationArchetype: "class",
      expectedModifierNames: ["final"],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: "Box"
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: DeinitializerDeclSyntax.self)),
      expectedCaseName: "deinitializer",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: editorPlaceholder,
      expectedCaseName: "editorPlaceholder",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: ["public"],
      expectedVisibilityLevel: .public,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: EnumCaseDeclSyntax.self)),
      expectedCaseName: "enumCase",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: EnumDeclSyntax.self)),
      expectedCaseName: "enum",
      expectedTypeDeclarationArchetype: "enum",
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: "Choice"
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: ExtensionDeclSyntax.self)),
      expectedCaseName: "extension",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: FunctionDeclSyntax.self)),
      expectedCaseName: "function",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: IfConfigDeclSyntax.self)),
      expectedCaseName: "ifConfig",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: nil,
      expectedVisibilityLevel: nil,
      expectedAttributeCount: nil,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: ImportDeclSyntax.self)),
      expectedCaseName: "import",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: InitializerDeclSyntax.self)),
      expectedCaseName: "initializer",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: MacroDeclSyntax.self)),
      expectedCaseName: "macro",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: macroExpansion,
      expectedCaseName: "macroExpansion",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: missing,
      expectedCaseName: "missing",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: ["private"],
      expectedVisibilityLevel: .private,
      expectedAttributeCount: 1,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: OperatorDeclSyntax.self)),
      expectedCaseName: "operator",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: nil,
      expectedVisibilityLevel: nil,
      expectedAttributeCount: nil,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: PoundSourceLocationSyntax.self)),
      expectedCaseName: "poundSourceLocation",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: nil,
      expectedVisibilityLevel: nil,
      expectedAttributeCount: nil,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: PrecedenceGroupDeclSyntax.self)),
      expectedCaseName: "precedenceGroup",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: ProtocolDeclSyntax.self)),
      expectedCaseName: "protocol",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: StructDeclSyntax.self)),
      expectedCaseName: "struct",
      expectedTypeDeclarationArchetype: "struct",
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: "Pair"
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: SubscriptDeclSyntax.self)),
      expectedCaseName: "subscript",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: TypeAliasDeclSyntax.self)),
      expectedCaseName: "typealias",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    ),
    ConcreteDeclarationFixture(
      declaration: try #require(sourceFile.firstSyntaxElement(ofType: VariableDeclSyntax.self)),
      expectedCaseName: "variable",
      expectedTypeDeclarationArchetype: nil,
      expectedModifierNames: [],
      expectedVisibilityLevel: nil,
      expectedAttributeCount: 0,
      expectedTypeName: nil
    )
  ]
}

private extension ConcreteDeclSyntax {
  
  var caseName: String {
    switch self {
    case .accessor:
      "accessor"
    case .actor:
      "actor"
    case .associatedtype:
      "associatedtype"
    case .class:
      "class"
    case .deinitializer:
      "deinitializer"
    case .editorPlaceholder:
      "editorPlaceholder"
    case .enumCase:
      "enumCase"
    case .enum:
      "enum"
    case .extension:
      "extension"
    case .function:
      "function"
    case .ifConfig:
      "ifConfig"
    case .import:
      "import"
    case .initializer:
      "initializer"
    case .macro:
      "macro"
    case .macroExpansion:
      "macroExpansion"
    case .missing:
      "missing"
    case .operator:
      "operator"
    case .poundSourceLocation:
      "poundSourceLocation"
    case .precedenceGroup:
      "precedenceGroup"
    case .protocol:
      "protocol"
    case .struct:
      "struct"
    case .subscript:
      "subscript"
    case .typealias:
      "typealias"
    case .variable:
      "variable"
    }
  }
  
}

private extension ConcreteTypeDeclaration {
  
  var caseName: String {
    switch self {
    case .actor:
      "actor"
    case .class:
      "class"
    case .enum:
      "enum"
    case .struct:
      "struct"
    }
  }
  
  var storedPropertyDescriptorsForDataTypes: [StoredPropertyDescriptor]? {
    switch self {
    case .actor(let decl):
      decl.storedPropertyDescriptors
    case .class(let decl):
      decl.storedPropertyDescriptors
    case .enum:
      nil
    case .struct(let decl):
      decl.storedPropertyDescriptors
    }
  }
  
}
