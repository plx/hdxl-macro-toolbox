import FixtureOptionsModels
import MacroToolboxModels
import MacroToolboxSyntax
import MacroToolbox
import MacroToolboxTransflection
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

/// Ordinary SwiftSyntax protocol; contextualized protocol adoption is not required.
public struct FixtureMembersMacro: MemberMacro {
  public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    TransflectionMacroBridge.withDiagnostics(in: context, at: node,
      details: .init(message: "Invalid fixture options.", domain: "PublicFixture", messageID: "options"), failureValue: []) {
      try pipeline().expand(Input(node: node, declaration: DeclSyntax(declaration), lexicalContext: context.lexicalContext))
    }
  }
}

private struct Input {
  let node: AttributeSyntax
  let declaration: DeclSyntax
  let lexicalContext: [Syntax]
}
private struct ValidatedInput { let options: FixtureOptions }

private func pipeline() -> StagedMacroExpansion<Input, ValidatedInput, FixturePlan, [DeclSyntax]> {
  .init(validate: validate, plan: { FixturePlan(memberAccess: $0.options.visibility, items: $0.options.items) }, render: render)
}

private func reject(_ id: String, _ message: String, at node: some SyntaxProtocol) -> DiagnosticsError {
  DiagnosticsError(diagnostics: [MacroDiagnosticDetails(message: message, domain: "PublicFixture", messageID: id).diagnostic(at: node)])
}

private func validate(_ input: Input) throws -> ValidatedInput {
  guard let structure = input.declaration.as(StructDeclSyntax.self),
    structure.genericParameterClause == nil, structure.inheritanceClause == nil,
    input.lexicalContext.isEmpty else {
    throw reject("attachment", "FixtureMembers requires a top-level nongeneric struct without inheritance.", at: input.declaration)
  }
  for attribute in structure.attributes {
    guard case .attribute(let attribute) = attribute, attribute.attributeName.trimmedDescription == "FixtureMembers" else {
      throw reject("attribute", "Other type attributes are outside this fixture's policy.", at: attribute)
    }
  }
  let analysis = structure.analyzeDirectMembers()
  // Check all written direct names before strict validation; no filtering can hide a collision.
  let reserved = ["_fixtureItems", "fixtureItems"]
  for member in analysis.members {
    if let named = member.declaration.asProtocol(NamedDeclSyntax.self),
      reserved.contains(named.name.text.replacingOccurrences(of: "\u{0060}", with: "")) {
      throw reject("collision", "A member conflicts with a planned fixture name.", at: named.name)
    }
    for binding in member.bindings {
      if let identifier = binding.identifier, reserved.contains(identifier.text.replacingOccurrences(of: "\u{0060}", with: "")) {
        throw reject("collision", "A member conflicts with a planned fixture name.", at: identifier)
      }
    }
    if member.kind == .initializer {
      throw reject("collision", "FixtureMembers owns init(seed:); existing initializers are unsupported.", at: member.declaration)
    }
  }
  let validated: ValidatedStructMembers
  do { validated = try analysis.validated() }
  catch let rejection as StructAnalysisRejection {
    guard let first = rejection.findings.first else { throw rejection }
    throw reject("member", "Unsupported fixture member: \(first.reason).", at: first.anchor)
  }
  guard validated.bindings.count == 1, let seed = validated.bindings.first,
    seed.name == "seed", seed.isLet, !seed.isTypeProperty, seed.initializer == nil,
    ["Int", "Swift.Int"].contains(seed.explicitType?.trimmedDescription ?? ""),
    seed.modifiers.allSatisfy({ $0.visibilityLevel != nil }) else {
    throw reject("seed", "Declare exactly one plain stored let seed: Int without an initializer.", at: validated.bindings.first.map { Syntax($0.binding) } ?? Syntax(structure.name))
  }
  let typeAccess = analysis.enclosingAccess.localReadAccess
  guard [.internal, .package, .public].contains(typeAccess),
    structure.modifiers.allSatisfy({ $0.visibilityLevel != nil }) else {
    throw reject("access", "The fixture supports internal, package, or public types.", at: structure.modifiers)
  }
  guard case .argumentList(let arguments) = input.node.arguments, arguments.count == 1,
    arguments.first?.label?.text == "options" else {
    throw reject("arguments", "Supply exactly one options: argument.", at: input.node)
  }
  let options = try TransflectionMacroBridge.decodeArgument(at: 0, in: input.node, as: FixtureOptions.self)
  guard [.internal, .package, .public].contains(options.visibility), options.visibility <= typeAccess else {
    throw reject("access", "Generated member access must be internal, package, or public and cannot exceed type access.", at: input.node)
  }
  return .init(options: options)
}

/// Rendering receives only the immutable semantic plan, never the invocation/declaration.
private func render(_ plan: FixturePlan) throws -> [DeclSyntax] {
  let storage = try SyntaxConstruction.identifier(plan.storageName)
  let projection = try SyntaxConstruction.identifier(plan.projectionName)
  let seed = try SyntaxConstruction.identifier(plan.seedName)
  let itemType = TypeSyntax("FixtureOptionsModels.FixtureItem")
  let arrayType = TypeSyntax(ArrayTypeSyntax(element: itemType))
  let elements = plan.items.enumerated().map { index, item in
    ArrayElementSyntax(expression: MemberAccessExprSyntax(name: .identifier(item.rawValue)),
      trailingComma: index + 1 < plan.items.count ? .commaToken() : nil)
  }
  let array = ArrayExprSyntax(elements: ArrayElementListSyntax(elements))
  return [
    DeclSyntax(try SyntaxConstruction.storedProperty(name: storage, type: arrayType,
      bindingSpecifier: .keyword(.let), readAccess: plan.storageAccess)),
    DeclSyntax(try SyntaxConstruction.readOnlyProperty(name: projection, type: arrayType,
      body: ["self.\(storage)"], readAccess: plan.memberAccess)),
    DeclSyntax(try SyntaxConstruction.initializer(parameters: [
      FunctionParameterSyntax(firstName: seed, type: TypeSyntax("Swift.Int"))
    ], body: ["self.\(seed) = \(seed)", "self.\(storage) = \(array)"], access: plan.memberAccess))
  ]
}
