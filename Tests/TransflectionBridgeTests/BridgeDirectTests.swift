import BridgeTestModels
import MacroToolboxModels
import MacroToolboxSyntax
import MacroToolbox
import MacroToolboxTransflection
import ValueTransflection
import ExpansionTimeTransflection
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacroExpansion
import SwiftDiagnostics
import Testing

func expression(_ source: String) throws -> ExprSyntax {
  try SyntaxSourceFragment.parse(source, as: ExprSyntax.self)
}
func decodingFailure(_ operation: () throws -> Void) throws -> TransflectionDecodingFailure {
  do { try operation(); Issue.record("Expected a decoding failure") }
  catch let failure as TransflectionDecodingFailure { return failure }
  throw TestFailure()
}
struct TestFailure: Error {}
final class CustomFailure: Error {}
struct FixtureNote: NoteMessage {
  var message: String { "Caller note" }
  var noteID: MessageID { .init(domain: "Fixture", id: "note") }
}
struct FixtureFix: FixItMessage {
  var message: String { "Use the explicitly requested raw-value exposure" }
  var fixItID: MessageID { .init(domain: "Fixture", id: "replacement") }
}
func inputDetails() -> MacroDiagnosticDetails {
  .init(message: "Invalid bridge options", domain: "Fixture", messageID: "options")
}

@Test func sharedVisibilityWitnessIsAvailableWithoutTheBridge() throws {
  for value in VisibilityLevel.allCases {
    let member = TransflectionExpression.member(.init(baseTypeName: nil, memberName: value.sourceCodeStringRepresentation))
    #expect(try VisibilityLevel(transflecting: member) == value)
    let qualified = TransflectionExpression.member(.init(baseTypeName: "MacroToolboxModels.VisibilityLevel", memberName: value.sourceCodeStringRepresentation))
    #expect(try VisibilityLevel(transflecting: qualified) == value)
  }
  for source in [".public()", "Other.VisibilityLevel.public", ".unknown", "42"] {
    _ = try decodingFailure { _ = try TransflectionMacroBridge.decode(expression(source), as: VisibilityLevel.self) }
  }
}

@Test func nestedFailureRetainsOriginalNodeAndCorePath() throws {
  let source = try expression("BridgeOptions(memberVisibility: .public, exposedAPI: [.rawValue, 42])")
  let call = try #require(source.as(FunctionCallExprSyntax.self))
  let array = try #require(call.arguments.last?.expression.as(ArrayExprSyntax.self))
  let bad = try #require(array.elements.last?.expression)
  let failure = try decodingFailure { _ = try TransflectionMacroBridge.decode(source, as: BridgeOptions.self) }
  let location = failure.locatedFailure.source
  #expect(location.isExact)
  #expect(location.anchor?.id == bad.id)
  #expect(location.anchor?.positionAfterSkippingLeadingTrivia == bad.positionAfterSkippingLeadingTrivia)
  #expect(failure.transflectionFailure.path == [
    .constructorArgument(typeName: "BridgeOptions", parameter: .init(index: 1, label: "exposedAPI"), sourceIndex: 1),
    .arrayElement(1)
  ])
  let diagnostic = TransflectionMacroBridge.diagnostic(for: failure, details: inputDetails())
  #expect(diagnostic.node.id == bad.id)
  #expect(diagnostic.notes.contains { $0.message.contains("exposedAPI") && $0.message.contains("array element 1") })
}

@Test func omissionsAndUnknownLabelsUseCoreSourceCorrespondence() throws {
  let missing = try expression("BridgeOptions(memberVisibility: .public)")
  let failure = try decodingFailure { _ = try TransflectionMacroBridge.decode(missing, as: BridgeOptions.self) }
  #expect(!failure.locatedFailure.source.isExact)
  let diagnostic = TransflectionMacroBridge.diagnostic(for: failure, details: inputDetails())
  #expect(diagnostic.node.root.id == missing.root.id)
  #expect(diagnostic.notes.contains { $0.message.contains("No source child") })
  let omittedPath = TransflectionPathComponent.constructorArgument(typeName: "BridgeOptions", parameter: .init(index: 1, label: "exposedAPI"), sourceIndex: nil)
  #expect(failure.transflectionFailure.path.contains(omittedPath))

  let unknown = try expression("BridgeOptions(memberVisibility: .public, mystery: [])")
  let call = try #require(unknown.as(FunctionCallExprSyntax.self))
  let label = try #require(call.arguments.last?.label)
  let badLabel = try decodingFailure { _ = try TransflectionMacroBridge.decode(unknown, as: BridgeOptions.self) }
  #expect(badLabel.locatedFailure.source.isExact)
  #expect(badLabel.locatedFailure.source.anchor?.id == label.id)

  let noArguments = AttributeSyntax("@Fixture")
  let missingMacro = try decodingFailure { _ = try TransflectionMacroBridge.decodeArgument(at: 0, in: noArguments, as: BridgeOptions.self) }
  #expect(missingMacro.sourceRoot.id == noArguments.id)
}

@Test func terminalBoundaryPreservesAllCallerMetadataAndWarningSeverity() throws {
  let source = try expression("[42]")
  let array = try #require(source.as(ArrayExprSyntax.self))
  let bad = try #require(array.elements.first?.expression)
  let replacement = try expression(".rawValue")
  // The caller explicitly requests this known supported replacement; no spelling guess is made.
  let fix = FixIt(message: FixtureFix(), changes: [.replace(oldNode: Syntax(bad), newNode: Syntax(replacement))])
  let note = Note(node: Syntax(source), position: source.endPositionBeforeTrailingTrivia, message: FixtureNote())
  let position = bad.endPositionBeforeTrailingTrivia
  let details = MacroDiagnosticDetails(message: "Caller warning", domain: "CallerDomain", messageID: "CallerID", severity: .warning,
    position: position, highlights: [Syntax(bad)], notes: [note], fixIts: [fix])
  let context = BasicMacroExpansionContext()
  let value: [Exposure] = TransflectionMacroBridge.withDiagnostics(in: context, at: source, details: details, failureValue: []) {
    try TransflectionMacroBridge.decode(source, as: [Exposure].self)
  }
  #expect(value.isEmpty)
  #expect(context.diagnostics.count == 1)
  let diagnostic = try #require(context.diagnostics.first)
  #expect(diagnostic.node.id == bad.id)
  #expect(diagnostic.position == position)
  #expect(diagnostic.diagMessage.severity == .warning)
  #expect(diagnostic.diagnosticID == MessageID(domain: "CallerDomain", id: "CallerID"))
  #expect(diagnostic.highlights.map(\.id) == [bad.id])
  #expect(diagnostic.notes.first?.node.id == note.node.id)
  #expect(diagnostic.notes.first?.position == note.position)
  #expect(diagnostic.notes.first?.message == note.message)
  let change = try #require(diagnostic.fixIts.first?.changes.first)
  guard case .replace(let old, let new) = change else { Issue.record("Expected replacement"); return }
  #expect(old.id == bad.id)
  #expect(old.position..<old.endPosition == bad.position..<bad.endPosition)
  #expect(new.trimmedDescription == ".rawValue")
}

@Test func asymmetricDecoderIsExplicitAndRetainsItsCause() throws {
  let source = try expression("makeOptions()")
  let normal = try decodingFailure { _ = try TransflectionMacroBridge.decode(source, as: BridgeOptions.self) }
  #expect(normal.sourceRoot.id == source.id)
  var customCalls = 0
  let cause = CustomFailure()
  let custom = try decodingFailure {
    let _: BridgeOptions = try TransflectionMacroBridge.decodeAsymmetrically(source) { _ in
      customCalls += 1; throw cause
    }
  }
  #expect(customCalls == 1)
  #expect(custom.transflectionFailure.reason as? CustomFailure === cause)
  #expect(custom.locatedFailure.source.anchor?.id == source.id)
  let context = BasicMacroExpansionContext()
  let _: Int = TransflectionMacroBridge.withDiagnostics(in: context, at: source, details: inputDetails(), failureValue: 0) { throw custom }
  #expect(context.diagnostics.count == 1)
  #expect(context.diagnostics.first?.diagnosticID == MessageID(domain: "Fixture", id: "options"))
}

@Test func unexpectedFailuresHaveDistinctDiagnosticsAndRetainDebugCause() throws {
  let source = try expression(".public")
  let cause = CustomFailure()
  var debugError: (any Error)?
  let context = BasicMacroExpansionContext()
  let result = TransflectionMacroBridge.withDiagnostics(in: context, at: source, details: inputDetails(), failureValue: false,
    debugUnexpectedError: { debugError = $0 }) { throw cause }
  #expect(!result)
  #expect(debugError as? CustomFailure === cause)
  #expect(context.diagnostics.count == 1)
  #expect(context.diagnostics.first?.diagnosticID == MessageID(domain: "MacroToolboxTransflection", id: "unexpected-implementation-error"))
  #expect(context.diagnostics.first?.message == "Macro expansion failed unexpectedly.")
}

@Test func stagesPrepareOnceAndRenderingCannotReadOptionsImplicitly() throws {
  struct Plan { let visibility: VisibilityLevel; let count: Int }
  var decodes = 0, plans = 0, renders = 0
  let stages = StagedMacroExpansion<ExprSyntax, BridgeOptions, Plan, String>(
    validate: { decodes += 1; return try TransflectionMacroBridge.decode($0, as: BridgeOptions.self) },
    plan: { plans += 1; return Plan(visibility: $0.memberVisibility, count: $0.exposedAPI.count) },
    render: { renders += 1; return "\($0.visibility.sourceCodeStringRepresentation):\($0.count)" }
  )
  let plan = try stages.prepare(expression("BridgeOptions(memberVisibility: .public, exposedAPI: [.rawValue, .description])"))
  #expect(decodes == 1 && plans == 1 && renders == 0)
  #expect(try stages.render(plan) == "public:2")
  #expect(decodes == 1 && plans == 1 && renders == 1)
}
