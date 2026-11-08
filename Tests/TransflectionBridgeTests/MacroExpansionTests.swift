import BridgeTestModels
import MacroToolboxModels
import MacroToolboxSyntax
import MacroToolbox
import MacroToolboxTransflection
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacroExpansion
import SwiftDiagnostics
import SwiftParser
import Testing

private struct FixtureInput {
  let declaration: DeclSyntax
  let decode: () throws -> BridgeOptions
}
private struct FixturePlan { let access: VisibilityLevel; let count: Int }

// This fixture's attachment policy is caller-owned. Each role gets a fresh pipeline, with no
// shared mutable cache. Its renderer can see only the immutable completed plan.
private func fixturePipeline() -> StagedMacroExpansion<FixtureInput, BridgeOptions, FixturePlan, [DeclSyntax]> {
  .init(validate: { input in
    guard let structure = input.declaration.as(StructDeclSyntax.self) else {
      throw DiagnosticsError(diagnostics: [MacroDiagnosticDetails(message: "An empty struct is required", domain: "Fixture", messageID: "attachment").diagnostic(at: input.declaration)])
    }
    if let member = structure.memberBlock.members.first {
      throw DiagnosticsError(diagnostics: [MacroDiagnosticDetails(message: "The struct must have no members", domain: "Fixture", messageID: "member").diagnostic(at: member.decl)])
    }
    return try input.decode()
  }, plan: { FixturePlan(access: $0.memberVisibility, count: $0.exposedAPI.count) }, render: { plan in
    [DeclSyntax(try SyntaxConstruction.storedProperty(name: .identifier("bridgeCount"),
      type: TypeSyntax(IdentifierTypeSyntax(name: .identifier("Int"))), bindingSpecifier: .keyword(.let),
      initializer: ExprSyntax(IntegerLiteralExprSyntax(literal: .integerLiteral(String(plan.count)))), readAccess: plan.access))]
  })
}

private struct PlainBridgeMacro: MemberMacro {
  static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    TransflectionMacroBridge.withDiagnostics(in: context, at: node, details: inputDetails(), failureValue: []) {
      try fixturePipeline().expand(FixtureInput(declaration: DeclSyntax(declaration), decode: {
        try TransflectionMacroBridge.decodeArgument(at: 0, in: node, as: BridgeOptions.self)
      }))
    }
  }
}
private struct ContextBridgeMacro: ContextualizedMemberMacro {
  static func contextualizedExpansion(in attachment: some MemberMacroContextProtocol) throws -> [DeclSyntax] {
    attachment.withTransflectionDiagnostics(details: inputDetails(), failureValue: []) {
      try fixturePipeline().expand(FixtureInput(declaration: DeclSyntax(attachment.declaration), decode: {
        // Nested legacy requirements must preserve the bridge's source/path and never emit early.
        try attachment.requireValue("Decode options") {
          try attachment.requireValue("Decode nested options") {
            try attachment.decodeValueArgument(at: 0, as: BridgeOptions.self)
          }
        }
      }))
    }
  }
}
private struct CustomBridgeMacro: MemberMacro {
  static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    TransflectionMacroBridge.withDiagnostics(in: context, at: node, details: inputDetails(), failureValue: []) {
      let _: BridgeOptions = try TransflectionMacroBridge.decodeAsymmetrically(node) { _ in throw CustomFailure() }
      return []
    }
  }
}
private struct MetadataBridgeMacro: ContextualizedMemberMacro {
  static func contextualizedExpansion(in attachment: some MemberMacroContextProtocol) throws -> [DeclSyntax] {
    attachment.withTransflectionDiagnostics(details: inputDetails(), failureValue: []) {
      try attachment.requireValue("Outer metadata wrapper") {
        let arguments = try #require(attachment.invocationArgumentsAsLabeledExpressionList)
        let argument = try #require(arguments.first)
        let replacement = ExprSyntax(MemberAccessExprSyntax(name: .identifier("public")))
        let original = Syntax(argument.expression)
        let details = MacroDiagnosticDetails(message: "Explicit replacement", domain: "Metadata", messageID: "replace",
          position: original.endPositionBeforeTrailingTrivia, highlights: [original],
          notes: [Note(node: Syntax(attachment.macroInvocationNode), message: FixtureNote())],
          fixIts: [FixIt(message: FixtureFix(), changes: [.replace(oldNode: original, newNode: Syntax(replacement))])])
        // The caller has established exactly which supported value should replace this argument.
        throw DiagnosticsError(diagnostics: [details.diagnostic(at: original)])
      }
    }
  }
}

private func expandFixture(_ source: String) -> (Syntax, BasicMacroExpansionContext) {
  let tree = Parser.parse(source: source)
  let context = BasicMacroExpansionContext(sourceFiles: [tree: .init(moduleName: "Fixture", fullFilePath: "/Fixture.swift")])
  let result = tree.expand(macros: ["PlainBridge": PlainBridgeMacro.self, "ContextBridge": ContextBridgeMacro.self,
    "CustomBridge": CustomBridgeMacro.self, "MetadataBridge": MetadataBridgeMacro.self],
    contextGenerator: { _ in context }, indentationWidth: .spaces(2))
  return (result, context)
}
private func location(of diagnostic: Diagnostic, in context: BasicMacroExpansionContext) -> SwiftSyntax.SourceLocation {
  context.location(for: diagnostic.position, anchoredAt: diagnostic.node, fileName: "/Fixture.swift")
}

@Test(arguments: ["PlainBridge", "ContextBridge"])
func realMacroExpansionUsesSameValuesAndPlan(_ macro: String) {
  let (result, context) = expandFixture("@\(macro)(options: BridgeOptions(memberVisibility: .public, exposedAPI: [.rawValue, .description]))\npublic struct Example {}")
  #expect(context.diagnostics.isEmpty)
  #expect(result.description.contains("public let bridgeCount: Int = 2"))
  #expect(!result.description.contains("@\(macro)"))
}

@Test(arguments: ["PlainBridge", "ContextBridge"])
func realNestedFailureIsEmittedOnceAtTheOriginalInteger(_ macro: String) throws {
  let source = """
  // Original leading source is retained.
  @\(macro)(options: BridgeOptions(
    memberVisibility: .public,
    exposedAPI: [.rawValue, 42]
  ))
  public struct Example {}
  """
  let (result, context) = expandFixture(source)
  #expect(!result.description.contains("bridgeCount"))
  #expect(context.diagnostics.count == 1)
  let diagnostic = try #require(context.diagnostics.first)
  #expect(diagnostic.diagnosticID == MessageID(domain: "Fixture", id: "options"))
  #expect(diagnostic.diagMessage.severity == .error)
  #expect(diagnostic.node.trimmedDescription == "42")
  let position = location(of: diagnostic, in: context)
  #expect(position.line == 4 && position.column == 27)
  #expect(diagnostic.notes.contains { $0.message.contains("macro argument 0") && $0.message.contains("exposedAPI") && $0.message.contains("array element 1") })
}

@Test(arguments: ["PlainBridge", "ContextBridge"])
func callerAttachmentPolicyIsSeparateFromDecoding(_ macro: String) throws {
  for (declaration, id, text) in [("class Example {}", "attachment", "class Example {}"),
    ("struct Example { let existing: Int }", "member", "let existing: Int")] {
    // Invalid options cannot obscure an attachment failure: validation precedes decoding.
    let (_, context) = expandFixture("@\(macro)(options: makeOptions())\n\(declaration)")
    #expect(context.diagnostics.count == 1)
    let diagnostic = try #require(context.diagnostics.first)
    #expect(diagnostic.diagnosticID == MessageID(domain: "Fixture", id: id))
    #expect(diagnostic.node.trimmedDescription.contains(text))
    #expect(location(of: diagnostic, in: context).line == (id == "member" ? 2 : 1))
  }
}

@Test(arguments: ["PlainBridge", "ContextBridge"])
func realMissingUnknownAndUnsupportedArgumentsKeepSourceContext(_ macro: String) throws {
  for (argument, anchor) in [
    ("BridgeOptions(memberVisibility: .public, mystery: [])", "mystery"),
    ("BridgeOptions(memberVisibility: .public)", "memberVisibility: .public"),
    ("makeOptions()", "makeOptions")
  ] {
    let (_, context) = expandFixture("@\(macro)(options: \(argument))\nstruct Example {}")
    #expect(context.diagnostics.count == 1)
    let diagnostic = try #require(context.diagnostics.first)
    #expect(diagnostic.node.trimmedDescription.contains(anchor))
    #expect(location(of: diagnostic, in: context).line == 1)
    #expect(diagnostic.diagnosticID == MessageID(domain: "Fixture", id: "options"))
  }
  let (_, context) = expandFixture("@\(macro)\nstruct Example {}")
  #expect(context.diagnostics.count == 1)
  #expect(context.diagnostics.first?.node.trimmedDescription == "@\(macro)")
}

@Test func realExplicitCustomFailureAndDeferredMetadataEmitOnlyOnce() throws {
  let (_, custom) = expandFixture("// offset\n@CustomBridge(options: makeOptions())\nstruct Example {}")
  #expect(custom.diagnostics.count == 1)
  let customDiagnostic = try #require(custom.diagnostics.first)
  #expect(customDiagnostic.diagnosticID == MessageID(domain: "Fixture", id: "options"))
  #expect(location(of: customDiagnostic, in: custom).line == 2)

  let (_, context) = expandFixture("// offset\n@MetadataBridge(42)\nstruct Example {}")
  #expect(context.diagnostics.count == 1)
  let diagnostic = try #require(context.diagnostics.first)
  #expect(diagnostic.diagnosticID == MessageID(domain: "Metadata", id: "replace"))
  #expect(location(of: diagnostic, in: context).line == 2)
  #expect(location(of: diagnostic, in: context).column == 19)
  #expect(diagnostic.highlights.first?.trimmedDescription == "42")
  #expect(diagnostic.notes.first?.message == "Caller note")
  let change = try #require(diagnostic.fixIts.first?.changes.first)
  guard case .replace(let old, let new) = change else { Issue.record("Expected replacement"); return }
  let start = context.location(for: old.positionAfterSkippingLeadingTrivia, anchoredAt: old, fileName: "/Fixture.swift")
  let end = context.location(for: old.endPositionBeforeTrailingTrivia, anchoredAt: old, fileName: "/Fixture.swift")
  #expect(start.line == 2 && start.column == 17)
  #expect(end.line == 2 && end.column == 19)
  #expect(new.trimmedDescription == ".public")
}
