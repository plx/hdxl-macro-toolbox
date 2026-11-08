import MacroToolboxModels
import SwiftParser
import SwiftSyntax

public enum SyntaxConstructionFailure: Error {
  case invalidIdentifier(String)
  case invalidBindingSpecifier(TokenKind)
  case changedDeclarationKind(expected: SyntaxKind, actual: SyntaxKind)
  case changedTokenization
}

/// Bounded constructors over SwiftSyntax's own nodes. Callers decide members, access, bodies,
/// and conformances before rendering. Output is validated and formatted with two-space indent;
/// typed components are never replaced with reparsed source. No semantic policy is inferred.
public enum SyntaxConstruction {
  /// Return one identifier token, quoting keywords/raw names when necessary. An existing legal
  /// backtick spelling is retained. Invalid raw identifiers throw instead of injecting syntax.
  public static func identifier(_ spelling: String) throws -> TokenSyntax {
    for candidate in [spelling, "`\(spelling)`"] {
      var parser = Parser("let \(candidate): Int")
      let declaration = DeclSyntax.parse(from: &parser)
      if !declaration.hasError,
         let variable = declaration.as(VariableDeclSyntax.self), variable.bindings.count == 1,
         let pattern = variable.bindings.first?.pattern.as(IdentifierPatternSyntax.self),
         pattern.identifier.text == candidate {
        return .identifier(candidate)
      }
    }
    throw SyntaxConstructionFailure.invalidIdentifier(spelling)
  }

  public static func storedProperty(
    name: TokenSyntax,
    type: TypeSyntax,
    bindingSpecifier: TokenSyntax = .keyword(.var),
    initializer: ExprSyntax? = nil,
    readAccess: VisibilityLevel? = nil,
    setterAccess: VisibilityLevel? = nil,
    attributes: AttributeListSyntax = [],
    modifiers: DeclModifierListSyntax = []
  ) throws -> VariableDeclSyntax {
    guard bindingSpecifier.presence == .present,
          bindingSpecifier.tokenKind == .keyword(.let) || bindingSpecifier.tokenKind == .keyword(.var) else {
      throw SyntaxConstructionFailure.invalidBindingSpecifier(bindingSpecifier.tokenKind)
    }
    return try finish(VariableDeclSyntax(
      attributes: attributes,
      modifiers: accessModifiers(read: readAccess, setter: setterAccess, additional: modifiers),
      bindingSpecifier: bindingSpecifier,
      bindings: [PatternBindingSyntax(
        pattern: IdentifierPatternSyntax(identifier: try normalizedIdentifier(name)),
        typeAnnotation: TypeAnnotationSyntax(type: type),
        initializer: initializer.map { InitializerClauseSyntax(value: $0) }
      )]
    ))
  }

  public static func readOnlyProperty(
    name: TokenSyntax, type: TypeSyntax, body: [CodeBlockItemSyntax],
    readAccess: VisibilityLevel? = nil,
    attributes: AttributeListSyntax = [], modifiers: DeclModifierListSyntax = []
  ) throws -> VariableDeclSyntax {
    try finish(VariableDeclSyntax(
      attributes: attributes, modifiers: accessModifiers(read: readAccess, additional: modifiers),
      bindingSpecifier: .keyword(.var),
      bindings: [PatternBindingSyntax(
        pattern: IdentifierPatternSyntax(identifier: try normalizedIdentifier(name)),
        typeAnnotation: TypeAnnotationSyntax(type: type),
        accessorBlock: AccessorBlockSyntax(accessors: .getter(CodeBlockItemListSyntax(body)))
      )]
    ))
  }

  public static func initializer(
    parameters: [FunctionParameterSyntax], body: [CodeBlockItemSyntax],
    access: VisibilityLevel? = nil,
    attributes: AttributeListSyntax = [], modifiers: DeclModifierListSyntax = [],
    effects: FunctionEffectSpecifiersSyntax? = nil
  ) throws -> InitializerDeclSyntax {
    try finish(InitializerDeclSyntax(
      attributes: attributes, modifiers: accessModifiers(read: access, additional: modifiers),
      signature: FunctionSignatureSyntax(parameterClause: try parameterClause(parameters), effectSpecifiers: effects),
      body: CodeBlockSyntax(statements: CodeBlockItemListSyntax(body))
    ))
  }

  /// A function body can be a caller-chosen forwarding call or any already planned statements.
  public static func function(
    name: TokenSyntax, parameters: [FunctionParameterSyntax], returnType: TypeSyntax? = nil,
    body: [CodeBlockItemSyntax], access: VisibilityLevel? = nil,
    attributes: AttributeListSyntax = [], modifiers: DeclModifierListSyntax = [],
    effects: FunctionEffectSpecifiersSyntax? = nil
  ) throws -> FunctionDeclSyntax {
    try finish(FunctionDeclSyntax(
      attributes: attributes, modifiers: accessModifiers(read: access, additional: modifiers),
      name: try normalizedIdentifier(name),
      signature: FunctionSignatureSyntax(
        parameterClause: try parameterClause(parameters), effectSpecifiers: effects,
        returnClause: returnType.map { ReturnClauseSyntax(type: $0) }
      ),
      body: CodeBlockSyntax(statements: CodeBlockItemListSyntax(body))
    ))
  }

  public static func conformanceExtension(
    extending type: TypeSyntax, conformances: [TypeSyntax] = [],
    requirements: [GenericRequirementSyntax] = [], members: [DeclSyntax] = [],
    access: VisibilityLevel? = nil,
    attributes: AttributeListSyntax = [], modifiers: DeclModifierListSyntax = []
  ) throws -> ExtensionDeclSyntax {
    try finish(ExtensionDeclSyntax(
      attributes: attributes, modifiers: accessModifiers(read: access, additional: modifiers),
      extendedType: type, inheritanceClause: try inheritanceClause(conformances),
      genericWhereClause: try whereClause(requirements), memberBlock: MemberBlockSyntax(declarations: members)
    ))
  }

  /// A nil external name means `_ localName`; matching external/local names use one name token.
  public static func parameter(
    externalName: TokenSyntax? = nil, localName: TokenSyntax, type: TypeSyntax,
    defaultValue: ExprSyntax? = nil
  ) throws -> FunctionParameterSyntax {
    let local = try normalizedIdentifier(localName)
    let external = try externalName.map(normalizedIdentifier)
    return try FunctionParameterSyntax(
      firstName: external ?? .wildcardToken(), secondName: external?.text == local.text ? nil : local,
      type: type, defaultValue: defaultValue.map { InitializerClauseSyntax(value: $0) }
    ).validated()
  }

  public static func argument(label: TokenSyntax? = nil, expression: ExprSyntax) throws -> LabeledExprSyntax {
    try LabeledExprSyntax(label: label.map(normalizedIdentifier), colon: label == nil ? nil : .colonToken(), expression: expression).validated()
  }

  public static func call(callee: ExprSyntax, arguments: [LabeledExprSyntax]) throws -> FunctionCallExprSyntax {
    _ = try callee.validated()
    for argument in arguments { _ = try argument.validated() }
    let call = try FunctionCallExprSyntax(
      calledExpression: callee, leftParen: .leftParenToken(),
      arguments: LabeledExprListSyntax(withTrailingCommasInsertedBetween: arguments), rightParen: .rightParenToken()
    ).autoFormattedForHDXLProject()
    try verifyTokens(call, parsed: SyntaxSourceFragment.parse(call.description, as: ExprSyntax.self))
    return call
  }

  public static func parameterClause(_ parameters: [FunctionParameterSyntax]) throws -> FunctionParameterClauseSyntax {
    for parameter in parameters { _ = try parameter.validated() }
    return FunctionParameterClauseSyntax(parameters: FunctionParameterListSyntax(withTrailingCommasInsertedBetween: parameters))
  }

  /// Empty inputs omit the entire clause, avoiding a dangling `where` or colon.
  public static func whereClause(_ requirements: [GenericRequirementSyntax]) throws -> GenericWhereClauseSyntax? {
    guard !requirements.isEmpty else { return nil }
    for requirement in requirements { _ = try requirement.validated() }
    return GenericWhereClauseSyntax(requirements: requirements)
  }

  public static func inheritanceClause(_ types: [TypeSyntax]) throws -> InheritanceClauseSyntax? {
    guard !types.isEmpty else { return nil }
    for type in types { _ = try type.validated() }
    return InheritanceClauseSyntax(inheritedTypes: InheritedTypeListSyntax(withTrailingCommasInsertedBetween: types.map { InheritedTypeSyntax(type: $0) }))
  }

  public static func conformanceRequirement(_ type: TypeSyntax, to constraint: TypeSyntax) -> GenericRequirementSyntax {
    GenericRequirementSyntax(requirement: .conformanceRequirement(ConformanceRequirementSyntax(leftType: type, rightType: constraint)))
  }

  public static func sameTypeRequirement(_ type: TypeSyntax, as other: TypeSyntax) -> GenericRequirementSyntax {
    GenericRequirementSyntax(requirement: .sameTypeRequirement(SameTypeRequirementSyntax(leftType: .type(type), equal: .binaryOperator("=="), rightType: .type(other))))
  }

  private static func accessModifiers(read: VisibilityLevel?, setter: VisibilityLevel? = nil, additional: DeclModifierListSyntax) -> DeclModifierListSyntax {
    var result = additional
    if let read { result.append(DeclModifierSyntax(name: read.tokenRepresentation())) }
    if let setter {
      result.append(DeclModifierSyntax(name: setter.tokenRepresentation(), detail: DeclModifierDetailSyntax(detail: .keyword(.set))))
    }
    return result
  }

  private static func normalizedIdentifier(_ token: TokenSyntax) throws -> TokenSyntax {
    guard token.presence == .present else { throw SyntaxConstructionFailure.invalidIdentifier(token.text) }
    switch token.tokenKind {
    case .identifier, .keyword: break
    default: throw SyntaxConstructionFailure.invalidIdentifier(token.text)
    }
    var result = try identifier(token.text)
    result.leadingTrivia = token.leadingTrivia
    result.trailingTrivia = token.trailingTrivia
    return result
  }

  private static func finish<Declaration: DeclSyntaxProtocol>(_ declaration: Declaration) throws -> Declaration {
    let formatted = try declaration.autoFormattedForHDXLProject()
    // Validate printed grammar as well as missing/unexpected nodes. Return the built typed tree,
    // not this verification parse; types, expressions, and attributes never undergo replacement.
    let parsed = try SyntaxSourceFragment.parse(formatted.description, as: DeclSyntax.self)
    guard parsed.kind == Syntax(formatted).kind else {
      throw SyntaxConstructionFailure.changedDeclarationKind(expected: Syntax(formatted).kind, actual: parsed.kind)
    }
    try verifyTokens(formatted, parsed: parsed)
    return formatted
  }

  private static func verifyTokens(_ built: some SyntaxProtocol, parsed: some SyntaxProtocol) throws {
    let actual = Array(parsed.tokens(viewMode: .all))
    let expected = Array(built.tokens(viewMode: .all))
    guard actual.count == expected.count, zip(actual, expected).allSatisfy({ left, right in
      guard left.text == right.text else { return false }
      if left.tokenKind == right.tokenKind { return true }
      // Contextual keywords such as `set` can be represented with either token kind.
      switch (left.tokenKind, right.tokenKind) {
      case (.identifier, .keyword), (.keyword, .identifier): return true
      default: return false
      }
    }) else { throw SyntaxConstructionFailure.changedTokenization }
  }
}
