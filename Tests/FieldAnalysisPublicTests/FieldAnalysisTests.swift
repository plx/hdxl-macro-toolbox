import Foundation
import MacroToolboxModels
import MacroToolboxSyntax
import SwiftParser
import SwiftSyntax
import Testing

@Suite("Field analysis through public imports")
struct FieldAnalysisTests {
  @Test func compiledMatrixPreservesEveryDirectBindingInOrder() throws {
    let declaration = try compiledFixture("FieldMatrixFixture")
    let analysis = declaration.analyzeDirectMembers()
    #expect(analysis.members.count == declaration.memberBlock.members.count)
    #expect(analysis.members.map(\.index) == Array(0..<13))
    #expect(analysis.bindings.map(\.name) == ["value", "a", "b", "inferred", "answer", "explicitComputed", "observed", "total", "visible", "deferred", "wrapped"])
    let a = analysis.bindings[1], b = analysis.bindings[2]
    #expect(a.memberIndex == 1 && b.memberIndex == 1 && a.bindingIndex == 0 && b.bindingIndex == 1)
    #expect(a.explicitType?.trimmedDescription == "Int" && b.explicitType?.trimmedDescription == "Int")
    #expect(a.initializer?.trimmedDescription == "1" && b.initializer?.trimmedDescription == "2")
    let original = try #require(Array(declaration.memberBlock.members)[1].decl.as(VariableDeclSyntax.self))
    #expect(a.binding.id == original.bindings.first?.id)
    #expect(b.binding.id == original.bindings.last?.id)
    #expect(a.binding.positionAfterSkippingLeadingTrivia < b.binding.positionAfterSkippingLeadingTrivia)
    #expect(a.identifier?.id == original.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.id)
    #expect(analysis.bindings[0].isLet && !a.isLet)
    #expect(analysis.bindings[0].bindingSpecifier.text == "let")
    #expect(!analysis.bindings[0].isTypeProperty)
  }

  @Test func annotationsAccessorsStaticAndLimitationsRemainDistinct() throws {
    let analysis = try compiledFixture("FieldMatrixFixture").analyzeDirectMembers()
    let fields = Dictionary(uniqueKeysWithValues: analysis.bindings.map { ($0.name!, $0) })
    let inferred = try #require(fields["inferred"])
    #expect(inferred.explicitType == nil && inferred.initializer?.trimmedDescription == "1")
    #expect(fields["answer"]?.accessorShape == .computed)
    #expect(fields["explicitComputed"]?.accessorShape == .computed)
    #expect(fields["observed"]?.accessorShape == .observed)
    #expect(fields["observed"]?.accessorBlock?.trimmedDescription == "{ didSet {} }")
    #expect(fields["total"]?.isTypeProperty == true && fields["total"]?.accessorShape == .stored)
    #expect(fields["deferred"]?.isLazy == true)
    #expect(fields["wrapped"]?.attributes.count == 1)
    #expect(Set(analysis.findings.map(\.reason)) == [.missingTypeAnnotation, .lazyBinding, .attributedBinding, .conditionalMember])
    let missing = try #require(analysis.findings.first { $0.reason == .missingTypeAnnotation })
    #expect(missing.anchor.id == inferred.binding.id && missing.memberIndex == 2 && missing.bindingIndex == 0)
    let lazy = try #require(analysis.findings.first { $0.reason == .lazyBinding })
    #expect(lazy.anchor.trimmedDescription == "lazy")
    let attribute = try #require(analysis.findings.first { $0.reason == .attributedBinding })
    #expect(attribute.anchor.trimmedDescription == "@MatrixWrapper")
    let originalIDs = Set(allNodes(Syntax(analysis.declaration)).map(\.id))
    for finding in analysis.findings { #expect(originalIDs.contains(finding.anchor.id)) }
  }

  @Test func nestedTypesAndConditionalBranchesAreNotFlattened() throws {
    let analysis = try compiledFixture("FieldMatrixFixture").analyzeDirectMembers()
    let nested = try #require(analysis.members.first { $0.kind == .struct })
    #expect(nested.bindings.isEmpty && nested.declaration.as(StructDeclSyntax.self)?.name.text == "Nested")
    let conditional = try #require(analysis.members.first { $0.kind == .ifConfig })
    #expect(conditional.bindings.isEmpty)
    #expect(conditional.declaration.trimmedDescription.contains("conditional"))
    #expect(conditional.declaration.trimmedDescription.contains("alternative"))
    #expect(conditional.findings.map(\.reason) == [.conditionalMember])
    #expect(conditional.findings.first?.anchor.id == conditional.declaration.id)
    #expect(!analysis.bindings.contains { ["child", "conditional", "alternative"].contains($0.name ?? "") })
  }

  @Test func readSetterAndEnclosingAccessAreIndependent() throws {
    let publicAnalysis = try compiledFixture("FieldMatrixFixture").analyzeDirectMembers()
    let visible = try #require(publicAnalysis.bindings.first { $0.name == "visible" })
    #expect(publicAnalysis.enclosingAccess.explicitReadAccess == .public)
    #expect(visible.writtenAccess.explicitReadAccess == .public)
    #expect(visible.writtenAccess.explicitSetterAccess == .private)
    #expect(visible.modifiers.visibilityLevel == .public && visible.modifiers.setterVisibilityLevel == .private)
    let setter = try #require(visible.writtenAccess.setterModifiers.first)
    #expect(setter.visibilityLevel == nil && setter.setterVisibilityLevel == .private)
    let privateAnalysis = try compiledFixture("PrivateAccessFixture").analyzeDirectMembers()
    #expect(privateAnalysis.enclosingAccess.explicitReadAccess == .private)
    let local = privateAnalysis.bindings[0], exposed = privateAnalysis.bindings[1]
    #expect(local.writtenAccess.explicitReadAccess == nil && local.writtenAccess.localReadAccess == .internal)
    #expect(local.writtenAccess.explicitSetterAccess == .private)
    #expect(exposed.writtenAccess.explicitReadAccess == .public && exposed.writtenAccess.explicitSetterAccess == .private)
    #expect(exposed.writtenAccess.localReadAccess == .public) // Not claimed to be effective public access.
    #expect(exposed.modifiers.visibilityLevel == .public) // Setter modifier occurs first.
  }

  @Test func strictCallerRejectsAllUnsupportedShapesBeforeEmission() throws {
    let analysis = try compiledFixture("FieldMatrixFixture").analyzeDirectMembers()
    var emitted: [String] = []
    do {
      let validated = try analysis.validated()
      emitted = validated.bindings.compactMap(\.name)
      Issue.record("Strict transformation accepted unsupported fields")
    } catch let rejection as StructAnalysisRejection {
      #expect(rejection.findings.count == 9)
      let reasons = Set(rejection.findings.map(\.reason))
      #expect(reasons == [.missingTypeAnnotation, .lazyBinding, .attributedBinding, .conditionalMember, .unsupportedAccessorShape(.computed), .unsupportedAccessorShape(.observed), .unsupportedMember(.struct), .unsupportedMember(.function)])
      let positions = rejection.findings.map { $0.anchor.positionAfterSkippingLeadingTrivia.utf8Offset }
      #expect(positions == positions.sorted())
    }
    #expect(emitted.isEmpty)
  }

  @Test func explicitPolicyKeepsSupportedMembersAndAcknowledgedLimitations() throws {
    let declaration = try compiledFixture("FieldMatrixFixture")
    let withoutConditional = declaration.with(\.memberBlock.members, declaration.memberBlock.members.filter { !$0.decl.is(IfConfigDeclSyntax.self) })
    let policy = StructTransformationPolicy(supportedAccessorShapes: [.stored, .computed, .observed], allowedOtherDeclarations: [.struct, .function], requiresWrittenTypes: false, supportsAttributedBindings: true, supportsLazyBindings: true)
    let analysis = withoutConditional.analyzeDirectMembers()
    let accepted = try analysis.validated(using: policy)
    #expect(accepted.members.count == analysis.members.count && accepted.bindings.count == 11)
    #expect(accepted.analysis.findings.count == 3) // Acknowledged limitations are never hidden.
    #expect(accepted.members.contains { $0.kind == .struct })
    var conditionalPolicy = policy
    conditionalPolicy.allowedOtherDeclarations.insert(.ifConfig)
    do { _ = try declaration.analyzeDirectMembers().validated(using: conditionalPolicy); Issue.record("Conditional uncertainty was waived") }
    catch let rejection as StructAnalysisRejection { #expect(rejection.findings.map(\.reason) == [.conditionalMember]) }
  }

  @Test func unfamiliarButCompilerValidAccessorsRemainVisible() throws {
    let analysis = try compiledFixture("UnfamiliarAccessorFixture").analyzeDirectMembers()
    let field = try #require(analysis.bindings.first)
    #expect(field.name == "yielded" && field.accessorShape == .unfamiliar)
    #expect(analysis.findings.map(\.reason) == [.unfamiliarAccessors])
    #expect(analysis.findings.first?.anchor.id == field.accessorBlock?.id)
    #expect(throws: StructAnalysisRejection.self) { try analysis.validated(using: .init(supportedAccessorShapes: [.unfamiliar])) }
  }

  @Test func destructuringAndRecoveryAreSeparateRejectionInputs() throws {
    // Parser-level negative fixtures: these are not represented as compiler-valid stored fields.
    let destructuring = try parsedStruct("struct Rejected { var (x, y): (Int, Int) }")
    let analysis = destructuring.analyzeDirectMembers()
    #expect(analysis.bindings.count == 1 && analysis.bindings[0].identifier == nil)
    #expect(analysis.bindings[0].pattern.is(TuplePatternSyntax.self))
    #expect(analysis.findings.contains { $0.reason == .unsupportedPattern && $0.anchor.id == analysis.bindings[0].pattern.id })
    #expect(throws: StructAnalysisRejection.self) { try analysis.validated() }
    let malformed = try parsedStruct("struct Broken { var value: Int { get {", allowRecovery: true)
    #expect(malformed.hasError)
    let recovered = malformed.analyzeDirectMembers()
    let finding = try #require(recovered.findings.first { $0.reason == .malformedSyntax })
    #expect(allNodes(Syntax(malformed)).contains { $0.id == finding.anchor.id })
    #expect(finding.anchor.hasError)
    #expect(throws: StructAnalysisRejection.self) { try recovered.validated() }
  }

  @Test func conflictingAccessAndMemberExpansionCannotBeSilentlyAccepted() throws {
    let declaration = try parsedStruct("struct Rejected { public private var value: Int; private(set) fileprivate(set) var setter: Int; #generated() }")
    let analysis = declaration.analyzeDirectMembers()
    #expect(analysis.findings.contains { $0.reason == .conflictingReadAccess && $0.anchor.trimmedDescription == "private" })
    #expect(analysis.findings.contains { $0.reason == .conflictingSetterAccess && $0.anchor.trimmedDescription == "fileprivate(set)" })
    #expect(analysis.findings.contains { $0.reason == .expandedMember })
    #expect(analysis.members.count == 3)
    #expect(throws: StructAnalysisRejection.self) { try analysis.validated(using: .init(allowedOtherDeclarations: [.macroExpansion])) }
  }

  @Test func legacyDescriptorsExposeFactsAndObeyIdentityEqualityAndHashing() throws {
    let analysis = try compiledFixture("FieldMatrixFixture").analyzeDirectMembers()
    let binding = analysis.bindings[0]
    let descriptor = try #require(StoredPropertyDescriptor(variableDeclaration: binding.variableDeclaration))
    let copy = descriptor
    let rebuilt = try #require(StoredPropertyDescriptor(variableDeclaration: binding.variableDeclaration))
    #expect(descriptor == descriptor && descriptor == copy && descriptor == rebuilt)
    #expect(Set([descriptor, copy, rebuilt]).count == 1)
    #expect(descriptor.hashValue == copy.hashValue && descriptor.hashValue == rebuilt.hashValue)
    #expect(descriptor.variableName == "value" && descriptor.explicitType?.trimmedDescription == "String")
    #expect(descriptor.primaryBinding.id == binding.binding.id && descriptor.variableDeclaration.id == binding.variableDeclaration.id)
    #expect(descriptor.initializer == nil && descriptor.writtenAccess.explicitReadAccess == nil)
    let independent = try parsedStruct("struct Independent { let value: String }")
    let independentMember = try #require(independent.memberBlock.members.first)
    let other = try #require(StoredPropertyDescriptor(decl: independentMember.decl))
    #expect(descriptor != other)
    #expect(StoredPropertyDescriptor(variableDeclaration: analysis.bindings[1].variableDeclaration) == nil) // Historical multi-binding filter.
    #expect(analysis.bindings.filter { $0.memberIndex == 1 }.count == 2) // Complete analysis preserves both.
  }
}

private func compiledFixture(_ name: String) throws -> StructDeclSyntax {
  let source = try String(contentsOf: URL(fileURLWithPath: acceptedShapesSourcePath), encoding: .utf8)
  let parsed = Parser.parse(source: source)
  #expect(!parsed.hasError)
  let match = parsed.statements.compactMap { $0.item.as(StructDeclSyntax.self) }.first { $0.name.text == name }
  return try #require(match)
}
private func parsedStruct(_ source: String, allowRecovery: Bool = false) throws -> StructDeclSyntax {
  let parsed = Parser.parse(source: source)
  if !allowRecovery { #expect(!parsed.hasError) }
  let match = parsed.statements.compactMap { $0.item.as(StructDeclSyntax.self) }.first
  return try #require(match)
}
private func allNodes(_ node: Syntax) -> [Syntax] { [node] + node.children(viewMode: .all).flatMap(allNodes) }
