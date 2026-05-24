import SwiftSyntax
import Testing
@testable import MacroToolbox

@Test("Argument label descriptors parse and render declaration labels")
func testArgumentLabelDescriptorsParseAndRenderDeclarationLabels() throws {
  // Hand-written examples: `_` represents an unlabeled argument, identifier text
  // represents a labeled argument, and empty or non-word strings are rejected.
  let unlabeled = try #require(ArgumentLabelDescriptor(declarationSourceCodeRepresentation: "_"))
  let labeled = try #require(ArgumentLabelDescriptor(declarationSourceCodeRepresentation: "value"))
  
  #expect(unlabeled == .unlabeled)
  #expect(unlabeled.id == unlabeled)
  #expect(unlabeled.description == ".unlabeled")
  #expect(unlabeled.debugDescription == "ArgumentLabelDescriptor.unlabeled")
  #expect(unlabeled.declarationSourceCodeRepresentation == "_")
  #expect(unlabeled.invocationSourceCodeRepresentation(forArgumentValue: "input") == "input")
  
  #expect(labeled == .labeled("value"))
  #expect(labeled.id == labeled)
  #expect(labeled.description == ".label(\"value\")")
  #expect(labeled.debugDescription == "ArgumentLabelDescriptor.label(\"value\")")
  #expect(labeled.declarationSourceCodeRepresentation == "value")
  #expect(labeled.invocationSourceCodeRepresentation(forArgumentValue: "input") == "value: input")
  
  #expect(ArgumentLabelDescriptor(declarationSourceCodeRepresentation: "") == nil)
  #expect(ArgumentLabelDescriptor(declarationSourceCodeRepresentation: "value-name") == nil)
}

@Test("Argument label descriptors round-trip source representations")
func testArgumentLabelDescriptorsRoundTripSourceRepresentations() throws {
  // Property-style test: every accepted declaration representation should
  // round-trip through the descriptor and render an invocation according to
  // whether the argument is labeled or unlabeled.
  let samples: [(source: String, expectedInvocation: String)] = [
    ("_", "payload"),
    ("value", "value: payload"),
    ("value_2", "value_2: payload")
  ]
  
  for sample in samples {
    let descriptor = try #require(
      ArgumentLabelDescriptor(declarationSourceCodeRepresentation: sample.source)
    )
    
    #expect(descriptor.declarationSourceCodeRepresentation == sample.source)
    #expect(descriptor.invocationSourceCodeRepresentation(forArgumentValue: "payload") == sample.expectedInvocation)
  }
}

@Test("Argument position descriptors classify call argument positions")
func testArgumentPositionDescriptorsClassifyCallArgumentPositions() throws {
  // Hand-written examples: position descriptors should recognize the solitary,
  // first, last, absolute, and offset-from-last positions in parsed call
  // arguments.
  let solitary = try #require(Array(callArguments("call(value)").positionedLabeledExpressions).first)
  let positioned = Array(try callArguments("call(first, label: second, third)").positionedLabeledExpressions)
  
  #expect(solitary.isCompatible(with: .solitary))
  #expect(solitary.isCompatible(with: ArgumentPositionDescriptor.first))
  #expect(solitary.isCompatible(with: ArgumentPositionDescriptor.last))
  #expect(positioned[0].isCompatible(with: ArgumentPositionDescriptor.first))
  #expect(positioned[1].isCompatible(with: .relativeToFirst(1)))
  #expect(positioned[1].isCompatible(with: .relativeToLast(1)))
  #expect(positioned[2].isCompatible(with: ArgumentPositionDescriptor.last))
  #expect(!positioned[0].isCompatible(with: .solitary))
  #expect(!positioned[0].isCompatible(with: .relativeToFirst(3)))
  
  #expect(ArgumentPositionDescriptor.solitary.description == ".solitary")
  #expect(ArgumentPositionDescriptor.first.description == ".relativeToFirst(0)")
  #expect(ArgumentPositionDescriptor.last.description == ".relativeToLast(0)")
  #expect(ArgumentPositionDescriptor.solitary.debugDescription == "ArgumentPositionDescriptor.solitary")
  #expect(ArgumentPositionDescriptor.last.debugDescription == "ArgumentPositionDescriptor.relativeToLast(0)")
  #expect(ArgumentPositionDescriptor.first.id == .first)
}

@Test("Argument position helpers agree with indexed call arguments")
func testArgumentPositionHelpersAgreeWithIndexedCallArguments() throws {
  // Property-style test: the list-level position helpers should return the same
  // elements and counts as direct index arithmetic over positioned arguments.
  let arguments = try callArguments("call(first, label: second, third)")
  let positioned = Array(arguments.positionedLabeledExpressions)
  let descriptors: [ArgumentPositionDescriptor] = [
    .solitary,
    .first,
    .relativeToFirst(1),
    .relativeToLast(1),
    .last,
    .relativeToFirst(5)
  ]
  
  for descriptor in descriptors {
    let matching = positioned.filter { $0.isCompatible(with: descriptor) }
    
    #expect(arguments.firstElement(compatibleWith: descriptor) == matching.first?.labeledExpression)
    #expect(arguments.countOfElements(compatibleWith: descriptor) == matching.count)
  }
}

@Test("Argument location descriptors combine labels and positions")
func testArgumentLocationDescriptorsCombineLabelsAndPositions() throws {
  // Hand-written examples: location descriptors should match by position, by
  // label, or by both dimensions when they are combined.
  let positioned = Array(try callArguments("call(first, label: second, third)").positionedLabeledExpressions)
  let first = ArgumentLocationDescriptor.first
  let labelOnly = ArgumentLocationDescriptor.labeled("label")
  let absoluteAndLabel = ArgumentLocationDescriptor.absolute(position: 1).with(label: "label")
  let lastUnlabeled = ArgumentLocationDescriptor.last.unlabeled()
  
  #expect(positioned[0].isCompatible(with: first))
  #expect(positioned[1].isCompatible(with: labelOnly))
  #expect(positioned[1].isCompatible(with: absoluteAndLabel))
  #expect(positioned[2].isCompatible(with: lastUnlabeled))
  #expect(!positioned[0].isCompatible(with: absoluteAndLabel))
  #expect(!positioned[1].isCompatible(with: lastUnlabeled))
  
  #expect(first.storage.positionDescriptor == .first)
  #expect(first.storage.labelDescriptor == nil)
  #expect(labelOnly.storage.positionDescriptor == nil)
  #expect(labelOnly.storage.labelDescriptor == .labeled("label"))
  #expect(absoluteAndLabel.storage.positionDescriptor == .relativeToFirst(1))
  #expect(absoluteAndLabel.storage.labelDescriptor == .labeled("label"))
  #expect(first.storage.description == ".position(.relativeToFirst(0))")
  #expect(first.storage.debugDescription == "ArgumentLocationDescriptorStorage.position(ArgumentPositionDescriptor.relativeToFirst(0))")
  #expect(labelOnly.storage.description == ".label(.label(\"label\"))")
  #expect(labelOnly.storage.debugDescription == "ArgumentLocationDescriptorStorage.label(ArgumentLabelDescriptor.label(\"label\"))")
  #expect(labelOnly.storage.with(label: "other") == .label(.labeled("other")))
  #expect(first.storage.with(position: .last) == .position(.last))
  #expect(String(describing: absoluteAndLabel).contains(".positionAndLabel"))
  #expect(String(reflecting: absoluteAndLabel).contains("ArgumentLocationDescriptor"))
}

@Test("Argument location descriptors match equivalent storage composition")
func testArgumentLocationDescriptorsMatchEquivalentStorageComposition() throws {
  // Property-style test: composing labels and positions in either order should
  // produce the same storage, and direct storage compatibility should match the
  // public descriptor compatibility wrapper.
  let positioned = Array(try callArguments("call(first, label: second, third)").positionedLabeledExpressions)
  let equivalentPairs = [
    (
      ArgumentLocationDescriptor.first.with(label: "label"),
      ArgumentLocationDescriptor.labeled("label").with(absolutePosition: 0)
    ),
    (
      ArgumentLocationDescriptor.offsetFromLast(by: 1).with(label: "label"),
      ArgumentLocationDescriptor.labeled("label").with(offsetFromLast: 1)
    )
  ]
  
  for (lhs, rhs) in equivalentPairs {
    #expect(lhs.storage == rhs.storage)
  }
  
  for argument in positioned {
    let descriptors = [
      ArgumentLocationDescriptor.first,
      ArgumentLocationDescriptor.last,
      ArgumentLocationDescriptor.labeled("label"),
      ArgumentLocationDescriptor.absolute(position: argument.positionIndex),
      ArgumentLocationDescriptor.offsetFromLast(by: argument.peerCount - argument.positionIndex - 1)
    ]
    
    for descriptor in descriptors {
      #expect(argument.isCompatible(with: descriptor) == argument.isCompatible(with: descriptor.storage))
    }
  }
}

@Test("Label criteria classify labeled expressions")
func testLabelCriteriaClassifyLabeledExpressions() throws {
  // Hand-written examples: label criteria should accept any label when
  // unspecified, require nil labels for `.mustBeNil`, and require an exact token
  // match for `.exactly`.
  let arguments = Array(try callArguments("call(first, label: second)").positionedLabeledExpressions)
  let unlabeled = arguments[0].labeledExpression
  let labeled = arguments[1].labeledExpression
  
  #expect(unlabeled.satisfies(labelCriterion: .unspecified))
  #expect(unlabeled.satisfies(labelCriterion: .mustBeNil))
  #expect(!unlabeled.satisfies(labelCriterion: .exactly("label")))
  #expect(labeled.satisfies(labelCriterion: .unspecified))
  #expect(!labeled.satisfies(labelCriterion: .mustBeNil))
  #expect(labeled.satisfies(labelCriterion: .exactly("label")))
  #expect(!labeled.satisfies(labelCriterion: .exactly("other")))
  
  #expect(LabelCriterion.unspecified.description == ".unspecified")
  #expect(LabelCriterion.mustBeNil.description == ".mustBeNil")
  #expect(LabelCriterion.unspecified.debugDescription == "LabelCriterion.unspecified")
  #expect(LabelCriterion.mustBeNil.debugDescription == "LabelCriterion.mustBeNil")
  #expect(LabelCriterion.exactly("label").description == ".exactly(\"label\")")
  #expect(LabelCriterion.exactly("label").debugDescription == "LabelCriterion.exactly(\"label\")")
}

@Test("Label criteria lists agree with element-wise satisfaction")
func testLabelCriteriaListsAgreeWithElementWiseSatisfaction() throws {
  // Property-style test: list-level label matching should be true exactly when
  // the criteria count matches the argument count and every paired element
  // satisfies its criterion.
  let arguments = try callArguments("call(first, label: second, other: third)")
  let criteriaSets: [[LabelCriterion]] = [
    [.mustBeNil, .exactly("label"), .exactly("other")],
    [.unspecified, .unspecified, .unspecified],
    [.mustBeNil, .exactly("other"), .exactly("label")],
    [.mustBeNil]
  ]
  
  for criteria in criteriaSets {
    let expected = criteria.count == arguments.count
    &&
    zip(arguments, criteria).allSatisfy { expression, criterion in
      expression.satisfies(labelCriterion: criterion)
    }
    
    #expect(arguments.satisfies(labelCriteria: criteria) == expected)
  }
}

@Test("Performance annotation disposition renders strongest valid annotations")
func testPerformanceAnnotationDispositionRendersStrongestValidAnnotations() {
  // Hand-written examples: the combined disposition should upgrade type and
  // stored-property inlinability to `@usableFromInline`, retain `@inlinable` for
  // functions, and omit explicit inline attributes where Swift does not allow
  // them.
  let fullHint = PerformanceAnnotationDisposition(
    inlinabilityDisposition: .inlinable,
    explicitInlineDisposition: .always
  )
  let noHint = PerformanceAnnotationDisposition(
    inlinabilityDisposition: nil,
    explicitInlineDisposition: nil
  )
  
  #expect(
    fullHint.performanceAnnotationSourceCodeRepresentation(
      visibilityLevel: .internal,
      attachmentSite: .functionOrMethodDeclaration
    )
    ==
    "@inlinable @inline(__always)\n"
  )
  #expect(
    fullHint.performanceAnnotationSourceCodeRepresentation(
      visibilityLevel: .internal,
      attachmentSite: .typeDeclaration,
      includeTrailingNewlineWhenNecessary: false
    )
    ==
    "@usableFromInline"
  )
  #expect(
    fullHint.performanceAnnotationSourceCodeRepresentation(
      visibilityLevel: .internal,
      attachmentSite: .storedPropertyDeclaration,
      separatorBetweenAnnotations: " | "
    )
    ==
    "@usableFromInline\n"
  )
  #expect(
    noHint.performanceAnnotationSourceCodeRepresentation(
      visibilityLevel: .private,
      attachmentSite: .functionOrMethodDeclaration
    )
    ==
    nil
  )
  #expect(PerformanceAnnotationDisposition.allCases.count == 9)
}

@Test("Performance annotation policy matches visibility and attachment matrices")
func testPerformanceAnnotationPolicyMatchesVisibilityAndAttachmentMatrices() {
  // Property-style test: across all visibility levels, attachment sites, and
  // hint combinations, the rendered annotation should equal the independently
  // tabulated strongest inlinability plus any attachment-appropriate explicit
  // inline disposition.
  for disposition in PerformanceAnnotationDisposition.allCases {
    for visibility in VisibilityLevel.allCases {
      for site in PerformanceAnnotationAttachmentSite.allCases {
        let expectedChunks = [
          expectedStrongestInlinability(
            site: site,
            visibility: visibility,
            hint: disposition.inlinabilityDisposition
          )?.sourceCodeStringRepresentation,
          disposition.explicitInlineDisposition
            .flatMap { expectedExplicitInline(site: site, disposition: $0) }?
            .sourceCodeStringRepresentation
        ].compactMap { $0 }
        let expected = expectedChunks.unlessEmpty?.joined(separator: " | ")
        
        #expect(
          disposition.performanceAnnotationSourceCodeRepresentation(
            visibilityLevel: visibility,
            attachmentSite: site,
            includeTrailingNewlineWhenNecessary: false,
            separatorBetweenAnnotations: " | "
          )
          ==
          expected
        )
        #expect(
          InlinabilityDisposition.strongestAvailableDisposition(
            attachmentSite: site,
            declarationVisibility: visibility,
            dispositionHint: disposition.inlinabilityDisposition
          )
          ==
          expectedStrongestInlinability(
            site: site,
            visibility: visibility,
            hint: disposition.inlinabilityDisposition
          )
        )
      }
    }
  }
}

@Test("Inline and transparent disposition helpers expose case semantics")
func testInlineAndTransparentDispositionHelpersExposeCaseSemantics() throws {
  // Hand-written examples: explicit inline dispositions render their source
  // attributes, are valid only for function/method sites, and transparent
  // disposition derives its name from its single case.
  #expect(ExplicitInlineDisposition.always.sourceCodeStringRepresentation == "@inline(__always)")
  #expect(ExplicitInlineDisposition.never.sourceCodeStringRepresentation == "@inline(never)")
  #expect(ExplicitInlineDisposition.always.appropriateDisposition(forAttachmentSite: .functionOrMethodDeclaration) == .always)
  #expect(ExplicitInlineDisposition.always.appropriateDisposition(forAttachmentSite: .typeDeclaration) == nil)
  #expect(ExplicitInlineDisposition.never.appropriateDisposition(forAttachmentSite: .storedPropertyDeclaration) == nil)
  #expect(ExplicitInlineDisposition(attributeArgument: "__always") == .always)
  #expect(ExplicitInlineDisposition(attributeArgument: "never") == .never)
  #expect(ExplicitInlineDisposition(attributeArgument: "sometimes") == nil)
  #expect(ExplicitInlineDisposition(attributeSyntax: AttributeSyntax("@inline(__always)")) == .always)
  #expect(ExplicitInlineDisposition(attributeSyntax: AttributeSyntax("@inline(never)")) == .never)
  #expect(ExplicitInlineDisposition(attributeSyntax: AttributeSyntax("@discardableResult")) == nil)
  #expect(InlinabilityDisposition(tokenSyntax: .identifier("discardableResult")) == nil)
  #expect(InlinabilityDisposition(attributeSyntax: AttributeSyntax("@inlinable(always)")) == nil)
  #expect(
    InlinabilityDisposition(
      attributeListElement: .ifConfigDecl(
        IfConfigDeclSyntax(
          clauses: IfConfigClauseListSyntax([])
        )
      )
    )
    ==
    nil
  )
  #expect(InlinabilityDisposition.inlinable.attributeSyntax.description == "@inlinable")
  #expect(InlinabilityDisposition.usableFromInline.attributeSyntax.description == "@usableFromInline")
  #expect(TransparentDisposition.transparent.caseNameWithoutLeadingDot == "transparent")
  #expect(TransparentDisposition.transparent.description == ".transparent")
  #expect(TransparentDisposition.transparent.debugDescription == "TransparentDisposition.Type.transparent")
}

@Test("Inline disposition helpers match case-derived source attributes")
func testInlineDispositionHelpersMatchCaseDerivedSourceAttributes() throws {
  // Property-style test: every explicit inline disposition should parse back
  // from its rendered attribute and should be returned unchanged only for the
  // function-or-method attachment site.
  for disposition in ExplicitInlineDisposition.allCases {
    #expect(ExplicitInlineDisposition(attributeSyntax: AttributeSyntax(stringLiteral: disposition.sourceCodeStringRepresentation)) == disposition)
    
    for site in PerformanceAnnotationAttachmentSite.allCases {
      let expected: ExplicitInlineDisposition? = site == .functionOrMethodDeclaration ? disposition : nil
      #expect(disposition.appropriateDisposition(forAttachmentSite: site) == expected)
    }
  }
  
  for disposition in InlinabilityDisposition.allCases {
    let identifier = try #require(
      disposition.attributeSyntax.attributeName.as(IdentifierTypeSyntax.self)
    )
    
    #expect(InlinabilityDisposition(attributeSyntax: disposition.attributeSyntax) == disposition)
    #expect(InlinabilityDisposition(tokenSyntax: identifier.name) == disposition)
  }
}

private func callArguments(
  _ expression: String
) throws -> LabeledExprListSyntax {
  try FunctionCallExprSyntax
    .firstParsed(from: "let value = \(expression)")
    .arguments
}

private func expectedStrongestInlinability(
  site: PerformanceAnnotationAttachmentSite,
  visibility: VisibilityLevel,
  hint: InlinabilityDisposition?
) -> InlinabilityDisposition? {
  switch site {
  case .functionOrMethodDeclaration:
    switch visibility {
    case .private, .fileprivate, .open:
      nil
    case .internal, .package:
      hint == nil ? nil : .inlinable
    case .public:
      .inlinable
    }
  case .typeDeclaration, .storedPropertyDeclaration:
    switch visibility {
    case .internal where hint != nil, .package where hint != nil:
      .usableFromInline
    default:
      nil
    }
  }
}

private func expectedExplicitInline(
  site: PerformanceAnnotationAttachmentSite,
  disposition: ExplicitInlineDisposition
) -> ExplicitInlineDisposition? {
  switch site {
  case .functionOrMethodDeclaration:
    disposition
  case .typeDeclaration, .storedPropertyDeclaration:
    nil
  }
}
