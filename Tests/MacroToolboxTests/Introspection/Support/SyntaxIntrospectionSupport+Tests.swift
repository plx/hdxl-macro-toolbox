import SwiftSyntax
import Testing
@testable import MacroToolbox

@Test("Literal syntax value helpers")
func testLiteralSyntaxValueHelpers() throws {
  // Hand-written examples: each literal helper should return the represented
  // Swift value for a straightforward literal and nil for a token that is not
  // actually that literal kind.
  #expect(
    BooleanLiteralExprSyntax(literal: .keyword(.true)).representedBooleanLiteralValue
    ==
    true
  )
  #expect(
    BooleanLiteralExprSyntax(literal: .keyword(.false)).representedBooleanLiteralValue
    ==
    false
  )
  #expect(
    BooleanLiteralExprSyntax(literal: .identifier("flag")).representedBooleanLiteralValue
    ==
    nil
  )
  
  #expect(
    try FloatLiteralExprSyntax
      .firstParsed(from: "let value = 1.25")
      .representedFloatLiteralValue
    ==
    1.25
  )
  #expect(FloatLiteralExprSyntax(literal: .identifier("value")).representedFloatLiteralValue == nil)
  
  #expect(
    try IntegerLiteralExprSyntax
      .firstParsed(from: "let value = 42")
      .representedIntegerLiteralValue
    ==
    42
  )
  #expect(
    try IntegerLiteralExprSyntax
      .firstParsed(from: "let value = 42")
      .representedValue(ofType: UInt8.self)
    ==
    42
  )
  #expect(IntegerLiteralExprSyntax(literal: .identifier("value")).representedIntegerLiteralValue == nil)
  #expect(IntegerLiteralExprSyntax(literal: .identifier("value")).representedValue(ofType: UInt8.self) == nil)
  
  #expect(
    simpleStringLiteral(["hel", "lo"]).representedStringLiteralValue
    ==
    "hello"
  )
}

@Test("Literal syntax value helpers match token payloads")
func testLiteralSyntaxValueHelpersMatchTokenPayloads() throws {
  // Property-style test: across several literal spellings, the helper result
  // must match Swift's own numeric parsing or the literal token's known meaning.
  for value in [true, false] {
    let syntax = BooleanLiteralExprSyntax(
      literal: .keyword(value ? .true : .false)
    )
    
    #expect(syntax.representedBooleanLiteralValue == value)
  }
  
  for value in ["0.0", "3.5", "2.25"] {
    let syntax = try FloatLiteralExprSyntax.firstParsed(from: "let value = \(value)")
    #expect(syntax.representedFloatLiteralValue == Double(value))
  }
  
  for value in ["0", "7", "255"] {
    let syntax = try IntegerLiteralExprSyntax.firstParsed(from: "let value = \(value)")
    #expect(syntax.representedIntegerLiteralValue == Int(value))
    #expect(syntax.representedValue(ofType: UInt16.self) == UInt16(value))
  }
  
  for value in ["", "a", "hello"] {
    let syntax = simpleStringLiteral([value])
    #expect(syntax.representedStringLiteralValue == value)
  }
}

@Test("Token and keyword predicate helpers")
func testTokenAndKeywordPredicateHelpers() {
  // Hand-written examples: token-kind and token-syntax predicates should
  // recognize the common plus/minus operator spellings and accessor keywords.
  #expect(TokenKind.prefixOperator("-").isPrefixMinusSign)
  #expect(TokenKind.prefixOperator("+").isPrefixPlusSign)
  #expect(TokenKind.binaryOperator("-").isInfixMinusSign)
  #expect(TokenKind.binaryOperator("+").isInfixPlusSign)
  #expect(TokenKind.postfixOperator("!").isPostfixOperator("!"))
  #expect(TokenSyntax.prefixOperator("-").isPrefixOperator("-"))
  #expect(TokenSyntax.postfixOperator("!").isPostfixOperator("!"))
  #expect(TokenSyntax.binaryOperator("*").isInfixOperator("*"))
  #expect(TokenSyntax.prefixOperator("-").isPrefixMinusSign)
  #expect(TokenSyntax.prefixOperator("+").isPrefixPlusSign)
  #expect(TokenSyntax.keyword(.willSet).isWillSet)
  #expect(TokenSyntax.keyword(.didSet).isDidSet)
  #expect(TokenSyntax.keyword(.get).isGet)
  #expect(TokenSyntax.keyword(.set).isSet)
  #expect(TokenSyntax.keyword(._modify).isModify)
  #expect(TokenSyntax.keyword(.public).keyword == .public)
}

@Test("Token and keyword predicate helpers match exact token kinds")
func testTokenAndKeywordPredicateHelpersMatchExactTokenKinds() {
  // Property-style test: operator predicates are exact spelling checks, and
  // visibility keywords should round-trip through the `VisibilityLevel` model.
  for operatorSymbol in ["+", "-", "*"] {
    #expect(TokenKind.prefixOperator(operatorSymbol).isPrefixOperator(operatorSymbol))
    #expect(TokenKind.binaryOperator(operatorSymbol).isInfixOperator(operatorSymbol))
    #expect(TokenKind.postfixOperator(operatorSymbol).isPostfixOperator(operatorSymbol))
  }
  
  for visibilityLevel in VisibilityLevel.allCases {
    let keyword = visibilityLevel.keywordRepresentation
    
    #expect(keyword.visibilityLevel == visibilityLevel)
    #expect(TokenSyntax.keyword(keyword).keyword == keyword)
  }
  
  #expect(Keyword.func.visibilityLevel == nil)
  #expect(TokenSyntax.identifier("value").keyword == nil)
}

@Test("Attribute and accessor syntax helpers")
func testAttributeAndAccessorSyntaxHelpers() throws {
  // Hand-written examples: named attributes, inlinability attributes, argument
  // lists, and accessor keyword classifications are all read from parsed Swift
  // syntax rather than from manually assembled partial nodes.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    @inlinable
    @PreferredMemberwiseInitializer
    @objc(run)
    public init() {}
    struct Box {
      var observed: Int {
        willSet {}
        didSet {}
      }
      var computed: Int {
        get { 1 }
        set {}
      }
    }
    """
  )
  let attributes = try #require(
    sourceFile.firstSyntaxElement(ofType: InitializerDeclSyntax.self)?.attributes
  )
  let conditionalFunction = try FunctionDeclSyntax.onlyParsed(
    from: """
    #if os(macOS)
    @inlinable
    #endif
    func conditional() {}
    """
  )
  let conditionalAttributeElement = try #require(conditionalFunction.attributes.first)
  let preferredAttribute = try #require(
    attributes.first { $0.isPreferredMemberwiseInitializer }?.attributeSyntax
  )
  let argumentListAttribute = AttributeSyntax(
    attributeName: IdentifierTypeSyntax.forType(named: "Example"),
    leftParen: .leftParenToken(),
    arguments: .argumentList([]),
    rightParen: .rightParenToken()
  )
  let qualifiedAttribute = AttributeSyntax("@Module.Attribute")
  let accessors = sourceFile.allSyntaxElements(ofType: AccessorDeclSyntax.self)
  
  #expect(attributes.containsAttribute(named: "inlinable"))
  #expect(attributes.inlinabilityDisposition == .inlinable)
  #expect(attributes.nonConfigurationAttributes.count == 3)
  #expect(!conditionalAttributeElement.isAttribute(named: "inlinable"))
  #expect(conditionalAttributeElement.attributeSyntax == nil)
  #expect(conditionalAttributeElement.inlinabilityDisposition == nil)
  #expect(!conditionalAttributeElement.isPreferredMemberwiseInitializer)
  #expect(conditionalFunction.attributes.nonConfigurationAttributes.isEmpty)
  #expect(preferredAttribute.hasAtSign)
  #expect(preferredAttribute.hasNoArguments)
  #expect(preferredAttribute.isPreferredMemberwiseInitializer)
  #expect(preferredAttribute.argumentListAsLabeledExprList == nil)
  #expect(!argumentListAttribute.hasNoArguments)
  #expect(argumentListAttribute.argumentListAsLabeledExprList != nil)
  #expect(qualifiedAttribute.inlinabilityDisposition == nil)
  #expect(!qualifiedAttribute.hasName("Attribute"))
  #expect(accessors.contains { $0.isWillSet && $0.isCompatibleWithStoredProperty })
  #expect(accessors.contains { $0.isDidSet && $0.isCompatibleWithStoredProperty })
  #expect(accessors.contains { $0.isGet && $0.isIncompatibleWithStoredProperty })
  #expect(accessors.contains { $0.isSet && $0.isIncompatibleWithStoredProperty })
}

@Test("Accessor list compatibility follows member compatibility")
func testAccessorListCompatibilityFollowsMemberCompatibility() throws {
  // Property-style test: an accessor list is stored-property-compatible exactly
  // when none of its accessors is individually incompatible.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    struct Box {
      var observed: Int {
        willSet {}
        didSet {}
      }
      var computed: Int {
        get { 1 }
        set {}
      }
    }
    """
  )
  
  for accessorList in sourceFile.allSyntaxElements(ofType: AccessorDeclListSyntax.self) {
    let hasIncompatibleAccessor = accessorList.contains {
      $0.isIncompatibleWithStoredProperty
    }
    
    #expect(accessorList.isIncompatibleWithStoredProperty == hasIncompatibleAccessor)
    #expect(accessorList.isCompatibleWithStoredProperty == !hasIncompatibleAccessor)
  }
}

@Test("Generic name extraction helpers")
func testGenericNameExtractionHelpers() throws {
  // Hand-written examples: simple generic parameter and argument lists should
  // return just their identifier names, while parameter packs are not simple.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    struct Pair<First, Second> {}
    struct Pack<each Element> {}
    let value: Pair<Int, String>
    """
  )
  let pair = try #require(sourceFile.firstSyntaxElement(ofType: StructDeclSyntax.self))
  let pack = try #require(
    sourceFile
      .allSyntaxElements(ofType: StructDeclSyntax.self)
      .first { $0.name.text == "Pack" }
  )
  let argumentClause = try #require(
    sourceFile.firstSyntaxElement(ofType: GenericArgumentClauseSyntax.self)
  )
  
  #expect(pair.simpleGenericParameterNames == ["First", "Second"])
  #expect(pack.simpleGenericParameterNames == nil)
  #expect(argumentClause.simpleGenericParameterNames == ["Int", "String"])
}

@Test("Generic name extraction helpers require all names to be simple")
func testGenericNameExtractionHelpersRequireAllNamesToBeSimple() throws {
  // Property-style test: declarations and type arguments with only identifier
  // names produce a full name list; introducing a non-simple member makes the
  // aggregate helper return nil rather than a partial result.
  let simpleStruct = try StructDeclSyntax.onlyParsed(from: "struct Box<T, U> {}")
  let packStruct = try StructDeclSyntax.onlyParsed(from: "struct Box<each T> {}")
  let publicActor = try ActorDeclSyntax.onlyParsed(from: "@inlinable public actor Worker<State> {}")
  let genericEnum = try EnumDeclSyntax.onlyParsed(from: "enum Choice<Value> { case value(Value) }")
  let genericClass = try ClassDeclSyntax.onlyParsed(from: "class Box<Element> {}")
  let simpleArguments = try GenericArgumentClauseSyntax.firstParsed(
    from: "let value: Box<Int, String>"
  )
  let nonSimpleArguments = try GenericArgumentClauseSyntax.firstParsed(
    from: "let value: Box<[Int]>"
  )
  let declGroups: [any DeclGroupSyntax] = [
    publicActor,
    genericEnum,
    genericClass,
    simpleStruct
  ]
  
  #expect(simpleStruct.genericParameterClause?.parameters.simpleGenericParameterNames == ["T", "U"])
  #expect(packStruct.genericParameterClause?.parameters.simpleGenericParameterNames == nil)
  #expect(simpleArguments.arguments.simpleGenericParameterNames == ["Int", "String"])
  #expect(nonSimpleArguments.arguments.simpleGenericParameterNames == nil)
  #expect(declGroups.map(\.visibilityLevel) == [.public, nil, nil, nil])
  #expect(declGroups.map(\.inlinabilityDisposition) == [.inlinable, nil, nil, nil])
  #expect(declGroups.compactMap(\.simpleGenericParameterNames) == [["State"], ["Value"], ["Element"], ["T", "U"]])
}

@Test("Enum case syntax helpers")
func testEnumCaseSyntaxHelpers() throws {
  // Hand-written examples: single payload-free cases expose their identifier,
  // while payload or multi-case declarations are not treated as simple cases.
  let sourceFile = try SourceFileSyntax.onlyParsed(
    from: """
    enum Choice {
      @available(macOS 14.0, *)
      case first
      case second(Int)
      case third, fourth
    }
    """
  )
  let cases = sourceFile.allSyntaxElements(ofType: EnumCaseDeclSyntax.self)
  let first = try #require(cases.first)
  let second = try #require(cases.dropFirst().first)
  let multi = try #require(cases.dropFirst(2).first)
  let emptyElements = EnumCaseElementListSyntax([])
  
  #expect(first.isSimpleCaseWithoutPayload)
  #expect(first.primarySourceCodeIdentifier?.text == "first")
  #expect(first.hasAttribute(named: "available"))
  #expect(!second.isSimpleCaseWithoutPayload)
  #expect(second.primarySourceCodeIdentifier?.text == "second")
  #expect(!multi.isSimpleCaseWithoutPayload)
  #expect(multi.primarySourceCodeIdentifier == nil)
  #expect(!emptyElements.isSimpleCaseWithoutPayload)
  #expect(emptyElements.primarySourceCodeIdentifier == nil)
}

@Test("Enum declaration case helpers filter and quantify cases")
func testEnumDeclarationCaseHelpersFilterAndQuantifyCases() throws {
  // Property-style test: enum-level helpers should agree with the equivalent
  // standard-library operations over parsed case declarations.
  let simpleEnum = try EnumDeclSyntax.onlyParsed(from: "enum Choice { case first; case second }")
  let mixedEnum = try EnumDeclSyntax.onlyParsed(from: "enum Choice { case first; case second(Int) }")
  
  for enumDecl in [simpleEnum, mixedEnum] {
    let cases = Array(enumDecl.memberBlock.allDeclarations(ofType: EnumCaseDeclSyntax.self))
    
    #expect(enumDecl.allCasesAreSimpleWithoutPayload == cases.allSatisfy(\.isSimpleCaseWithoutPayload))
    #expect(
      Array(enumDecl.allCaseDeclarationsSatisfying(\.isSimpleCaseWithoutPayload)).map(\.description)
      ==
      cases.filter(\.isSimpleCaseWithoutPayload).map(\.description)
    )
  }
}

@Test("Member access syntax helpers")
func testMemberAccessSyntaxHelpers() throws {
  // Hand-written examples: `.none` is recognized only as an argumentless member
  // access named `none`, and type-level property access allows omitted bases or
  // a base matching the requested type name.
  let none = try MemberAccessExprSyntax.onlyParsed(from: "let value = Optional<Int>.none")
  let implicit = try MemberAccessExprSyntax.onlyParsed(from: "let value = .value")
  let matching = try MemberAccessExprSyntax.onlyParsed(from: "let value = Int.value")
  let mismatching = try MemberAccessExprSyntax.onlyParsed(from: "let value = String.value")
  let callBase = try MemberAccessExprSyntax.onlyParsed(from: "let value = Int().value")
  let methodReference = try MemberAccessExprSyntax.onlyParsed(from: "let value = Int.method(label:)")
  let argumentNameBase = try MemberAccessExprSyntax.onlyParsed(from: "let value = method(label:).value")
  let keywordBase = try MemberAccessExprSyntax.onlyParsed(from: "let value = Self.value")
  let selfAccess = try MemberAccessExprSyntax.onlyParsed(from: "let value = Int.self")
  
  #expect(none.isExplicitNone)
  #expect(implicit.isCompatibleWithTypeLevelPropertyAccess(forBaseType: Int.self))
  #expect(matching.isCompatibleWithTypeLevelPropertyAccess(forBaseType: Int.self))
  #expect(!mismatching.isCompatibleWithTypeLevelPropertyAccess(forBaseType: Int.self))
  #expect(!callBase.isCompatibleWithTypeLevelPropertyAccess(forBaseType: Int.self))
  #expect(methodReference.isCompatibleWithTypeLevelPropertyAccess(forBaseType: Int.self))
  #expect(!argumentNameBase.isCompatibleWithTypeLevelPropertyAccess(forBaseType: Int.self))
  #expect(!keywordBase.isCompatibleWithTypeLevelPropertyAccess(forBaseType: Int.self))
  #expect(!selfAccess.isExplicitNone)
}

@Test("Member access syntax helpers match accepted base-name sets")
func testMemberAccessSyntaxHelpersMatchAcceptedBaseNameSets() throws {
  // Property-style test: the set-based overload must accept exactly omitted
  // bases or bases whose identifier appears in the accepted-name set.
  let acceptedNames: Set<String> = ["Int"]
  let samples: [(String, Bool)] = [
    ("let value = .value", true),
    ("let value = Int.value", true),
    ("let value = String.value", false),
    ("let value = Int().value", false),
    ("let value = method(label:).value", false),
    ("let value = Self.value", false)
  ]
  
  for (source, expected) in samples {
    let memberAccess = try MemberAccessExprSyntax.onlyParsed(from: source)
    #expect(
      memberAccess.isCompatibleWithTypeLevelPropertyAccess(forBaseTypeNames: acceptedNames)
      ==
      expected
    )
  }
}

private func simpleStringLiteral(
  _ segments: [String]
) -> SimpleStringLiteralExprSyntax {
  SimpleStringLiteralExprSyntax(
    openingQuote: .stringQuoteToken(),
    segments: SimpleStringLiteralSegmentListSyntax(
      segments.map {
        StringSegmentSyntax(content: .stringSegment($0))
      }
    ),
    closingQuote: .stringQuoteToken()
  )
}
