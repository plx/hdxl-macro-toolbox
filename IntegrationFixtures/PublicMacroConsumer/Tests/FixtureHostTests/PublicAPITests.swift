import Foundation
import Testing
import FixtureOptionsModels
import FixturePlugin
import MacroToolboxModels
import MacroToolboxSyntax
import MacroToolbox
import MacroToolboxTransflection
import ValueTransflection
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxMacroExpansion
import SwiftDiagnostics

private func expand(_ source: String) -> (Syntax, BasicMacroExpansionContext) {
  let tree = Parser.parse(source: source)
  let context = BasicMacroExpansionContext(sourceFiles: [tree: .init(moduleName: "Fixture", fullFilePath: "/Fixture.swift")])
  let result = tree.expand(macros: ["FixtureMembers": FixtureMembersMacro.self],
    contextGenerator: { BasicMacroExpansionContext(sharingWith: context, lexicalContext: $0.allMacroLexicalContexts()) },
    indentationWidth: .spaces(2))
  return (result, context)
}
private let validOptions = "FixtureOptions(visibility: .public, items: [.first, .second])"

@Test func publicAnalysisRetainsCompleteMultiBindingAndAccessFacts() throws {
  let source = try String(contentsOfFile: analysisSourcePath, encoding: .utf8)
  let tree = Parser.parse(source: source)
  let declaration = try #require(tree.statements.compactMap { $0.item.as(StructDeclSyntax.self) }.first)
  let analysis = declaration.analyzeDirectMembers()
  #expect(analysis.members.count == 5 && analysis.bindings.count == 6)
  #expect(analysis.bindings.map(\.name) == ["seed", "a", "b", "value", "shared", "projected"])
  let a = analysis.bindings[1], b = analysis.bindings[2], value = analysis.bindings[3]
  #expect(a.memberIndex == 1 && b.memberIndex == 1 && a.bindingIndex == 0 && b.bindingIndex == 1)
  #expect(a.explicitType?.trimmedDescription == "Int" && b.explicitType?.trimmedDescription == "Int")
  #expect(a.initializer?.trimmedDescription == "1" && b.initializer?.trimmedDescription == "2")
  #expect(a.binding.root.id == tree.id && b.variableDeclaration.root.id == tree.id)
  #expect(a.binding.positionAfterSkippingLeadingTrivia < b.binding.positionAfterSkippingLeadingTrivia)
  #expect(!a.isLet && a.bindingSpecifier.text == "var" && a.accessorShape == .stored)
  #expect(value.writtenAccess.explicitReadAccess == .public && value.writtenAccess.explicitSetterAccess == .private)
  #expect(value.modifiers.setterVisibilityLevel == .private)
  #expect(analysis.enclosingAccess.explicitReadAccess == .public)
  #expect(analysis.bindings[4].isTypeProperty && analysis.bindings[5].accessorBlock != nil)
  let accepted = try analysis.validated(using: .init(supportedAccessorShapes: [.stored, .computed]))
  #expect(accepted.bindings.count == analysis.bindings.count)
  let legacy = try #require(StoredPropertyDescriptor(variableDeclaration: value.variableDeclaration))
  #expect(legacy.variableName == "value" && legacy.explicitType?.trimmedDescription == "String")
  #expect(legacy.primaryBinding.id == value.binding.id && legacy.writtenAccess.explicitSetterAccess == .private)
}

@Test func publicNormalDecoderAndImmutablePlanUseSharedOptions() throws {
  var parser = Parser(validOptions)
  let source = ExprSyntax.parse(from: &parser)
  let options = try TransflectionMacroBridge.decode(source, as: FixtureOptions.self)
  #expect(options == FixtureOptions(visibility: .public, items: [.first, .second]))
  let plan = FixturePlan(memberAccess: options.visibility, items: options.items)
  #expect(plan.storageAccess == .private && plan.memberAccess == .public)
  #expect(plan.storageName == "_fixtureItems" && plan.projectionName == "fixtureItems")
  #expect(plan.items == options.items)
}

@Test func ordinaryMacroRendersTypedMembersAfterValidation() throws {
  let (result, context) = expand("@FixtureMembers(options: \(validOptions))\npublic struct Example { public let seed: Int }")
  #expect(context.diagnostics.isEmpty)
  #expect(!result.hasError)
  #expect(result.description.contains("private let _fixtureItems: [FixtureOptionsModels.FixtureItem]"))
  #expect(result.description.contains("public var fixtureItems: [FixtureOptionsModels.FixtureItem]"))
  #expect(result.description.contains("public init(seed: Swift.Int)"))
  #expect(result.description.contains("self._fixtureItems = [.first, .second]"))
}

@Test func nestedWrongShapeHasOneOriginalDiagnosticAndNoPartialExpansion() throws {
  let source = """
  // Preserve original locations.
  @FixtureMembers(options: FixtureOptions(
    visibility: .public,
    items: [.first, 42]
  ))
  public struct Example { let seed: Int }
  """
  let (result, context) = expand(source)
  #expect(context.diagnostics.count == 1)
  #expect(!result.description.contains("_fixtureItems") && !result.description.contains("init(seed:"))
  let diagnostic = try #require(context.diagnostics.first)
  #expect(diagnostic.diagnosticID == MessageID(domain: "PublicFixture", id: "options"))
  #expect(diagnostic.node.trimmedDescription == "42" && diagnostic.diagMessage.severity == .error)
  let location = context.location(for: diagnostic.position, anchoredAt: diagnostic.node, fileName: "/Fixture.swift")
  #expect(location.line == 4 && location.column == 19)
  #expect(diagnostic.notes.contains { $0.message.contains("macro argument 0") && $0.message.contains("items") && $0.message.contains("array element 1") })
}

@Test func unsupportedMembersAndCollisionsStopBeforeRendering() throws {
  for (members, id, anchor) in [
    ("lazy var seed: Int = 0", "member", "lazy"),
    ("@FixtureWrapper var seed: Int = 0", "member", "@FixtureWrapper"),
    ("let seed: Int\n#if FEATURE\nlet other: Int\n#endif", "member", "#if FEATURE"),
    ("var seed: Int { 1 }", "member", "{ 1 }"),
    ("let seed: Int\nvar fixtureItems: Int = 0", "collision", "fixtureItems"),
    ("let seed: Int\nfunc _fixtureItems() {}", "collision", "_fixtureItems"),
    ("let seed: Int\ninit(seed: Int) { self.seed = seed }", "collision", "init(seed:"),
    ("var inferred = 1", "member", "inferred"),
    ("let seed: String", "seed", "seed"),
    ("let seed: Int\nlet extra: Int", "seed", "seed")
  ] {
    let (result, context) = expand("@FixtureMembers(options: \(validOptions))\npublic struct Example {\n\(members)\n}")
    #expect(context.diagnostics.count == 1, "\(members)")
    #expect(!result.description.contains("private let _fixtureItems:"))
    #expect(!result.description.contains("self._fixtureItems ="))
    let diagnostic = try #require(context.diagnostics.first)
    #expect(diagnostic.diagnosticID == MessageID(domain: "PublicFixture", id: id), "\(members)")
    #expect(diagnostic.node.trimmedDescription.contains(anchor), "\(members)")
    let location = context.location(for: diagnostic.position, anchoredAt: diagnostic.node, fileName: "/Fixture.swift")
    #expect(location.line >= 3)
  }
}

@Test func attachmentAccessAndArgumentPoliciesAreExplicit() {
  for (source, id) in [
    ("@FixtureMembers(options: \(validOptions)) class Example {}", "attachment"),
    ("@FixtureMembers(options: \(validOptions)) struct Example<T> { let seed: Int }", "attachment"),
    ("struct Outer { @FixtureMembers(options: \(validOptions)) struct Inner { let seed: Int } }", "attachment"),
    ("@FixtureMembers(options: \(validOptions)) struct Example { let seed: Int }", "access"),
    ("@FixtureMembers(options: \(validOptions)) private struct Example { let seed: Int }", "access"),
    ("@FixtureMembers(options: \(validOptions), options: \(validOptions)) public struct Example { let seed: Int }", "arguments")
  ] {
    let (result, context) = expand(source)
    #expect(context.diagnostics.count == 1)
    #expect(context.diagnostics.first?.diagnosticID == MessageID(domain: "PublicFixture", id: id))
    #expect(!result.description.contains("self._fixtureItems ="))
  }
}
