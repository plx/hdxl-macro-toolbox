import Foundation
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Testing
@testable import MacroToolbox

@Test("Macro contexts record diagnostics and enforce value requirements")
func testMacroContextsRecordDiagnosticsAndEnforceValueRequirements() throws {
  // Hand-written examples: successful requirements should return the underlying
  // values unchanged, while failed requirements should throw and record one
  // diagnostic through the expansion context.
  let expansionContext = TestMacroExpansionContext()
  let context = RequirementMacroContext(
    macroInvocationNode: AttributeSyntax("@Requirement(value: 1)"),
    expansionContext: expansionContext,
    optionalSelfValue: 7,
    selfSyntax: try ExprSyntax.onlyParsed(from: "1"),
    optionalSelfSyntax: try ExprSyntax.onlyParsed(from: "2")
  )
  let source = RequirementSource(
    optionalInt: 11,
    optionalValues: ["first"],
    values: ["second"],
    optionalSyntax: try ExprSyntax.onlyParsed(from: "3"),
    syntax: try ExprSyntax.onlyParsed(from: "4"),
    optionalAny: "payload"
  )
  
  #expect(try context.requireValue("explicit value") { 5 } == 5)
  #expect(try context.requireValue("optional value") { Optional.some("value") } == "value")
  #expect(try context.requireProperty(\.optionalSelfValue) == 7)
  #expect(try context.requireProperty(\.optionalInt, of: source) == 11)
  #expect(try context.requireNonEmptyProperty(\.optionalValues, of: source) == ["first"])
  #expect(try context.requireNonEmptyProperty(\.values, of: source) == ["second"])
  #expect(try context.requireSyntaxProperty(\.optionalSyntax, of: source, as: IntegerLiteralExprSyntax.self).literal.text == "3")
  #expect(try context.requireSyntaxProperty(\.syntax, of: source, as: IntegerLiteralExprSyntax.self).literal.text == "4")
  #expect(try context.requireSyntaxProperty(\.selfSyntax, as: IntegerLiteralExprSyntax.self).literal.text == "1")
  #expect(try context.requireSyntaxProperty(\.optionalSelfSyntax, as: IntegerLiteralExprSyntax.self).literal.text == "2")
  #expect(try context.requireProperty(\.optionalAny, of: source, as: String.self) == "payload")
  #expect(try context.requireNonEmptyValues([1, 2, 3]) == [1, 2, 3])
  #expect(try context.requireNonNull(Optional("nonnull")) == "nonnull")
  try context.requireCondition("true condition") { true }
  try context.requireThat(true)
  #expect(expansionContext.diagnostics.isEmpty)
  
  let emptySource = RequirementSource(
    optionalInt: nil,
    optionalValues: [],
    values: [],
    optionalSyntax: nil,
    syntax: try ExprSyntax.onlyParsed(from: "\"wrong\""),
    optionalAny: 1
  )
  let wrongSyntaxSource = RequirementSource(
    optionalInt: nil,
    optionalValues: nil,
    values: [],
    optionalSyntax: try ExprSyntax.onlyParsed(from: "\"wrong\""),
    syntax: try ExprSyntax.onlyParsed(from: "\"wrong\""),
    optionalAny: 1
  )
  let nilAnySource = RequirementSource(
    optionalInt: nil,
    optionalValues: nil,
    values: [],
    optionalSyntax: nil,
    syntax: try ExprSyntax.onlyParsed(from: "1"),
    optionalAny: nil
  )
  let wrongSelfContext = RequirementMacroContext(
    macroInvocationNode: AttributeSyntax("@Requirement"),
    expansionContext: expansionContext,
    optionalSelfValue: nil,
    selfSyntax: try ExprSyntax.onlyParsed(from: "\"wrong\""),
    optionalSelfSyntax: try ExprSyntax.onlyParsed(from: "\"wrong\"")
  )
  let failureOperations: [() throws -> Void] = [
    { _ = try context.requireValue("throwing value") { throw ExampleMacroError(label: "plain") } },
    { _ = try context.requireValue("throwing optional") { () throws -> Int? in
      throw ExampleMacroError(label: "optional")
    } },
    { _ = try context.requireValue("missing optional") { Optional<Int>.none } },
    { _ = try wrongSelfContext.requireProperty(\.optionalSelfValue) },
    { _ = try context.requireProperty(\.optionalInt, of: emptySource) },
    { _ = try context.requireNonEmptyProperty(\.optionalValues, of: wrongSyntaxSource) },
    { _ = try context.requireNonEmptyProperty(\.optionalValues, of: emptySource) },
    { _ = try context.requireNonEmptyProperty(\.values, of: emptySource) },
    { _ = try context.requireSyntaxProperty(\.optionalSyntax, of: emptySource, as: IntegerLiteralExprSyntax.self) },
    { _ = try context.requireSyntaxProperty(\.optionalSyntax, of: wrongSyntaxSource, as: IntegerLiteralExprSyntax.self) },
    { _ = try context.requireSyntaxProperty(\.syntax, of: wrongSyntaxSource, as: IntegerLiteralExprSyntax.self) },
    { _ = try wrongSelfContext.requireSyntaxProperty(\.selfSyntax, as: IntegerLiteralExprSyntax.self) },
    { _ = try RequirementMacroContext(
      macroInvocationNode: AttributeSyntax("@Requirement"),
      expansionContext: expansionContext,
      optionalSelfValue: nil,
      selfSyntax: try ExprSyntax.onlyParsed(from: "1"),
      optionalSelfSyntax: nil
    ).requireSyntaxProperty(\.optionalSelfSyntax, as: IntegerLiteralExprSyntax.self) },
    { _ = try wrongSelfContext.requireSyntaxProperty(\.optionalSelfSyntax, as: IntegerLiteralExprSyntax.self) },
    { _ = try context.requireProperty(\.optionalAny, of: nilAnySource, as: String.self) },
    { _ = try context.requireProperty(\.optionalAny, of: emptySource, as: String.self) },
    { try context.requireCondition("false condition") { false } },
    { try context.requireCondition("throwing condition") { throw ExampleMacroError(label: "condition") } },
    { try context.requireThat(false) },
    { _ = try context.requireNonEmptyValues([Int]()) },
    { _ = try context.requireNonNull(Optional<Int>.none) }
  ]
  
  for operation in failureOperations {
    expectMacroExpansionFailure(operation)
  }
  #expect(expansionContext.diagnostics.count == failureOperations.count)
  #expect(expansionContext.diagnostics.allSatisfy { $0.diagMessage.severity == .error })
}

@Test("Macro context diagnostic recording helpers preserve severity and defaults")
func testMacroContextDiagnosticRecordingHelpersPreserveSeverityAndDefaults() throws {
  // Property-style test: each severity convenience should delegate to the generic
  // recorder with the same domain, message ID, fallback attribution node, and
  // optional subject node.
  let expansionContext = TestMacroExpansionContext()
  let context = RequirementMacroContext(
    macroInvocationNode: AttributeSyntax("@Requirement"),
    expansionContext: expansionContext
  )
  let subjectNode = try ExprSyntax.onlyParsed(from: "value")
  
  context.recordDiagnostic(
    severity: .error,
    messageIdentifier: "generic",
    explanation: "generic message",
    subjectNode: subjectNode
  )
  context.recordError(messageIdentifier: "error", explanation: "error message")
  context.recordWarning(messageIdentifier: "warning", explanation: "warning message")
  context.recordNote(messageIdentifier: "note", explanation: "note message")
  context.recordRemark(messageIdentifier: "remark", explanation: "remark message")
  
  #expect(expansionContext.diagnostics.map(\.diagMessage.severity) == [.error, .error, .warning, .note, .remark])
  #expect(expansionContext.diagnostics.map(\.diagnosticID) == [
    MessageID(domain: "RequirementDomain", id: "generic"),
    MessageID(domain: "RequirementDomain", id: "error"),
    MessageID(domain: "RequirementDomain", id: "warning"),
    MessageID(domain: "RequirementDomain", id: "note"),
    MessageID(domain: "RequirementDomain", id: "remark")
  ])
  #expect(expansionContext.diagnostics[0].node.trimmedDescription == "@Requirement")
  #expect(expansionContext.diagnostics[0].position == subjectNode.positionAfterSkippingLeadingTrivia)
  #expect(expansionContext.diagnostics[1].node.trimmedDescription == "@Requirement")
  
  expectMacroExpansionFailure {
    try context.withAutomaticRecordingForRequiredOperation(
      messageIdentifier: "automatic",
      explanation: "automatic failure",
      attributionNode: subjectNode,
      subjectNode: subjectNode
    ) {
      throw MacroExpansionFailure(explanation: "inner")
    }
  }
  #expect(expansionContext.diagnostics.last?.diagnosticID == MessageID(domain: "RequirementDomain", id: "automatic"))
  #expect(expansionContext.diagnostics.last?.node.trimmedDescription == "value")
}

@Test("Attached macro contexts expose invocation, declaration, and member helpers")
func testAttachedMacroContextsExposeInvocationDeclarationAndMemberHelpers() throws {
  // Hand-written examples: attached context structs should preserve their captured
  // inputs, derive invocation arguments from attribute syntax, and re-use the
  // generic requirement helpers for declaration and member re-interpretation.
  let expansionContext = TestMacroExpansionContext()
  let attribute = AttributeSyntax("@Example(value: 1)")
  let plainAttribute = AttributeSyntax("@Example")
  let structDecl = try StructDeclSyntax.onlyParsed(from: "@inlinable public struct Box<T> { var value: T }")
  let internalStructDecl = try StructDeclSyntax.onlyParsed(from: "struct InternalBox { var value: Int }")
  let variableDecl = try VariableDeclSyntax.onlyParsed(from: "var value: Int")
  let unsupportedDecl = try #require(
    UnsupportedDeclSyntax(try ExprSyntax.onlyParsed(from: "1"))
  )
  let memberContext = MemberMacroContext(
    macroInvocationNode: attribute,
    declaration: structDecl,
    conformedProtocols: [TypeSyntax(IdentifierTypeSyntax.forType(named: "Sendable"))],
    expansionContext: expansionContext,
    diagnosticDomainIdentifier: "AttachedDomain"
  )
  let internalMemberContext = MemberMacroContext(
    macroInvocationNode: plainAttribute,
    declaration: internalStructDecl,
    conformedProtocols: [],
    expansionContext: expansionContext,
    diagnosticDomainIdentifier: "AttachedDomain"
  )
  let peerContext = PeerMacroContext(
    macroInvocationNode: plainAttribute,
    declaration: variableDecl,
    expansionContext: expansionContext,
    diagnosticDomainIdentifier: "AttachedDomain"
  )
  let unsupportedPeerContext = PeerMacroContext(
    macroInvocationNode: plainAttribute,
    declaration: unsupportedDecl,
    expansionContext: expansionContext,
    diagnosticDomainIdentifier: "AttachedDomain"
  )
  let memberAttributeContext = MemberAttributeMacroContext(
    macroInvocationNode: attribute,
    declaration: structDecl,
    member: variableDecl,
    expansionContext: expansionContext,
    diagnosticDomainIdentifier: "AttachedDomain"
  )
  let typeMemberAttributeContext = MemberAttributeMacroContext(
    macroInvocationNode: attribute,
    declaration: structDecl,
    member: structDecl,
    expansionContext: expansionContext,
    diagnosticDomainIdentifier: "AttachedDomain"
  )
  let unsupportedMemberAttributeContext = MemberAttributeMacroContext(
    macroInvocationNode: attribute,
    declaration: structDecl,
    member: unsupportedDecl,
    expansionContext: expansionContext,
    diagnosticDomainIdentifier: "AttachedDomain"
  )
  
  #expect(memberContext.invocationArgumentsAsLabeledExpressionList?.count == 1)
  #expect(peerContext.invocationArgumentsAsLabeledExpressionList == nil)
  #expect(memberContext.syntaxNodeForAttribution.trimmedDescription == "@Example(value: 1)")
  #expect(memberContext.syntaxNodeForPositioning.trimmedDescription == "@Example(value: 1)")
  #expect(memberContext.explicitVisibilityLevel == .public)
  #expect(memberContext.visibilityLevel == .public)
  #expect(internalMemberContext.explicitVisibilityLevel == nil)
  #expect(internalMemberContext.visibilityLevel == .internal)
  #expect(memberContext.inlinabilityDisposition == .inlinable)
  #expect(memberContext.functionOrMethodGenerationDetails.0 == .public)
  #expect(memberContext.conformedProtocols.map(\.trimmedDescription) == ["Sendable"])
  #expect(try memberContext.requireDeclaration(as: StructDeclSyntax.self).name.text == "Box")
  if case .struct(let concreteStruct) = try memberContext.requireConcreteDeclSyntax() {
    #expect(concreteStruct.name.text == "Box")
  } else {
    Issue.record("Expected a concrete struct declaration")
  }
  #expect(try memberContext.requireConcreteTypeDeclaration().name == "Box")
  if case .variable(let concreteVariable) = try memberAttributeContext.requireMemberAsConcreteDeclSyntax() {
    #expect(concreteVariable.trimmedDescription == "var value: Int")
  } else {
    Issue.record("Expected a concrete variable declaration")
  }
  #expect(try typeMemberAttributeContext.requireMemberAsConcreteTypeDeclaration().name == "Box")
  
  expectMacroExpansionFailure {
    _ = try peerContext.requireDeclaration(as: StructDeclSyntax.self)
  }
  expectMacroExpansionFailure {
    _ = try peerContext.requireConcreteTypeDeclaration()
  }
  expectMacroExpansionFailure {
    _ = try memberAttributeContext.requireMemberAsConcreteTypeDeclaration()
  }
  expectMacroExpansionFailure {
    try peerContext.requireSatisfactoryAttachment(attachmentRequirement: .exactly(.struct))
  }
  expectMacroExpansionFailure {
    try unsupportedPeerContext.requireSatisfactoryAttachment(
      attachmentRequirement: .exactly(.struct)
    )
  }
  expectMacroExpansionFailure {
    _ = try unsupportedPeerContext.requireConcreteDeclSyntax()
  }
  expectMacroExpansionFailure {
    _ = try unsupportedMemberAttributeContext.requireMemberAsConcreteDeclSyntax()
  }
  #expect(expansionContext.diagnostics.count == 7)
  #expect(expansionContext.diagnostics.map(\.diagnosticID) == [
    MessageID(domain: "AttachedDomain", id: .declarationOfIncorrectType),
    MessageID(domain: "AttachedDomain", id: .declarationOfIncorrectType),
    MessageID(domain: "AttachedDomain", id: .declarationOfIncorrectType),
    MessageID(domain: "AttachedDomain", id: .attachedToExcludedArchetype),
    MessageID(domain: "AttachedDomain", id: .requiredPropertyWasNil),
    MessageID(domain: "AttachedDomain", id: .declarationOfIncorrectType),
    MessageID(domain: "AttachedDomain", id: .declarationOfIncorrectType)
  ])
}

@Test("Contextualized attached macro expansions validate and delegate")
func testContextualizedAttachedMacroExpansionsValidateAndDelegate() throws {
  // Property-style test: each attached macro role should create the expected context,
  // run the default validators, and return the syntax emitted by the contextualized
  // implementation.
  let expansionContext = TestMacroExpansionContext()
  let attribute = AttributeSyntax("@Default")
  let variableDecl = try VariableDeclSyntax.onlyParsed(from: "var value: Int")
  let functionDecl = try FunctionDeclSyntax.onlyParsed(from: "func value() -> Int { 1 }")
  let structDecl = try StructDeclSyntax.onlyParsed(from: "struct Box { var value: Int }")
  
  let accessors = try DefaultAccessorMacro.expansion(
    of: attribute,
    providingAccessorsOf: variableDecl,
    in: expansionContext
  )
  let body = try DefaultBodyMacro.expansion(
    of: attribute,
    providingBodyFor: functionDecl,
    in: expansionContext
  )
  let members = try DefaultMemberMacro.expansion(
    of: attribute,
    providingMembersOf: structDecl,
    conformingTo: [],
    in: expansionContext
  )
  let attributes = try DefaultMemberAttributeMacro.expansion(
    of: attribute,
    attachedTo: structDecl,
    providingAttributesFor: variableDecl,
    in: expansionContext
  )
  let peers = try DefaultPeerMacro.expansion(
    of: attribute,
    providingPeersOf: variableDecl,
    in: expansionContext
  )
  let markerPeers = try DefaultMarkerMacro.expansion(
    of: attribute,
    providingPeersOf: variableDecl,
    in: expansionContext
  )
  
  #expect(accessors.map(\.trimmedDescription) == ["get { value }"])
  #expect(body.map(\.trimmedDescription) == ["return 1"])
  #expect(members.map(\.trimmedDescription) == ["var generatedMember: Int"])
  #expect(attributes.map(\.trimmedDescription) == ["@usableFromInline"])
  #expect(peers.map(\.trimmedDescription) == ["typealias GeneratedPeer = Int"])
  #expect(markerPeers.isEmpty)
  #expect(DefaultDiagnosticMacro.diagnosticDomainIdentifier.contains("DefaultDiagnosticMacro"))
  #expect(DefaultTypeAttachedMacro.typeAttachmentRequirement.isCompatible(with: .struct))
  #expect(DefaultTypeAttachedMacro.attachmentRequirement.isCompatible(with: .struct))
  #expect(!ProtocolIncompatibleMacro.typeAttachmentRequirement.isCompatible(with: .protocol))
  
  try DefaultPeerMacro.validateMacroInvocationName("Anything")
  try DefaultPeerMacro.validateAttachedTypeName("Anything")
  try RegexPeerMacro.validateMacroInvocationName("Allowed")
  try RegexPeerMacro.validateAttachedTypeName("Box")
  #expect(throws: ContextualizedAttachedMacroValidationError.self) {
    try RegexPeerMacro.validateMacroInvocationName("Denied")
  }
  #expect(throws: ContextualizedAttachedMacroValidationError.self) {
    try RegexPeerMacro.validateAttachedTypeName("Other")
  }
}

@Test("Freestanding macro contexts and expansions preserve invocation arguments")
func testFreestandingMacroContextsAndExpansionsPreserveInvocationArguments() throws {
  // Hand-written examples: freestanding expression and declaration macros should
  // expose their invocation arguments through the generated contexts and delegate
  // expansion to the contextualized implementation.
  let expansionContext = TestMacroExpansionContext()
  let expressionInvocation = try MacroExpansionExprSyntax.onlyParsed(from: "#makeExpression(1, label: 2)")
  let declarationInvocation = try MacroExpansionDeclSyntax("#makeDeclaration(label: 3)")
  let expressionContext = ExpressionMacroContext(
    macroInvocationNode: expressionInvocation,
    expansionContext: expansionContext,
    diagnosticDomainIdentifier: "FreestandingDomain"
  )
  
  let expression = try DefaultExpressionMacro.expansion(
    of: expressionInvocation,
    in: expansionContext
  )
  let declarations = try DefaultDeclarationMacro.expansion(
    of: declarationInvocation,
    in: expansionContext
  )
  
  #expect(expressionContext.invocationArgumentsAsLabeledExpressionList?.count == 2)
  #expect(expression.trimmedDescription == "42")
  #expect(declarations.map(\.trimmedDescription) == ["struct GeneratedDeclaration {}"])
}

@Test("Conditional and unconditional conformance macros render expected extensions")
func testConditionalAndUnconditionalConformanceMacrosRenderExpectedExtensions() throws {
  // Property-style test: conformance macro helpers should combine generic parameters,
  // implicit parameters, inheritance clauses, where clauses, and member blocks into
  // the same extension syntax that the public expansion entry points return.
  let expansionContext = TestMacroExpansionContext()
  let attribute = AttributeSyntax("@NeedsSendable")
  let baseElementAttribute = AttributeSyntax("@NeedsBaseElement")
  let structDecl = try StructDeclSyntax.onlyParsed(from: "public struct Box<T> {}")
  let baseStructDecl = try StructDeclSyntax.onlyParsed(from: "struct Wrapper<Base> {}")
  let nonGenericStructDecl = try StructDeclSyntax.onlyParsed(from: "struct Plain {}")
  let type = IdentifierTypeSyntax.forType(named: "Box")
  let sequenceType = IdentifierTypeSyntax.forType(named: "WrapperSequence")
  let conditionalContext = ExtensionMacroContext(
    macroInvocationNode: attribute,
    declaration: structDecl,
    extendedType: type,
    conformedProtocols: [],
    expansionContext: expansionContext,
    diagnosticDomainIdentifier: "ConditionalDomain"
  )
  let baseElementContext = ExtensionMacroContext(
    macroInvocationNode: baseElementAttribute,
    declaration: baseStructDecl,
    extendedType: sequenceType,
    conformedProtocols: [],
    expansionContext: expansionContext,
    diagnosticDomainIdentifier: "ConditionalDomain"
  )
  let nonGenericContext = ExtensionMacroContext(
    macroInvocationNode: attribute,
    declaration: nonGenericStructDecl,
    extendedType: type,
    conformedProtocols: [],
    expansionContext: expansionContext,
    diagnosticDomainIdentifier: "ConditionalDomain"
  )
  let parameters = AllOrNoneConditionalConformanceParameters(
    genericParameterNames: ["T"],
    additionalImplicitParameterNames: ["T.Element"],
    visibilityLevel: .public,
    typeInlinabilityDisposition: .inlinable,
    methodInlinabilityDisposition: .usableFromInline
  )
  
  #expect(TestConditionalConformanceMacro.requiredProtocolNames == ["Sendable"])
  #expect(TestConditionalConformanceMacro.conformedProtocolNames == ["Sendable"])
  #expect(TestConditionalConformanceMacro.additionalImplicitGenericParameterNames.isEmpty)
  #expect(parameters.allGenericParameterNames == ["T", "T.Element"])
  #expect(parameters.description.contains("all-or-none-conformance"))
  #expect(parameters.debugDescription.contains("AllOrNoneConditionalConformanceParameters"))
  #expect(Set([parameters, parameters]).count == 1)
  #expect(try JSONDecoder().decode(
    AllOrNoneConditionalConformanceParameters.self,
    from: JSONEncoder().encode(parameters)
  ) == parameters)
  #expect(try TestConditionalConformanceMacro.genericParameterNames(in: conditionalContext) == ["T"])
  #expect(try TestConditionalConformanceMacro.additionalImplicitGenericParameterNames(
    in: baseElementContext,
    genericParameterNames: ["Base"]
  ) == ["Base.Element"])
  #expect(try TestConditionalConformanceMacro.additionalImplicitGenericParameterNames(
    in: conditionalContext,
    genericParameterNames: ["T"]
  ).isEmpty)
  expectMacroExpansionFailure {
    _ = try TestConditionalConformanceMacro.genericParameterNames(
      in: nonGenericContext
    )
  }
  #expect(try TestConditionalConformanceMacro.conditionalConformanceInheritanceClause(
    in: conditionalContext,
    parameters: parameters
  ).trimmedDescription == ": Sendable")
  #expect(try TestConditionalConformanceMacro.conditionalConformanceRequirementsClause(
    in: conditionalContext,
    parameters: parameters
  ).trimmedDescription == "where T: Sendable, T.Element: Sendable")
  #expect(try TestConditionalConformanceMacro.conditionalConformanceDeclarations(
    in: conditionalContext,
    parameters: parameters
  ).isEmpty)
  
  let conditionalExtensions = try TestConditionalConformanceMacro.expansion(
    of: attribute,
    attachedTo: structDecl,
    providingExtensionsOf: type,
    conformingTo: [],
    in: expansionContext
  )
  let unconditionalExtensions = try TestUnconditionalConformanceMacro.expansion(
    of: attribute,
    attachedTo: structDecl,
    providingExtensionsOf: type,
    conformingTo: [],
    in: expansionContext
  )
  
  #expect(conditionalExtensions.map(\.trimmedDescription) == [
    "extension Box: Sendable where T: Sendable {}"
  ])
  #expect(TestUnconditionalConformanceMacro.conformedProtocolNames == ["Codable"])
  #expect(try TestUnconditionalConformanceMacro.unconditionalInheritanceClause(in: conditionalContext).trimmedDescription == ": Codable")
  #expect(try TestUnconditionalConformanceMacro.conditionalConformanceDeclarations(in: conditionalContext).isEmpty)
  #expect(unconditionalExtensions.map(\.trimmedDescription) == [
    "extension Box: Codable {}"
  ])
  
  expectMacroExpansionFailure {
    _ = try TestConditionalConformanceMacro.conditionalConformanceRequirementsClause(
      in: conditionalContext,
      parameters: AllOrNoneConditionalConformanceParameters(
        genericParameterNames: [],
        additionalImplicitParameterNames: [],
        visibilityLevel: .internal
      )
    )
  }
  expectMacroExpansionFailure {
    _ = try EmptyRequiredProtocolConditionalConformanceMacro.conditionalConformanceRequirementsClause(
      in: conditionalContext,
      parameters: AllOrNoneConditionalConformanceParameters(
        genericParameterNames: ["T"],
        additionalImplicitParameterNames: [],
        visibilityLevel: .internal
      )
    )
  }
}

private struct RequirementMacroContext: MacroContextProtocol {
  var macroInvocationNode: AttributeSyntax
  var expansionContext: TestMacroExpansionContext
  var optionalSelfValue: Int?
  var selfSyntax: ExprSyntax
  var optionalSelfSyntax: ExprSyntax?
  var diagnosticDomainIdentifier: String = "RequirementDomain"
  
  init(
    macroInvocationNode: AttributeSyntax,
    expansionContext: TestMacroExpansionContext,
    optionalSelfValue: Int? = nil,
    selfSyntax: ExprSyntax = ExprSyntax(IntegerLiteralExprSyntax(literal: .integerLiteral("0"))),
    optionalSelfSyntax: ExprSyntax? = nil
  ) {
    self.macroInvocationNode = macroInvocationNode
    self.expansionContext = expansionContext
    self.optionalSelfValue = optionalSelfValue
    self.selfSyntax = selfSyntax
    self.optionalSelfSyntax = optionalSelfSyntax
  }
  
  var invocationArgumentsAsLabeledExpressionList: LabeledExprListSyntax? {
    nil
  }
}

private struct RequirementSource: CustomStringConvertible {
  var optionalInt: Int?
  var optionalValues: [String]?
  var values: [String]
  var optionalSyntax: ExprSyntax?
  var syntax: ExprSyntax
  var optionalAny: Any?
  
  var description: String {
    "RequirementSource"
  }
}

private final class TestMacroExpansionContext: MacroExpansionContext {
  var diagnostics: [Diagnostic] = []
  var locationRequests: [(position: PositionInSyntaxNode, filePathMode: SourceLocationFilePathMode)] = []
  var lexicalContext: [Syntax] = []
  
  func makeUniqueName(_ name: String) -> TokenSyntax {
    .identifier("__\(name)")
  }
  
  func diagnose(_ diagnostic: Diagnostic) {
    diagnostics.append(diagnostic)
  }
  
  func location(
    of node: some SyntaxProtocol,
    at position: PositionInSyntaxNode,
    filePathMode: SourceLocationFilePathMode
  ) -> AbstractSourceLocation? {
    locationRequests.append((position, filePathMode))
    
    return AbstractSourceLocation(
      SourceLocation(
        line: locationRequests.count,
        column: 1,
        offset: locationRequests.count,
        file: "MacroProtocolSupportTests.swift"
      )
    )
  }
}

private struct ExampleMacroError: Error {
  var label: String
}

private struct UnsupportedDeclSyntax: DeclSyntaxProtocol {
  let _syntaxNode: Syntax
  
  init?(_ node: __shared some SyntaxProtocol) {
    _syntaxNode = Syntax(node)
  }
  
  static var structure: SyntaxNodeStructure {
    .layout([])
  }
}

private func expectMacroExpansionFailure(
  _ operation: () throws -> Void,
  sourceLocation: Testing.SourceLocation = #_sourceLocation
) {
  do {
    try operation()
    Issue.record("Expected MacroExpansionFailure", sourceLocation: sourceLocation)
  } catch is MacroExpansionFailure {
  } catch {
    Issue.record("Expected MacroExpansionFailure, got \(error)", sourceLocation: sourceLocation)
  }
}

private enum DefaultDiagnosticMacro: DiagnosticDomainAwareMacro {}

private enum DefaultTypeAttachedMacro: ContextualizedTypeAttachedMacro {
  static func validateMacroInvocationNode(_ attributeSyntax: AttributeSyntax) throws {}
  static func validateMacroInvocationName(_ macroInvocationName: String) throws {}
  static func validateAttachedTypeName(_ attachedTypeName: String) throws {}
  static func validateDeclarationArchetype(for attachmentContext: some AttachedMacroContextProtocol) throws {}
  static func validateDeclarationDetails(for attachmentContext: some AttachedMacroContextProtocol) throws {}
}

private enum ProtocolIncompatibleMacro: ProtocolIncompatibleContextualizedTypeAttachedMacro {
  static func validateMacroInvocationNode(_ attributeSyntax: AttributeSyntax) throws {}
  static func validateMacroInvocationName(_ macroInvocationName: String) throws {}
  static func validateAttachedTypeName(_ attachedTypeName: String) throws {}
  static func validateDeclarationArchetype(for attachmentContext: some AttachedMacroContextProtocol) throws {}
  static func validateDeclarationDetails(for attachmentContext: some AttachedMacroContextProtocol) throws {}
}

private enum DefaultAccessorMacro: ContextualizedAccessorMacro {
  static func contextualizedExpansion(
    in attachmentContext: some AccessorMacroContextProtocol
  ) throws -> [AccessorDeclSyntax] {
    _ = try attachmentContext.requireDeclaration(as: VariableDeclSyntax.self)
    return [AccessorDeclSyntax("get { value }")]
  }
}

private enum DefaultBodyMacro: ContextualizedBodyMacro {
  static func contextualizedExpansion(
    in attachmentContext: some BodyMacroContextProtocol
  ) throws -> [CodeBlockItemSyntax] {
    _ = attachmentContext.declaration.body
    return [CodeBlockItemSyntax("return 1")]
  }
}

private enum DefaultMemberMacro: ContextualizedMemberMacro {
  static func contextualizedExpansion(
    in attachmentContext: some MemberMacroContextProtocol
  ) throws -> [DeclSyntax] {
    _ = attachmentContext.conformedProtocols
    return [DeclSyntax(try VariableDeclSyntax("var generatedMember: Int"))]
  }
}

private enum DefaultMemberAttributeMacro: ContextualizedMemberAttributeMacro {
  static func contextualizedExpansion(
    in attachmentContext: some MemberAttributeMacroContextProtocol
  ) throws -> [AttributeSyntax] {
    _ = try attachmentContext.requireMemberAsConcreteDeclSyntax()
    return [AttributeSyntax("@usableFromInline")]
  }
}

private enum DefaultPeerMacro: ContextualizedPeerMacro {
  static func contextualizedExpansion(
    in attachmentContext: some PeerMacroContextProtocol
  ) throws -> [DeclSyntax] {
    _ = attachmentContext.declaration
    return [DeclSyntax(try TypeAliasDeclSyntax("typealias GeneratedPeer = Int"))]
  }
}

private enum RegexPeerMacro: ContextualizedPeerMacro {
  static var macroInvocationNameRegex: Regex<Substring>? { /^Allowed$/ }
  static var attachedTypeNameRegex: Regex<Substring>? { /^Box$/ }
  
  static func contextualizedExpansion(
    in attachmentContext: some PeerMacroContextProtocol
  ) throws -> [DeclSyntax] {
    []
  }
}

private enum DefaultMarkerMacro: MarkerMacroProtocol {}

private enum DefaultExpressionMacro: ContextualizedExpressionMacro {
  static func contextualizedExpansion(
    in attachmentContext: some ExpressionMacroContextProtocol
  ) throws -> ExprSyntax {
    #expect(attachmentContext.invocationArgumentsAsLabeledExpressionList?.count == 2)
    return ExprSyntax(IntegerLiteralExprSyntax(literal: .integerLiteral("42")))
  }
}

private enum DefaultDeclarationMacro: ContextualizedDeclarationMacro {
  static func validateFreestandingContext(
    _ expansionContext: some DeclarationMacroContextProtocol
  ) throws {
    #expect(expansionContext.invocationArgumentsAsLabeledExpressionList?.count == 1)
  }
  
  static func contextualizedExpansion(
    in attachmentContext: some DeclarationMacroContextProtocol
  ) throws -> [DeclSyntax] {
    [DeclSyntax(try StructDeclSyntax("struct GeneratedDeclaration {}"))]
  }
}

private enum TestConditionalConformanceMacro: SingleProtocolConditionalConformanceMacro {
  static let associatedProtocol = "Sendable"
}

private enum EmptyRequiredProtocolConditionalConformanceMacro: AllOrNoneConditionalConformanceMacro {
  static let requiredProtocolNames: [String] = []
  static let conformedProtocolNames = ["MarkerProtocol"]
}

private enum TestUnconditionalConformanceMacro: SingleProtocolUnconditionalConformanceMacro {
  static let associatedProtocol = "Codable"
}
