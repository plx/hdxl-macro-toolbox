import MacroToolboxModels
import MacroToolboxSyntax
import SwiftBasicFormat
import SwiftParser
import SwiftSyntax
import SwiftSyntaxBuilder
import Testing

private typealias Build = SyntaxConstruction

@Test("Compound callees retain grouping when printed and reparsed")
func compoundCalleeGrouping() throws {
  for source in ["primary ?? fallback", "condition ? first : second", "try makeClosure()", "await makeClosure()"] {
    let callee = try SyntaxSourceFragment.parse(source, as: ExprSyntax.self)
    let original = (callee.id, callee.description)
    let call = try Build.call(callee: callee, arguments: [])
    let reparsed = try SyntaxSourceFragment.parse(call.description, as: ExprSyntax.self)
    let parsedCall = try #require(reparsed.as(FunctionCallExprSyntax.self))
    let grouped = try #require(parsedCall.calledExpression.as(TupleExprSyntax.self))
    #expect(grouped.elements.count == 1)
    #expect(grouped.elements.first?.expression.trimmedDescription == source)
    #expect(callee.id == original.0 && callee.description == original.1)
  }
  let plain = try Build.call(callee: "storage.hasPrefix", arguments: [Build.argument(expression: "prefix")])
  #expect(plain.trimmedDescription == "storage.hasPrefix(prefix)")
  // An already malformed nested postfix tree must not pass merely because its tokens match.
  let nested = MemberAccessExprSyntax(
    base: try SyntaxSourceFragment.parse("primary ?? fallback", as: ExprSyntax.self),
    declName: DeclReferenceExprSyntax(baseName: .identifier("method"))
  )
  #expect(throws: SyntaxConstructionFailure.self) { try Build.call(callee: ExprSyntax(nested), arguments: []) }
}

@Test("Typed construction preserves types, expressions, attributes, and independent access")
func typedProperties() throws {
  let type = try SyntaxSourceFragment.parse("Dictionary<String, Array<Int?>>?", as: TypeSyntax.self)
  let expression = try SyntaxSourceFragment.parse("nil /* initializer */", as: ExprSyntax.self)
  let attribute = try SyntaxSourceFragment.parse("@available(*, deprecated)", as: AttributeSyntax.self)
  let original = (type.id, type.description, expression.id, expression.description)
  let property = try Build.storedProperty(
    name: .keyword(.class), type: type, initializer: expression,
    readAccess: .public, setterAccess: .private, attributes: [.attribute(attribute)]
  )
  #expect(property.modifiers.map(\.trimmedDescription) == ["public", "private(set)"])
  #expect(property.bindings.first?.pattern.trimmedDescription == "`class`")
  #expect(property.bindings.first?.typeAnnotation?.type.trimmedDescription == type.trimmedDescription)
  #expect(property.bindings.first?.initializer?.value.trimmedDescription == "nil")
  #expect(property.description.contains("/* initializer */"))
  #expect(property.attributes.first?.trimmedDescription == attribute.trimmedDescription)
  #expect(type.id == original.0 && type.description == original.1)
  #expect(expression.id == original.2 && expression.description == original.3)
  #expect(!property.hasError)
  let constant = try Build.storedProperty(name: .identifier("value"), type: "String?", bindingSpecifier: .keyword(.let), initializer: "nil")
  #expect(constant.bindingSpecifier.tokenKind == .keyword(.let))
  #expect(throws: (any Error).self) {
    try Build.storedProperty(name: .identifier("value"), type: "Int", bindingSpecifier: .keyword(.func))
  }
}

@Test("Zero, one, and many lists have stable punctuation and no dangling clauses")
func typedLists() throws {
  for count in 0...3 {
    let parameters = try (0..<count).map { try Build.parameter(localName: .identifier("p\($0)"), type: "Int") }
    let arguments = try (0..<count).map { try Build.argument(expression: ExprSyntax(IntegerLiteralExprSyntax(literal: .integerLiteral("\($0)")))) }
    let call = try Build.call(callee: "callee", arguments: arguments)
    let function = try Build.function(name: .keyword(.repeat), parameters: parameters, returnType: "Int", body: [CodeBlockItemSyntax(item: .expr(ExprSyntax(call)))])
    #expect(function.name.text == "`repeat`")
    #expect(function.signature.parameterClause.parameters.count == count)
    #expect(function.signature.parameterClause.parameters.enumerated().allSatisfy { ($0.element.trailingComma != nil) == ($0.offset < count - 1) })
    #expect(call.arguments.enumerated().allSatisfy { ($0.element.trailingComma != nil) == ($0.offset < count - 1) })
    let initializer = try Build.initializer(parameters: parameters, body: [])
    #expect(!initializer.hasError)
    let members = (0..<count).map { _ in DeclSyntax(function) }
    let requirements = (0..<count).map { Build.conformanceRequirement(TypeSyntax(IdentifierTypeSyntax(name: .identifier("T\($0)"))), to: "Equatable") }
    let ext = try Build.conformanceExtension(extending: "Box", requirements: requirements, members: members)
    #expect(ext.memberBlock.members.count == count)
    #expect((ext.genericWhereClause != nil) == (count > 0))
    #expect(ext.genericWhereClause?.requirements.last?.trailingComma == nil)
    #expect(try ext.autoFormattedForHDXLProject().description == ext.description)
    #expect(try SyntaxSourceFragment.parse(ext.description, as: DeclSyntax.self).hasError == false)
  }
  #expect(try Build.inheritanceClause([]) == nil)
  let sameType = Build.sameTypeRequirement("T.Element", as: "String")
  let ext = try Build.conformanceExtension(extending: "Box", requirements: [sameType])
  #expect(ext.trimmedDescription == "extension Box where T.Element == String {\n}")
  let labeled = try Build.parameter(externalName: .identifier("value"), localName: .identifier("value"), type: "Int", defaultValue: "1")
  #expect(labeled.secondName == nil)
  let other = try Build.parameter(externalName: .keyword(.for), localName: .identifier("value"), type: "Int")
  #expect(other.firstName.text == "`for`")
  #expect(other.secondName?.text == "value")
}

@Test("Comma normalization preserves comments and original node identity")
func commaTrivia() throws {
  let original = LabeledExprSyntax(expression: IntegerLiteralExprSyntax(1), trailingComma: .commaToken(leadingTrivia: .blockComment("/* before */"), trailingTrivia: [.spaces(1), .lineComment("// after"), .newlines(1)]))
  let identity = original.id
  let description = original.description
  let singleton = LabeledExprListSyntax(withTrailingCommasInsertedBetween: [original])
  #expect(singleton.first?.trailingComma == nil)
  #expect(singleton.description.contains("/* before */ // after\n"))
  let multiple = LabeledExprListSyntax(withTrailingCommasInsertedBetween: [original, original])
  #expect(multiple.first?.trailingComma?.description == original.trailingComma?.description)
  #expect(original.id == identity && original.description == description)
  let call = try Build.call(callee: "f", arguments: [original, original])
  #expect(call.description.components(separatedBy: "// after").count == 3)
  #expect(try SyntaxSourceFragment.parse(call.description, as: ExprSyntax.self).hasError == false)
}

@Test("Named source fragments and typed constructors reject recovery and injected grammar")
func rejectsMalformedConstruction() throws {
  for fragment in ["String; let injected = 1", "Array<", "Int Int"] {
    #expect(throws: (any Error).self) { try SyntaxSourceFragment.parse(fragment, as: TypeSyntax.self) }
    #expect(throws: (any Error).self) { try StoredProperty(name: "value", typeName: fragment).makeSyntaxRepresentation() }
  }
  #expect(throws: (any Error).self) { try SyntaxSourceFragment.parse("1; 2", as: ExprSyntax.self) }
  #expect(throws: (any Error).self) { try StoredProperty(name: "value", typeName: "Int", attributes: ["@MainActor var bad: Int"]).makeSyntaxRepresentation() }
  for name in ["", "`", "a\nb", "`a` b", "a`b"] {
    #expect(throws: (any Error).self) { try Build.identifier(name) }
  }
  for name in ["ordinary", "class", "`repeat`", "space name"] {
    let token = try Build.identifier(name)
    let property = try Build.storedProperty(name: token, type: "Int")
    #expect(!property.hasError)
  }
  #expect(throws: (any Error).self) {
    try Build.storedProperty(name: .identifier("x"), type: TypeSyntax(IdentifierTypeSyntax(name: .identifier("Int; var injected: Int"))))
  }
  let missing = FunctionParameterSyntax(firstName: .identifier("value", presence: .missing), type: TypeSyntax(IdentifierTypeSyntax(name: .identifier("Int"))))
  #expect(throws: (any Error).self) { try Build.parameterClause([missing]) }
}

private final class ChangeKindFormatter: BasicFormat {
  override func visitAny(_ node: Syntax) -> Syntax? {
    node.is(VariableDeclSyntax.self) ? Syntax(FunctionDeclSyntax(name: .identifier("f"), signature: FunctionSignatureSyntax(parameterClause: FunctionParameterClauseSyntax(parameters: [])))) : nil
  }
}

private final class RecoveredOutputFormatter: BasicFormat {
  override func visitAny(_ node: Syntax) -> Syntax? {
    guard node.is(VariableDeclSyntax.self) else { return nil }
    var parser = Parser("var broken:")
    return Syntax(DeclSyntax.parse(from: &parser))
  }
}

@Test("Formatting changes indentation, is idempotent, and rejects wrong-kind or recovered output")
func reliableFormatting() throws {
  let original = try SyntaxSourceFragment.parse("func f(){\n// keep\nif true {print(1)}\n}", as: DeclSyntax.self)
  let identity = original.id
  let source = original.description
  let formatted = try original.autoFormattedForHDXLProject()
  #expect(formatted.description.contains("  // keep\n  if true {\n    print(1)\n  }"))
  #expect(try formatted.autoFormattedForHDXLProject().description == formatted.description)
  #expect(original.description == source && original.id == identity)
  let variable = try SyntaxSourceFragment.parse("var value: Int", as: DeclSyntax.self)
  #expect(throws: SyntaxFormattingFailure.self) { try variable.formattedPreservingSyntaxKind(using: ChangeKindFormatter()) }
  #expect(throws: (any Error).self) { try variable.formattedPreservingSyntaxKind(using: RecoveredOutputFormatter()) }
  var parser = Parser("var broken:")
  let malformed = DeclSyntax.parse(from: &parser)
  #expect(throws: (any Error).self) { try malformed.autoFormattedForHDXLProject() }
}
