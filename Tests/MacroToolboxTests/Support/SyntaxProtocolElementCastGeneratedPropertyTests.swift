import SwiftSyntax
import Testing
@testable import MacroToolbox

private struct SyntaxCastConvenienceProbe: Sendable, CustomStringConvertible {
  let name: String
  let expectedMatch: @Sendable (Syntax) -> Bool
  let convenienceIsMatch: @Sendable (Syntax) -> Bool
  let convenienceAsMatch: @Sendable (Syntax) -> Bool

  var description: String {
    name
  }
}

private struct SyntaxCastSample: CustomStringConvertible {
  let name: String
  let syntax: Syntax

  var description: String {
    name
  }
}

private let syntaxCastConvenienceProbes: [SyntaxCastConvenienceProbe] = [
  SyntaxCastConvenienceProbe(
    name: "ABIAttributeArgumentsSyntax",
    expectedMatch: { $0.is(ABIAttributeArgumentsSyntax.self) },
    convenienceIsMatch: { $0.isABIAttributeArgumentsSyntax },
    convenienceAsMatch: { $0.asABIAttributeArgumentsSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AccessorBlockSyntax",
    expectedMatch: { $0.is(AccessorBlockSyntax.self) },
    convenienceIsMatch: { $0.isAccessorBlockSyntax },
    convenienceAsMatch: { $0.asAccessorBlockSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AccessorDeclListSyntax",
    expectedMatch: { $0.is(AccessorDeclListSyntax.self) },
    convenienceIsMatch: { $0.isAccessorDeclListSyntax },
    convenienceAsMatch: { $0.asAccessorDeclListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AccessorDeclSyntax",
    expectedMatch: { $0.is(AccessorDeclSyntax.self) },
    convenienceIsMatch: { $0.isAccessorDeclSyntax },
    convenienceAsMatch: { $0.asAccessorDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AccessorEffectSpecifiersSyntax",
    expectedMatch: { $0.is(AccessorEffectSpecifiersSyntax.self) },
    convenienceIsMatch: { $0.isAccessorEffectSpecifiersSyntax },
    convenienceAsMatch: { $0.asAccessorEffectSpecifiersSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AccessorParametersSyntax",
    expectedMatch: { $0.is(AccessorParametersSyntax.self) },
    convenienceIsMatch: { $0.isAccessorParametersSyntax },
    convenienceAsMatch: { $0.asAccessorParametersSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ActorDeclSyntax",
    expectedMatch: { $0.is(ActorDeclSyntax.self) },
    convenienceIsMatch: { $0.isActorDeclSyntax },
    convenienceAsMatch: { $0.asActorDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ArrayElementListSyntax",
    expectedMatch: { $0.is(ArrayElementListSyntax.self) },
    convenienceIsMatch: { $0.isArrayElementListSyntax },
    convenienceAsMatch: { $0.asArrayElementListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ArrayElementSyntax",
    expectedMatch: { $0.is(ArrayElementSyntax.self) },
    convenienceIsMatch: { $0.isArrayElementSyntax },
    convenienceAsMatch: { $0.asArrayElementSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ArrayExprSyntax",
    expectedMatch: { $0.is(ArrayExprSyntax.self) },
    convenienceIsMatch: { $0.isArrayExprSyntax },
    convenienceAsMatch: { $0.asArrayExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ArrayTypeSyntax",
    expectedMatch: { $0.is(ArrayTypeSyntax.self) },
    convenienceIsMatch: { $0.isArrayTypeSyntax },
    convenienceAsMatch: { $0.asArrayTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ArrowExprSyntax",
    expectedMatch: { $0.is(ArrowExprSyntax.self) },
    convenienceIsMatch: { $0.isArrowExprSyntax },
    convenienceAsMatch: { $0.asArrowExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AsExprSyntax",
    expectedMatch: { $0.is(AsExprSyntax.self) },
    convenienceIsMatch: { $0.isAsExprSyntax },
    convenienceAsMatch: { $0.asAsExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AssignmentExprSyntax",
    expectedMatch: { $0.is(AssignmentExprSyntax.self) },
    convenienceIsMatch: { $0.isAssignmentExprSyntax },
    convenienceAsMatch: { $0.asAssignmentExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AssociatedTypeDeclSyntax",
    expectedMatch: { $0.is(AssociatedTypeDeclSyntax.self) },
    convenienceIsMatch: { $0.isAssociatedTypeDeclSyntax },
    convenienceAsMatch: { $0.asAssociatedTypeDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AttributeListSyntax",
    expectedMatch: { $0.is(AttributeListSyntax.self) },
    convenienceIsMatch: { $0.isAttributeListSyntax },
    convenienceAsMatch: { $0.asAttributeListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AttributeSyntax",
    expectedMatch: { $0.is(AttributeSyntax.self) },
    convenienceIsMatch: { $0.isAttributeSyntax },
    convenienceAsMatch: { $0.asAttributeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AttributedTypeSyntax",
    expectedMatch: { $0.is(AttributedTypeSyntax.self) },
    convenienceIsMatch: { $0.isAttributedTypeSyntax },
    convenienceAsMatch: { $0.asAttributedTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AvailabilityArgumentListSyntax",
    expectedMatch: { $0.is(AvailabilityArgumentListSyntax.self) },
    convenienceIsMatch: { $0.isAvailabilityArgumentListSyntax },
    convenienceAsMatch: { $0.asAvailabilityArgumentListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AvailabilityArgumentSyntax",
    expectedMatch: { $0.is(AvailabilityArgumentSyntax.self) },
    convenienceIsMatch: { $0.isAvailabilityArgumentSyntax },
    convenienceAsMatch: { $0.asAvailabilityArgumentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AvailabilityConditionSyntax",
    expectedMatch: { $0.is(AvailabilityConditionSyntax.self) },
    convenienceIsMatch: { $0.isAvailabilityConditionSyntax },
    convenienceAsMatch: { $0.asAvailabilityConditionSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AvailabilityLabeledArgumentSyntax",
    expectedMatch: { $0.is(AvailabilityLabeledArgumentSyntax.self) },
    convenienceIsMatch: { $0.isAvailabilityLabeledArgumentSyntax },
    convenienceAsMatch: { $0.asAvailabilityLabeledArgumentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "AwaitExprSyntax",
    expectedMatch: { $0.is(AwaitExprSyntax.self) },
    convenienceIsMatch: { $0.isAwaitExprSyntax },
    convenienceAsMatch: { $0.asAwaitExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "BackDeployedAttributeArgumentsSyntax",
    expectedMatch: { $0.is(BackDeployedAttributeArgumentsSyntax.self) },
    convenienceIsMatch: { $0.isBackDeployedAttributeArgumentsSyntax },
    convenienceAsMatch: { $0.asBackDeployedAttributeArgumentsSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "BinaryOperatorExprSyntax",
    expectedMatch: { $0.is(BinaryOperatorExprSyntax.self) },
    convenienceIsMatch: { $0.isBinaryOperatorExprSyntax },
    convenienceAsMatch: { $0.asBinaryOperatorExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "BooleanLiteralExprSyntax",
    expectedMatch: { $0.is(BooleanLiteralExprSyntax.self) },
    convenienceIsMatch: { $0.isBooleanLiteralExprSyntax },
    convenienceAsMatch: { $0.asBooleanLiteralExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "BorrowExprSyntax",
    expectedMatch: { $0.is(BorrowExprSyntax.self) },
    convenienceIsMatch: { $0.isBorrowExprSyntax },
    convenienceAsMatch: { $0.asBorrowExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "BreakStmtSyntax",
    expectedMatch: { $0.is(BreakStmtSyntax.self) },
    convenienceIsMatch: { $0.isBreakStmtSyntax },
    convenienceAsMatch: { $0.asBreakStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "CatchClauseListSyntax",
    expectedMatch: { $0.is(CatchClauseListSyntax.self) },
    convenienceIsMatch: { $0.isCatchClauseListSyntax },
    convenienceAsMatch: { $0.asCatchClauseListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "CatchClauseSyntax",
    expectedMatch: { $0.is(CatchClauseSyntax.self) },
    convenienceIsMatch: { $0.isCatchClauseSyntax },
    convenienceAsMatch: { $0.asCatchClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "CatchItemListSyntax",
    expectedMatch: { $0.is(CatchItemListSyntax.self) },
    convenienceIsMatch: { $0.isCatchItemListSyntax },
    convenienceAsMatch: { $0.asCatchItemListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "CatchItemSyntax",
    expectedMatch: { $0.is(CatchItemSyntax.self) },
    convenienceIsMatch: { $0.isCatchItemSyntax },
    convenienceAsMatch: { $0.asCatchItemSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ClassDeclSyntax",
    expectedMatch: { $0.is(ClassDeclSyntax.self) },
    convenienceIsMatch: { $0.isClassDeclSyntax },
    convenienceAsMatch: { $0.asClassDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ClassRestrictionTypeSyntax",
    expectedMatch: { $0.is(ClassRestrictionTypeSyntax.self) },
    convenienceIsMatch: { $0.isClassRestrictionTypeSyntax },
    convenienceAsMatch: { $0.asClassRestrictionTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ClosureCaptureClauseSyntax",
    expectedMatch: { $0.is(ClosureCaptureClauseSyntax.self) },
    convenienceIsMatch: { $0.isClosureCaptureClauseSyntax },
    convenienceAsMatch: { $0.asClosureCaptureClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ClosureCaptureListSyntax",
    expectedMatch: { $0.is(ClosureCaptureListSyntax.self) },
    convenienceIsMatch: { $0.isClosureCaptureListSyntax },
    convenienceAsMatch: { $0.asClosureCaptureListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ClosureCaptureSpecifierSyntax",
    expectedMatch: { $0.is(ClosureCaptureSpecifierSyntax.self) },
    convenienceIsMatch: { $0.isClosureCaptureSpecifierSyntax },
    convenienceAsMatch: { $0.asClosureCaptureSpecifierSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ClosureCaptureSyntax",
    expectedMatch: { $0.is(ClosureCaptureSyntax.self) },
    convenienceIsMatch: { $0.isClosureCaptureSyntax },
    convenienceAsMatch: { $0.asClosureCaptureSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ClosureExprSyntax",
    expectedMatch: { $0.is(ClosureExprSyntax.self) },
    convenienceIsMatch: { $0.isClosureExprSyntax },
    convenienceAsMatch: { $0.asClosureExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ClosureParameterClauseSyntax",
    expectedMatch: { $0.is(ClosureParameterClauseSyntax.self) },
    convenienceIsMatch: { $0.isClosureParameterClauseSyntax },
    convenienceAsMatch: { $0.asClosureParameterClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ClosureParameterListSyntax",
    expectedMatch: { $0.is(ClosureParameterListSyntax.self) },
    convenienceIsMatch: { $0.isClosureParameterListSyntax },
    convenienceAsMatch: { $0.asClosureParameterListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ClosureParameterSyntax",
    expectedMatch: { $0.is(ClosureParameterSyntax.self) },
    convenienceIsMatch: { $0.isClosureParameterSyntax },
    convenienceAsMatch: { $0.asClosureParameterSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ClosureShorthandParameterListSyntax",
    expectedMatch: { $0.is(ClosureShorthandParameterListSyntax.self) },
    convenienceIsMatch: { $0.isClosureShorthandParameterListSyntax },
    convenienceAsMatch: { $0.asClosureShorthandParameterListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ClosureShorthandParameterSyntax",
    expectedMatch: { $0.is(ClosureShorthandParameterSyntax.self) },
    convenienceIsMatch: { $0.isClosureShorthandParameterSyntax },
    convenienceAsMatch: { $0.asClosureShorthandParameterSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ClosureSignatureSyntax",
    expectedMatch: { $0.is(ClosureSignatureSyntax.self) },
    convenienceIsMatch: { $0.isClosureSignatureSyntax },
    convenienceAsMatch: { $0.asClosureSignatureSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "CodeBlockItemListSyntax",
    expectedMatch: { $0.is(CodeBlockItemListSyntax.self) },
    convenienceIsMatch: { $0.isCodeBlockItemListSyntax },
    convenienceAsMatch: { $0.asCodeBlockItemListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "CodeBlockItemSyntax",
    expectedMatch: { $0.is(CodeBlockItemSyntax.self) },
    convenienceIsMatch: { $0.isCodeBlockItemSyntax },
    convenienceAsMatch: { $0.asCodeBlockItemSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "CodeBlockSyntax",
    expectedMatch: { $0.is(CodeBlockSyntax.self) },
    convenienceIsMatch: { $0.isCodeBlockSyntax },
    convenienceAsMatch: { $0.asCodeBlockSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "CompositionTypeElementListSyntax",
    expectedMatch: { $0.is(CompositionTypeElementListSyntax.self) },
    convenienceIsMatch: { $0.isCompositionTypeElementListSyntax },
    convenienceAsMatch: { $0.asCompositionTypeElementListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "CompositionTypeElementSyntax",
    expectedMatch: { $0.is(CompositionTypeElementSyntax.self) },
    convenienceIsMatch: { $0.isCompositionTypeElementSyntax },
    convenienceAsMatch: { $0.asCompositionTypeElementSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "CompositionTypeSyntax",
    expectedMatch: { $0.is(CompositionTypeSyntax.self) },
    convenienceIsMatch: { $0.isCompositionTypeSyntax },
    convenienceAsMatch: { $0.asCompositionTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ConditionElementListSyntax",
    expectedMatch: { $0.is(ConditionElementListSyntax.self) },
    convenienceIsMatch: { $0.isConditionElementListSyntax },
    convenienceAsMatch: { $0.asConditionElementListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ConditionElementSyntax",
    expectedMatch: { $0.is(ConditionElementSyntax.self) },
    convenienceIsMatch: { $0.isConditionElementSyntax },
    convenienceAsMatch: { $0.asConditionElementSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ConformanceRequirementSyntax",
    expectedMatch: { $0.is(ConformanceRequirementSyntax.self) },
    convenienceIsMatch: { $0.isConformanceRequirementSyntax },
    convenienceAsMatch: { $0.asConformanceRequirementSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ConsumeExprSyntax",
    expectedMatch: { $0.is(ConsumeExprSyntax.self) },
    convenienceIsMatch: { $0.isConsumeExprSyntax },
    convenienceAsMatch: { $0.asConsumeExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ContinueStmtSyntax",
    expectedMatch: { $0.is(ContinueStmtSyntax.self) },
    convenienceIsMatch: { $0.isContinueStmtSyntax },
    convenienceAsMatch: { $0.asContinueStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "CopyExprSyntax",
    expectedMatch: { $0.is(CopyExprSyntax.self) },
    convenienceIsMatch: { $0.isCopyExprSyntax },
    convenienceAsMatch: { $0.asCopyExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DeclModifierDetailSyntax",
    expectedMatch: { $0.is(DeclModifierDetailSyntax.self) },
    convenienceIsMatch: { $0.isDeclModifierDetailSyntax },
    convenienceAsMatch: { $0.asDeclModifierDetailSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DeclModifierListSyntax",
    expectedMatch: { $0.is(DeclModifierListSyntax.self) },
    convenienceIsMatch: { $0.isDeclModifierListSyntax },
    convenienceAsMatch: { $0.asDeclModifierListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DeclModifierSyntax",
    expectedMatch: { $0.is(DeclModifierSyntax.self) },
    convenienceIsMatch: { $0.isDeclModifierSyntax },
    convenienceAsMatch: { $0.asDeclModifierSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DeclNameArgumentListSyntax",
    expectedMatch: { $0.is(DeclNameArgumentListSyntax.self) },
    convenienceIsMatch: { $0.isDeclNameArgumentListSyntax },
    convenienceAsMatch: { $0.asDeclNameArgumentListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DeclNameArgumentSyntax",
    expectedMatch: { $0.is(DeclNameArgumentSyntax.self) },
    convenienceIsMatch: { $0.isDeclNameArgumentSyntax },
    convenienceAsMatch: { $0.asDeclNameArgumentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DeclNameArgumentsSyntax",
    expectedMatch: { $0.is(DeclNameArgumentsSyntax.self) },
    convenienceIsMatch: { $0.isDeclNameArgumentsSyntax },
    convenienceAsMatch: { $0.asDeclNameArgumentsSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DeclReferenceExprSyntax",
    expectedMatch: { $0.is(DeclReferenceExprSyntax.self) },
    convenienceIsMatch: { $0.isDeclReferenceExprSyntax },
    convenienceAsMatch: { $0.asDeclReferenceExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DeclSyntax",
    expectedMatch: { $0.is(DeclSyntax.self) },
    convenienceIsMatch: { $0.isDeclSyntax },
    convenienceAsMatch: { $0.asDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DeferStmtSyntax",
    expectedMatch: { $0.is(DeferStmtSyntax.self) },
    convenienceIsMatch: { $0.isDeferStmtSyntax },
    convenienceAsMatch: { $0.asDeferStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DeinitializerDeclSyntax",
    expectedMatch: { $0.is(DeinitializerDeclSyntax.self) },
    convenienceIsMatch: { $0.isDeinitializerDeclSyntax },
    convenienceAsMatch: { $0.asDeinitializerDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DeinitializerEffectSpecifiersSyntax",
    expectedMatch: { $0.is(DeinitializerEffectSpecifiersSyntax.self) },
    convenienceIsMatch: { $0.isDeinitializerEffectSpecifiersSyntax },
    convenienceAsMatch: { $0.asDeinitializerEffectSpecifiersSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DerivativeAttributeArgumentsSyntax",
    expectedMatch: { $0.is(DerivativeAttributeArgumentsSyntax.self) },
    convenienceIsMatch: { $0.isDerivativeAttributeArgumentsSyntax },
    convenienceAsMatch: { $0.asDerivativeAttributeArgumentsSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DesignatedTypeListSyntax",
    expectedMatch: { $0.is(DesignatedTypeListSyntax.self) },
    convenienceIsMatch: { $0.isDesignatedTypeListSyntax },
    convenienceAsMatch: { $0.asDesignatedTypeListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DesignatedTypeSyntax",
    expectedMatch: { $0.is(DesignatedTypeSyntax.self) },
    convenienceIsMatch: { $0.isDesignatedTypeSyntax },
    convenienceAsMatch: { $0.asDesignatedTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DictionaryElementListSyntax",
    expectedMatch: { $0.is(DictionaryElementListSyntax.self) },
    convenienceIsMatch: { $0.isDictionaryElementListSyntax },
    convenienceAsMatch: { $0.asDictionaryElementListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DictionaryElementSyntax",
    expectedMatch: { $0.is(DictionaryElementSyntax.self) },
    convenienceIsMatch: { $0.isDictionaryElementSyntax },
    convenienceAsMatch: { $0.asDictionaryElementSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DictionaryExprSyntax",
    expectedMatch: { $0.is(DictionaryExprSyntax.self) },
    convenienceIsMatch: { $0.isDictionaryExprSyntax },
    convenienceAsMatch: { $0.asDictionaryExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DictionaryTypeSyntax",
    expectedMatch: { $0.is(DictionaryTypeSyntax.self) },
    convenienceIsMatch: { $0.isDictionaryTypeSyntax },
    convenienceAsMatch: { $0.asDictionaryTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DifferentiabilityArgumentListSyntax",
    expectedMatch: { $0.is(DifferentiabilityArgumentListSyntax.self) },
    convenienceIsMatch: { $0.isDifferentiabilityArgumentListSyntax },
    convenienceAsMatch: { $0.asDifferentiabilityArgumentListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DifferentiabilityArgumentSyntax",
    expectedMatch: { $0.is(DifferentiabilityArgumentSyntax.self) },
    convenienceIsMatch: { $0.isDifferentiabilityArgumentSyntax },
    convenienceAsMatch: { $0.asDifferentiabilityArgumentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DifferentiabilityArgumentsSyntax",
    expectedMatch: { $0.is(DifferentiabilityArgumentsSyntax.self) },
    convenienceIsMatch: { $0.isDifferentiabilityArgumentsSyntax },
    convenienceAsMatch: { $0.asDifferentiabilityArgumentsSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DifferentiabilityWithRespectToArgumentSyntax",
    expectedMatch: { $0.is(DifferentiabilityWithRespectToArgumentSyntax.self) },
    convenienceIsMatch: { $0.isDifferentiabilityWithRespectToArgumentSyntax },
    convenienceAsMatch: { $0.asDifferentiabilityWithRespectToArgumentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DifferentiableAttributeArgumentsSyntax",
    expectedMatch: { $0.is(DifferentiableAttributeArgumentsSyntax.self) },
    convenienceIsMatch: { $0.isDifferentiableAttributeArgumentsSyntax },
    convenienceAsMatch: { $0.asDifferentiableAttributeArgumentsSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DiscardAssignmentExprSyntax",
    expectedMatch: { $0.is(DiscardAssignmentExprSyntax.self) },
    convenienceIsMatch: { $0.isDiscardAssignmentExprSyntax },
    convenienceAsMatch: { $0.asDiscardAssignmentExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DiscardStmtSyntax",
    expectedMatch: { $0.is(DiscardStmtSyntax.self) },
    convenienceIsMatch: { $0.isDiscardStmtSyntax },
    convenienceAsMatch: { $0.asDiscardStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DoStmtSyntax",
    expectedMatch: { $0.is(DoStmtSyntax.self) },
    convenienceIsMatch: { $0.isDoStmtSyntax },
    convenienceAsMatch: { $0.asDoStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DocumentationAttributeArgumentListSyntax",
    expectedMatch: { $0.is(DocumentationAttributeArgumentListSyntax.self) },
    convenienceIsMatch: { $0.isDocumentationAttributeArgumentListSyntax },
    convenienceAsMatch: { $0.asDocumentationAttributeArgumentListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DocumentationAttributeArgumentSyntax",
    expectedMatch: { $0.is(DocumentationAttributeArgumentSyntax.self) },
    convenienceIsMatch: { $0.isDocumentationAttributeArgumentSyntax },
    convenienceAsMatch: { $0.asDocumentationAttributeArgumentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "DynamicReplacementAttributeArgumentsSyntax",
    expectedMatch: { $0.is(DynamicReplacementAttributeArgumentsSyntax.self) },
    convenienceIsMatch: { $0.isDynamicReplacementAttributeArgumentsSyntax },
    convenienceAsMatch: { $0.asDynamicReplacementAttributeArgumentsSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "EditorPlaceholderDeclSyntax",
    expectedMatch: { $0.is(EditorPlaceholderDeclSyntax.self) },
    convenienceIsMatch: { $0.isEditorPlaceholderDeclSyntax },
    convenienceAsMatch: { $0.asEditorPlaceholderDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "EditorPlaceholderExprSyntax",
    expectedMatch: { $0.is(EditorPlaceholderExprSyntax.self) },
    convenienceIsMatch: { $0.isEditorPlaceholderExprSyntax },
    convenienceAsMatch: { $0.asEditorPlaceholderExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "EffectsAttributeArgumentListSyntax",
    expectedMatch: { $0.is(EffectsAttributeArgumentListSyntax.self) },
    convenienceIsMatch: { $0.isEffectsAttributeArgumentListSyntax },
    convenienceAsMatch: { $0.asEffectsAttributeArgumentListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "EnumCaseDeclSyntax",
    expectedMatch: { $0.is(EnumCaseDeclSyntax.self) },
    convenienceIsMatch: { $0.isEnumCaseDeclSyntax },
    convenienceAsMatch: { $0.asEnumCaseDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "EnumCaseElementListSyntax",
    expectedMatch: { $0.is(EnumCaseElementListSyntax.self) },
    convenienceIsMatch: { $0.isEnumCaseElementListSyntax },
    convenienceAsMatch: { $0.asEnumCaseElementListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "EnumCaseElementSyntax",
    expectedMatch: { $0.is(EnumCaseElementSyntax.self) },
    convenienceIsMatch: { $0.isEnumCaseElementSyntax },
    convenienceAsMatch: { $0.asEnumCaseElementSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "EnumCaseParameterClauseSyntax",
    expectedMatch: { $0.is(EnumCaseParameterClauseSyntax.self) },
    convenienceIsMatch: { $0.isEnumCaseParameterClauseSyntax },
    convenienceAsMatch: { $0.asEnumCaseParameterClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "EnumCaseParameterListSyntax",
    expectedMatch: { $0.is(EnumCaseParameterListSyntax.self) },
    convenienceIsMatch: { $0.isEnumCaseParameterListSyntax },
    convenienceAsMatch: { $0.asEnumCaseParameterListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "EnumCaseParameterSyntax",
    expectedMatch: { $0.is(EnumCaseParameterSyntax.self) },
    convenienceIsMatch: { $0.isEnumCaseParameterSyntax },
    convenienceAsMatch: { $0.asEnumCaseParameterSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "EnumDeclSyntax",
    expectedMatch: { $0.is(EnumDeclSyntax.self) },
    convenienceIsMatch: { $0.isEnumDeclSyntax },
    convenienceAsMatch: { $0.asEnumDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ExprListSyntax",
    expectedMatch: { $0.is(ExprListSyntax.self) },
    convenienceIsMatch: { $0.isExprListSyntax },
    convenienceAsMatch: { $0.asExprListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ExprSyntax",
    expectedMatch: { $0.is(ExprSyntax.self) },
    convenienceIsMatch: { $0.isExprSyntax },
    convenienceAsMatch: { $0.asExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ExpressionPatternSyntax",
    expectedMatch: { $0.is(ExpressionPatternSyntax.self) },
    convenienceIsMatch: { $0.isExpressionPatternSyntax },
    convenienceAsMatch: { $0.asExpressionPatternSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ExpressionSegmentSyntax",
    expectedMatch: { $0.is(ExpressionSegmentSyntax.self) },
    convenienceIsMatch: { $0.isExpressionSegmentSyntax },
    convenienceAsMatch: { $0.asExpressionSegmentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ExpressionStmtSyntax",
    expectedMatch: { $0.is(ExpressionStmtSyntax.self) },
    convenienceIsMatch: { $0.isExpressionStmtSyntax },
    convenienceAsMatch: { $0.asExpressionStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ExtensionDeclSyntax",
    expectedMatch: { $0.is(ExtensionDeclSyntax.self) },
    convenienceIsMatch: { $0.isExtensionDeclSyntax },
    convenienceAsMatch: { $0.asExtensionDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "FallThroughStmtSyntax",
    expectedMatch: { $0.is(FallThroughStmtSyntax.self) },
    convenienceIsMatch: { $0.isFallThroughStmtSyntax },
    convenienceAsMatch: { $0.asFallThroughStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "FloatLiteralExprSyntax",
    expectedMatch: { $0.is(FloatLiteralExprSyntax.self) },
    convenienceIsMatch: { $0.isFloatLiteralExprSyntax },
    convenienceAsMatch: { $0.asFloatLiteralExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ForStmtSyntax",
    expectedMatch: { $0.is(ForStmtSyntax.self) },
    convenienceIsMatch: { $0.isForStmtSyntax },
    convenienceAsMatch: { $0.asForStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ForceUnwrapExprSyntax",
    expectedMatch: { $0.is(ForceUnwrapExprSyntax.self) },
    convenienceIsMatch: { $0.isForceUnwrapExprSyntax },
    convenienceAsMatch: { $0.asForceUnwrapExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "FunctionCallExprSyntax",
    expectedMatch: { $0.is(FunctionCallExprSyntax.self) },
    convenienceIsMatch: { $0.isFunctionCallExprSyntax },
    convenienceAsMatch: { $0.asFunctionCallExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "FunctionDeclSyntax",
    expectedMatch: { $0.is(FunctionDeclSyntax.self) },
    convenienceIsMatch: { $0.isFunctionDeclSyntax },
    convenienceAsMatch: { $0.asFunctionDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "FunctionEffectSpecifiersSyntax",
    expectedMatch: { $0.is(FunctionEffectSpecifiersSyntax.self) },
    convenienceIsMatch: { $0.isFunctionEffectSpecifiersSyntax },
    convenienceAsMatch: { $0.asFunctionEffectSpecifiersSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "FunctionParameterClauseSyntax",
    expectedMatch: { $0.is(FunctionParameterClauseSyntax.self) },
    convenienceIsMatch: { $0.isFunctionParameterClauseSyntax },
    convenienceAsMatch: { $0.asFunctionParameterClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "FunctionParameterListSyntax",
    expectedMatch: { $0.is(FunctionParameterListSyntax.self) },
    convenienceIsMatch: { $0.isFunctionParameterListSyntax },
    convenienceAsMatch: { $0.asFunctionParameterListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "FunctionParameterSyntax",
    expectedMatch: { $0.is(FunctionParameterSyntax.self) },
    convenienceIsMatch: { $0.isFunctionParameterSyntax },
    convenienceAsMatch: { $0.asFunctionParameterSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "FunctionSignatureSyntax",
    expectedMatch: { $0.is(FunctionSignatureSyntax.self) },
    convenienceIsMatch: { $0.isFunctionSignatureSyntax },
    convenienceAsMatch: { $0.asFunctionSignatureSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "FunctionTypeSyntax",
    expectedMatch: { $0.is(FunctionTypeSyntax.self) },
    convenienceIsMatch: { $0.isFunctionTypeSyntax },
    convenienceAsMatch: { $0.asFunctionTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "GenericArgumentClauseSyntax",
    expectedMatch: { $0.is(GenericArgumentClauseSyntax.self) },
    convenienceIsMatch: { $0.isGenericArgumentClauseSyntax },
    convenienceAsMatch: { $0.asGenericArgumentClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "GenericArgumentListSyntax",
    expectedMatch: { $0.is(GenericArgumentListSyntax.self) },
    convenienceIsMatch: { $0.isGenericArgumentListSyntax },
    convenienceAsMatch: { $0.asGenericArgumentListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "GenericArgumentSyntax",
    expectedMatch: { $0.is(GenericArgumentSyntax.self) },
    convenienceIsMatch: { $0.isGenericArgumentSyntax },
    convenienceAsMatch: { $0.asGenericArgumentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "GenericParameterClauseSyntax",
    expectedMatch: { $0.is(GenericParameterClauseSyntax.self) },
    convenienceIsMatch: { $0.isGenericParameterClauseSyntax },
    convenienceAsMatch: { $0.asGenericParameterClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "GenericParameterListSyntax",
    expectedMatch: { $0.is(GenericParameterListSyntax.self) },
    convenienceIsMatch: { $0.isGenericParameterListSyntax },
    convenienceAsMatch: { $0.asGenericParameterListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "GenericParameterSyntax",
    expectedMatch: { $0.is(GenericParameterSyntax.self) },
    convenienceIsMatch: { $0.isGenericParameterSyntax },
    convenienceAsMatch: { $0.asGenericParameterSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "GenericRequirementListSyntax",
    expectedMatch: { $0.is(GenericRequirementListSyntax.self) },
    convenienceIsMatch: { $0.isGenericRequirementListSyntax },
    convenienceAsMatch: { $0.asGenericRequirementListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "GenericRequirementSyntax",
    expectedMatch: { $0.is(GenericRequirementSyntax.self) },
    convenienceIsMatch: { $0.isGenericRequirementSyntax },
    convenienceAsMatch: { $0.asGenericRequirementSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "GenericSpecializationExprSyntax",
    expectedMatch: { $0.is(GenericSpecializationExprSyntax.self) },
    convenienceIsMatch: { $0.isGenericSpecializationExprSyntax },
    convenienceAsMatch: { $0.asGenericSpecializationExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "GenericWhereClauseSyntax",
    expectedMatch: { $0.is(GenericWhereClauseSyntax.self) },
    convenienceIsMatch: { $0.isGenericWhereClauseSyntax },
    convenienceAsMatch: { $0.asGenericWhereClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "GuardStmtSyntax",
    expectedMatch: { $0.is(GuardStmtSyntax.self) },
    convenienceIsMatch: { $0.isGuardStmtSyntax },
    convenienceAsMatch: { $0.asGuardStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "IdentifierPatternSyntax",
    expectedMatch: { $0.is(IdentifierPatternSyntax.self) },
    convenienceIsMatch: { $0.isIdentifierPatternSyntax },
    convenienceAsMatch: { $0.asIdentifierPatternSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "IdentifierTypeSyntax",
    expectedMatch: { $0.is(IdentifierTypeSyntax.self) },
    convenienceIsMatch: { $0.isIdentifierTypeSyntax },
    convenienceAsMatch: { $0.asIdentifierTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "IfConfigClauseListSyntax",
    expectedMatch: { $0.is(IfConfigClauseListSyntax.self) },
    convenienceIsMatch: { $0.isIfConfigClauseListSyntax },
    convenienceAsMatch: { $0.asIfConfigClauseListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "IfConfigClauseSyntax",
    expectedMatch: { $0.is(IfConfigClauseSyntax.self) },
    convenienceIsMatch: { $0.isIfConfigClauseSyntax },
    convenienceAsMatch: { $0.asIfConfigClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "IfConfigDeclSyntax",
    expectedMatch: { $0.is(IfConfigDeclSyntax.self) },
    convenienceIsMatch: { $0.isIfConfigDeclSyntax },
    convenienceAsMatch: { $0.asIfConfigDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "IfExprSyntax",
    expectedMatch: { $0.is(IfExprSyntax.self) },
    convenienceIsMatch: { $0.isIfExprSyntax },
    convenienceAsMatch: { $0.asIfExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ImplementsAttributeArgumentsSyntax",
    expectedMatch: { $0.is(ImplementsAttributeArgumentsSyntax.self) },
    convenienceIsMatch: { $0.isImplementsAttributeArgumentsSyntax },
    convenienceAsMatch: { $0.asImplementsAttributeArgumentsSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ImplicitlyUnwrappedOptionalTypeSyntax",
    expectedMatch: { $0.is(ImplicitlyUnwrappedOptionalTypeSyntax.self) },
    convenienceIsMatch: { $0.isImplicitlyUnwrappedOptionalTypeSyntax },
    convenienceAsMatch: { $0.asImplicitlyUnwrappedOptionalTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ImportDeclSyntax",
    expectedMatch: { $0.is(ImportDeclSyntax.self) },
    convenienceIsMatch: { $0.isImportDeclSyntax },
    convenienceAsMatch: { $0.asImportDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ImportPathComponentListSyntax",
    expectedMatch: { $0.is(ImportPathComponentListSyntax.self) },
    convenienceIsMatch: { $0.isImportPathComponentListSyntax },
    convenienceAsMatch: { $0.asImportPathComponentListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ImportPathComponentSyntax",
    expectedMatch: { $0.is(ImportPathComponentSyntax.self) },
    convenienceIsMatch: { $0.isImportPathComponentSyntax },
    convenienceAsMatch: { $0.asImportPathComponentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "InOutExprSyntax",
    expectedMatch: { $0.is(InOutExprSyntax.self) },
    convenienceIsMatch: { $0.isInOutExprSyntax },
    convenienceAsMatch: { $0.asInOutExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "InfixOperatorExprSyntax",
    expectedMatch: { $0.is(InfixOperatorExprSyntax.self) },
    convenienceIsMatch: { $0.isInfixOperatorExprSyntax },
    convenienceAsMatch: { $0.asInfixOperatorExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "InheritanceClauseSyntax",
    expectedMatch: { $0.is(InheritanceClauseSyntax.self) },
    convenienceIsMatch: { $0.isInheritanceClauseSyntax },
    convenienceAsMatch: { $0.asInheritanceClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "InheritedTypeListSyntax",
    expectedMatch: { $0.is(InheritedTypeListSyntax.self) },
    convenienceIsMatch: { $0.isInheritedTypeListSyntax },
    convenienceAsMatch: { $0.asInheritedTypeListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "InheritedTypeSyntax",
    expectedMatch: { $0.is(InheritedTypeSyntax.self) },
    convenienceIsMatch: { $0.isInheritedTypeSyntax },
    convenienceAsMatch: { $0.asInheritedTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "InitializerClauseSyntax",
    expectedMatch: { $0.is(InitializerClauseSyntax.self) },
    convenienceIsMatch: { $0.isInitializerClauseSyntax },
    convenienceAsMatch: { $0.asInitializerClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "InitializerDeclSyntax",
    expectedMatch: { $0.is(InitializerDeclSyntax.self) },
    convenienceIsMatch: { $0.isInitializerDeclSyntax },
    convenienceAsMatch: { $0.asInitializerDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "InlineArrayTypeSyntax",
    expectedMatch: { $0.is(InlineArrayTypeSyntax.self) },
    convenienceIsMatch: { $0.isInlineArrayTypeSyntax },
    convenienceAsMatch: { $0.asInlineArrayTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "IntegerLiteralExprSyntax",
    expectedMatch: { $0.is(IntegerLiteralExprSyntax.self) },
    convenienceIsMatch: { $0.isIntegerLiteralExprSyntax },
    convenienceAsMatch: { $0.asIntegerLiteralExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "IsExprSyntax",
    expectedMatch: { $0.is(IsExprSyntax.self) },
    convenienceIsMatch: { $0.isIsExprSyntax },
    convenienceAsMatch: { $0.asIsExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "IsTypePatternSyntax",
    expectedMatch: { $0.is(IsTypePatternSyntax.self) },
    convenienceIsMatch: { $0.isIsTypePatternSyntax },
    convenienceAsMatch: { $0.asIsTypePatternSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "KeyPathComponentListSyntax",
    expectedMatch: { $0.is(KeyPathComponentListSyntax.self) },
    convenienceIsMatch: { $0.isKeyPathComponentListSyntax },
    convenienceAsMatch: { $0.asKeyPathComponentListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "KeyPathComponentSyntax",
    expectedMatch: { $0.is(KeyPathComponentSyntax.self) },
    convenienceIsMatch: { $0.isKeyPathComponentSyntax },
    convenienceAsMatch: { $0.asKeyPathComponentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "KeyPathExprSyntax",
    expectedMatch: { $0.is(KeyPathExprSyntax.self) },
    convenienceIsMatch: { $0.isKeyPathExprSyntax },
    convenienceAsMatch: { $0.asKeyPathExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "KeyPathOptionalComponentSyntax",
    expectedMatch: { $0.is(KeyPathOptionalComponentSyntax.self) },
    convenienceIsMatch: { $0.isKeyPathOptionalComponentSyntax },
    convenienceAsMatch: { $0.asKeyPathOptionalComponentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "KeyPathPropertyComponentSyntax",
    expectedMatch: { $0.is(KeyPathPropertyComponentSyntax.self) },
    convenienceIsMatch: { $0.isKeyPathPropertyComponentSyntax },
    convenienceAsMatch: { $0.asKeyPathPropertyComponentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "KeyPathSubscriptComponentSyntax",
    expectedMatch: { $0.is(KeyPathSubscriptComponentSyntax.self) },
    convenienceIsMatch: { $0.isKeyPathSubscriptComponentSyntax },
    convenienceAsMatch: { $0.asKeyPathSubscriptComponentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "LabeledExprListSyntax",
    expectedMatch: { $0.is(LabeledExprListSyntax.self) },
    convenienceIsMatch: { $0.isLabeledExprListSyntax },
    convenienceAsMatch: { $0.asLabeledExprListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "LabeledExprSyntax",
    expectedMatch: { $0.is(LabeledExprSyntax.self) },
    convenienceIsMatch: { $0.isLabeledExprSyntax },
    convenienceAsMatch: { $0.asLabeledExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "LabeledSpecializeArgumentSyntax",
    expectedMatch: { $0.is(LabeledSpecializeArgumentSyntax.self) },
    convenienceIsMatch: { $0.isLabeledSpecializeArgumentSyntax },
    convenienceAsMatch: { $0.asLabeledSpecializeArgumentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "LabeledStmtSyntax",
    expectedMatch: { $0.is(LabeledStmtSyntax.self) },
    convenienceIsMatch: { $0.isLabeledStmtSyntax },
    convenienceAsMatch: { $0.asLabeledStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "LayoutRequirementSyntax",
    expectedMatch: { $0.is(LayoutRequirementSyntax.self) },
    convenienceIsMatch: { $0.isLayoutRequirementSyntax },
    convenienceAsMatch: { $0.asLayoutRequirementSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MacroDeclSyntax",
    expectedMatch: { $0.is(MacroDeclSyntax.self) },
    convenienceIsMatch: { $0.isMacroDeclSyntax },
    convenienceAsMatch: { $0.asMacroDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MacroExpansionDeclSyntax",
    expectedMatch: { $0.is(MacroExpansionDeclSyntax.self) },
    convenienceIsMatch: { $0.isMacroExpansionDeclSyntax },
    convenienceAsMatch: { $0.asMacroExpansionDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MacroExpansionExprSyntax",
    expectedMatch: { $0.is(MacroExpansionExprSyntax.self) },
    convenienceIsMatch: { $0.isMacroExpansionExprSyntax },
    convenienceAsMatch: { $0.asMacroExpansionExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MatchingPatternConditionSyntax",
    expectedMatch: { $0.is(MatchingPatternConditionSyntax.self) },
    convenienceIsMatch: { $0.isMatchingPatternConditionSyntax },
    convenienceAsMatch: { $0.asMatchingPatternConditionSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MemberAccessExprSyntax",
    expectedMatch: { $0.is(MemberAccessExprSyntax.self) },
    convenienceIsMatch: { $0.isMemberAccessExprSyntax },
    convenienceAsMatch: { $0.asMemberAccessExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MemberBlockItemListSyntax",
    expectedMatch: { $0.is(MemberBlockItemListSyntax.self) },
    convenienceIsMatch: { $0.isMemberBlockItemListSyntax },
    convenienceAsMatch: { $0.asMemberBlockItemListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MemberBlockItemSyntax",
    expectedMatch: { $0.is(MemberBlockItemSyntax.self) },
    convenienceIsMatch: { $0.isMemberBlockItemSyntax },
    convenienceAsMatch: { $0.asMemberBlockItemSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MemberBlockSyntax",
    expectedMatch: { $0.is(MemberBlockSyntax.self) },
    convenienceIsMatch: { $0.isMemberBlockSyntax },
    convenienceAsMatch: { $0.asMemberBlockSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MemberTypeSyntax",
    expectedMatch: { $0.is(MemberTypeSyntax.self) },
    convenienceIsMatch: { $0.isMemberTypeSyntax },
    convenienceAsMatch: { $0.asMemberTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MetatypeTypeSyntax",
    expectedMatch: { $0.is(MetatypeTypeSyntax.self) },
    convenienceIsMatch: { $0.isMetatypeTypeSyntax },
    convenienceAsMatch: { $0.asMetatypeTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MissingDeclSyntax",
    expectedMatch: { $0.is(MissingDeclSyntax.self) },
    convenienceIsMatch: { $0.isMissingDeclSyntax },
    convenienceAsMatch: { $0.asMissingDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MissingExprSyntax",
    expectedMatch: { $0.is(MissingExprSyntax.self) },
    convenienceIsMatch: { $0.isMissingExprSyntax },
    convenienceAsMatch: { $0.asMissingExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MissingPatternSyntax",
    expectedMatch: { $0.is(MissingPatternSyntax.self) },
    convenienceIsMatch: { $0.isMissingPatternSyntax },
    convenienceAsMatch: { $0.asMissingPatternSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MissingStmtSyntax",
    expectedMatch: { $0.is(MissingStmtSyntax.self) },
    convenienceIsMatch: { $0.isMissingStmtSyntax },
    convenienceAsMatch: { $0.asMissingStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MissingSyntax",
    expectedMatch: { $0.is(MissingSyntax.self) },
    convenienceIsMatch: { $0.isMissingSyntax },
    convenienceAsMatch: { $0.asMissingSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MissingTypeSyntax",
    expectedMatch: { $0.is(MissingTypeSyntax.self) },
    convenienceIsMatch: { $0.isMissingTypeSyntax },
    convenienceAsMatch: { $0.asMissingTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MultipleTrailingClosureElementListSyntax",
    expectedMatch: { $0.is(MultipleTrailingClosureElementListSyntax.self) },
    convenienceIsMatch: { $0.isMultipleTrailingClosureElementListSyntax },
    convenienceAsMatch: { $0.asMultipleTrailingClosureElementListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "MultipleTrailingClosureElementSyntax",
    expectedMatch: { $0.is(MultipleTrailingClosureElementSyntax.self) },
    convenienceIsMatch: { $0.isMultipleTrailingClosureElementSyntax },
    convenienceAsMatch: { $0.asMultipleTrailingClosureElementSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "NamedOpaqueReturnTypeSyntax",
    expectedMatch: { $0.is(NamedOpaqueReturnTypeSyntax.self) },
    convenienceIsMatch: { $0.isNamedOpaqueReturnTypeSyntax },
    convenienceAsMatch: { $0.asNamedOpaqueReturnTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "NilLiteralExprSyntax",
    expectedMatch: { $0.is(NilLiteralExprSyntax.self) },
    convenienceIsMatch: { $0.isNilLiteralExprSyntax },
    convenienceAsMatch: { $0.asNilLiteralExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "NonisolatedSpecifierArgumentSyntax",
    expectedMatch: { $0.is(NonisolatedSpecifierArgumentSyntax.self) },
    convenienceIsMatch: { $0.isNonisolatedSpecifierArgumentSyntax },
    convenienceAsMatch: { $0.asNonisolatedSpecifierArgumentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "NonisolatedTypeSpecifierSyntax",
    expectedMatch: { $0.is(NonisolatedTypeSpecifierSyntax.self) },
    convenienceIsMatch: { $0.isNonisolatedTypeSpecifierSyntax },
    convenienceAsMatch: { $0.asNonisolatedTypeSpecifierSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ObjCSelectorPieceListSyntax",
    expectedMatch: { $0.is(ObjCSelectorPieceListSyntax.self) },
    convenienceIsMatch: { $0.isObjCSelectorPieceListSyntax },
    convenienceAsMatch: { $0.asObjCSelectorPieceListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ObjCSelectorPieceSyntax",
    expectedMatch: { $0.is(ObjCSelectorPieceSyntax.self) },
    convenienceIsMatch: { $0.isObjCSelectorPieceSyntax },
    convenienceAsMatch: { $0.asObjCSelectorPieceSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "OperatorDeclSyntax",
    expectedMatch: { $0.is(OperatorDeclSyntax.self) },
    convenienceIsMatch: { $0.isOperatorDeclSyntax },
    convenienceAsMatch: { $0.asOperatorDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "OperatorPrecedenceAndTypesSyntax",
    expectedMatch: { $0.is(OperatorPrecedenceAndTypesSyntax.self) },
    convenienceIsMatch: { $0.isOperatorPrecedenceAndTypesSyntax },
    convenienceAsMatch: { $0.asOperatorPrecedenceAndTypesSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "OptionalBindingConditionSyntax",
    expectedMatch: { $0.is(OptionalBindingConditionSyntax.self) },
    convenienceIsMatch: { $0.isOptionalBindingConditionSyntax },
    convenienceAsMatch: { $0.asOptionalBindingConditionSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "OptionalChainingExprSyntax",
    expectedMatch: { $0.is(OptionalChainingExprSyntax.self) },
    convenienceIsMatch: { $0.isOptionalChainingExprSyntax },
    convenienceAsMatch: { $0.asOptionalChainingExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "OptionalTypeSyntax",
    expectedMatch: { $0.is(OptionalTypeSyntax.self) },
    convenienceIsMatch: { $0.isOptionalTypeSyntax },
    convenienceAsMatch: { $0.asOptionalTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "OriginallyDefinedInAttributeArgumentsSyntax",
    expectedMatch: { $0.is(OriginallyDefinedInAttributeArgumentsSyntax.self) },
    convenienceIsMatch: { $0.isOriginallyDefinedInAttributeArgumentsSyntax },
    convenienceAsMatch: { $0.asOriginallyDefinedInAttributeArgumentsSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PackElementExprSyntax",
    expectedMatch: { $0.is(PackElementExprSyntax.self) },
    convenienceIsMatch: { $0.isPackElementExprSyntax },
    convenienceAsMatch: { $0.asPackElementExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PackElementTypeSyntax",
    expectedMatch: { $0.is(PackElementTypeSyntax.self) },
    convenienceIsMatch: { $0.isPackElementTypeSyntax },
    convenienceAsMatch: { $0.asPackElementTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PackExpansionExprSyntax",
    expectedMatch: { $0.is(PackExpansionExprSyntax.self) },
    convenienceIsMatch: { $0.isPackExpansionExprSyntax },
    convenienceAsMatch: { $0.asPackExpansionExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PackExpansionTypeSyntax",
    expectedMatch: { $0.is(PackExpansionTypeSyntax.self) },
    convenienceIsMatch: { $0.isPackExpansionTypeSyntax },
    convenienceAsMatch: { $0.asPackExpansionTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PatternBindingListSyntax",
    expectedMatch: { $0.is(PatternBindingListSyntax.self) },
    convenienceIsMatch: { $0.isPatternBindingListSyntax },
    convenienceAsMatch: { $0.asPatternBindingListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PatternBindingSyntax",
    expectedMatch: { $0.is(PatternBindingSyntax.self) },
    convenienceIsMatch: { $0.isPatternBindingSyntax },
    convenienceAsMatch: { $0.asPatternBindingSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PatternExprSyntax",
    expectedMatch: { $0.is(PatternExprSyntax.self) },
    convenienceIsMatch: { $0.isPatternExprSyntax },
    convenienceAsMatch: { $0.asPatternExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PatternSyntax",
    expectedMatch: { $0.is(PatternSyntax.self) },
    convenienceIsMatch: { $0.isPatternSyntax },
    convenienceAsMatch: { $0.asPatternSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PlatformVersionItemListSyntax",
    expectedMatch: { $0.is(PlatformVersionItemListSyntax.self) },
    convenienceIsMatch: { $0.isPlatformVersionItemListSyntax },
    convenienceAsMatch: { $0.asPlatformVersionItemListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PlatformVersionItemSyntax",
    expectedMatch: { $0.is(PlatformVersionItemSyntax.self) },
    convenienceIsMatch: { $0.isPlatformVersionItemSyntax },
    convenienceAsMatch: { $0.asPlatformVersionItemSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PlatformVersionSyntax",
    expectedMatch: { $0.is(PlatformVersionSyntax.self) },
    convenienceIsMatch: { $0.isPlatformVersionSyntax },
    convenienceAsMatch: { $0.asPlatformVersionSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PostfixIfConfigExprSyntax",
    expectedMatch: { $0.is(PostfixIfConfigExprSyntax.self) },
    convenienceIsMatch: { $0.isPostfixIfConfigExprSyntax },
    convenienceAsMatch: { $0.asPostfixIfConfigExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PostfixOperatorExprSyntax",
    expectedMatch: { $0.is(PostfixOperatorExprSyntax.self) },
    convenienceIsMatch: { $0.isPostfixOperatorExprSyntax },
    convenienceAsMatch: { $0.asPostfixOperatorExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PoundSourceLocationArgumentsSyntax",
    expectedMatch: { $0.is(PoundSourceLocationArgumentsSyntax.self) },
    convenienceIsMatch: { $0.isPoundSourceLocationArgumentsSyntax },
    convenienceAsMatch: { $0.asPoundSourceLocationArgumentsSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PoundSourceLocationSyntax",
    expectedMatch: { $0.is(PoundSourceLocationSyntax.self) },
    convenienceIsMatch: { $0.isPoundSourceLocationSyntax },
    convenienceAsMatch: { $0.asPoundSourceLocationSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PrecedenceGroupAssignmentSyntax",
    expectedMatch: { $0.is(PrecedenceGroupAssignmentSyntax.self) },
    convenienceIsMatch: { $0.isPrecedenceGroupAssignmentSyntax },
    convenienceAsMatch: { $0.asPrecedenceGroupAssignmentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PrecedenceGroupAssociativitySyntax",
    expectedMatch: { $0.is(PrecedenceGroupAssociativitySyntax.self) },
    convenienceIsMatch: { $0.isPrecedenceGroupAssociativitySyntax },
    convenienceAsMatch: { $0.asPrecedenceGroupAssociativitySyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PrecedenceGroupAttributeListSyntax",
    expectedMatch: { $0.is(PrecedenceGroupAttributeListSyntax.self) },
    convenienceIsMatch: { $0.isPrecedenceGroupAttributeListSyntax },
    convenienceAsMatch: { $0.asPrecedenceGroupAttributeListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PrecedenceGroupDeclSyntax",
    expectedMatch: { $0.is(PrecedenceGroupDeclSyntax.self) },
    convenienceIsMatch: { $0.isPrecedenceGroupDeclSyntax },
    convenienceAsMatch: { $0.asPrecedenceGroupDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PrecedenceGroupNameListSyntax",
    expectedMatch: { $0.is(PrecedenceGroupNameListSyntax.self) },
    convenienceIsMatch: { $0.isPrecedenceGroupNameListSyntax },
    convenienceAsMatch: { $0.asPrecedenceGroupNameListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PrecedenceGroupNameSyntax",
    expectedMatch: { $0.is(PrecedenceGroupNameSyntax.self) },
    convenienceIsMatch: { $0.isPrecedenceGroupNameSyntax },
    convenienceAsMatch: { $0.asPrecedenceGroupNameSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PrecedenceGroupRelationSyntax",
    expectedMatch: { $0.is(PrecedenceGroupRelationSyntax.self) },
    convenienceIsMatch: { $0.isPrecedenceGroupRelationSyntax },
    convenienceAsMatch: { $0.asPrecedenceGroupRelationSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PrefixOperatorExprSyntax",
    expectedMatch: { $0.is(PrefixOperatorExprSyntax.self) },
    convenienceIsMatch: { $0.isPrefixOperatorExprSyntax },
    convenienceAsMatch: { $0.asPrefixOperatorExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PrimaryAssociatedTypeClauseSyntax",
    expectedMatch: { $0.is(PrimaryAssociatedTypeClauseSyntax.self) },
    convenienceIsMatch: { $0.isPrimaryAssociatedTypeClauseSyntax },
    convenienceAsMatch: { $0.asPrimaryAssociatedTypeClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PrimaryAssociatedTypeListSyntax",
    expectedMatch: { $0.is(PrimaryAssociatedTypeListSyntax.self) },
    convenienceIsMatch: { $0.isPrimaryAssociatedTypeListSyntax },
    convenienceAsMatch: { $0.asPrimaryAssociatedTypeListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "PrimaryAssociatedTypeSyntax",
    expectedMatch: { $0.is(PrimaryAssociatedTypeSyntax.self) },
    convenienceIsMatch: { $0.isPrimaryAssociatedTypeSyntax },
    convenienceAsMatch: { $0.asPrimaryAssociatedTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ProtocolDeclSyntax",
    expectedMatch: { $0.is(ProtocolDeclSyntax.self) },
    convenienceIsMatch: { $0.isProtocolDeclSyntax },
    convenienceAsMatch: { $0.asProtocolDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "RegexLiteralExprSyntax",
    expectedMatch: { $0.is(RegexLiteralExprSyntax.self) },
    convenienceIsMatch: { $0.isRegexLiteralExprSyntax },
    convenienceAsMatch: { $0.asRegexLiteralExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "RepeatStmtSyntax",
    expectedMatch: { $0.is(RepeatStmtSyntax.self) },
    convenienceIsMatch: { $0.isRepeatStmtSyntax },
    convenienceAsMatch: { $0.asRepeatStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ReturnClauseSyntax",
    expectedMatch: { $0.is(ReturnClauseSyntax.self) },
    convenienceIsMatch: { $0.isReturnClauseSyntax },
    convenienceAsMatch: { $0.asReturnClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ReturnStmtSyntax",
    expectedMatch: { $0.is(ReturnStmtSyntax.self) },
    convenienceIsMatch: { $0.isReturnStmtSyntax },
    convenienceAsMatch: { $0.asReturnStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SameTypeRequirementSyntax",
    expectedMatch: { $0.is(SameTypeRequirementSyntax.self) },
    convenienceIsMatch: { $0.isSameTypeRequirementSyntax },
    convenienceAsMatch: { $0.asSameTypeRequirementSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SequenceExprSyntax",
    expectedMatch: { $0.is(SequenceExprSyntax.self) },
    convenienceIsMatch: { $0.isSequenceExprSyntax },
    convenienceAsMatch: { $0.asSequenceExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SimpleStringLiteralExprSyntax",
    expectedMatch: { $0.is(SimpleStringLiteralExprSyntax.self) },
    convenienceIsMatch: { $0.isSimpleStringLiteralExprSyntax },
    convenienceAsMatch: { $0.asSimpleStringLiteralExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SimpleStringLiteralSegmentListSyntax",
    expectedMatch: { $0.is(SimpleStringLiteralSegmentListSyntax.self) },
    convenienceIsMatch: { $0.isSimpleStringLiteralSegmentListSyntax },
    convenienceAsMatch: { $0.asSimpleStringLiteralSegmentListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SimpleTypeSpecifierSyntax",
    expectedMatch: { $0.is(SimpleTypeSpecifierSyntax.self) },
    convenienceIsMatch: { $0.isSimpleTypeSpecifierSyntax },
    convenienceAsMatch: { $0.asSimpleTypeSpecifierSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SomeOrAnyTypeSyntax",
    expectedMatch: { $0.is(SomeOrAnyTypeSyntax.self) },
    convenienceIsMatch: { $0.isSomeOrAnyTypeSyntax },
    convenienceAsMatch: { $0.asSomeOrAnyTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SourceFileSyntax",
    expectedMatch: { $0.is(SourceFileSyntax.self) },
    convenienceIsMatch: { $0.isSourceFileSyntax },
    convenienceAsMatch: { $0.asSourceFileSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SpecializeAttributeArgumentListSyntax",
    expectedMatch: { $0.is(SpecializeAttributeArgumentListSyntax.self) },
    convenienceIsMatch: { $0.isSpecializeAttributeArgumentListSyntax },
    convenienceAsMatch: { $0.asSpecializeAttributeArgumentListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SpecializeAvailabilityArgumentSyntax",
    expectedMatch: { $0.is(SpecializeAvailabilityArgumentSyntax.self) },
    convenienceIsMatch: { $0.isSpecializeAvailabilityArgumentSyntax },
    convenienceAsMatch: { $0.asSpecializeAvailabilityArgumentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SpecializeTargetFunctionArgumentSyntax",
    expectedMatch: { $0.is(SpecializeTargetFunctionArgumentSyntax.self) },
    convenienceIsMatch: { $0.isSpecializeTargetFunctionArgumentSyntax },
    convenienceAsMatch: { $0.asSpecializeTargetFunctionArgumentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "StmtSyntax",
    expectedMatch: { $0.is(StmtSyntax.self) },
    convenienceIsMatch: { $0.isStmtSyntax },
    convenienceAsMatch: { $0.asStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "StringLiteralExprSyntax",
    expectedMatch: { $0.is(StringLiteralExprSyntax.self) },
    convenienceIsMatch: { $0.isStringLiteralExprSyntax },
    convenienceAsMatch: { $0.asStringLiteralExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "StringLiteralSegmentListSyntax",
    expectedMatch: { $0.is(StringLiteralSegmentListSyntax.self) },
    convenienceIsMatch: { $0.isStringLiteralSegmentListSyntax },
    convenienceAsMatch: { $0.asStringLiteralSegmentListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "StringSegmentSyntax",
    expectedMatch: { $0.is(StringSegmentSyntax.self) },
    convenienceIsMatch: { $0.isStringSegmentSyntax },
    convenienceAsMatch: { $0.asStringSegmentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "StructDeclSyntax",
    expectedMatch: { $0.is(StructDeclSyntax.self) },
    convenienceIsMatch: { $0.isStructDeclSyntax },
    convenienceAsMatch: { $0.asStructDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SubscriptCallExprSyntax",
    expectedMatch: { $0.is(SubscriptCallExprSyntax.self) },
    convenienceIsMatch: { $0.isSubscriptCallExprSyntax },
    convenienceAsMatch: { $0.asSubscriptCallExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SubscriptDeclSyntax",
    expectedMatch: { $0.is(SubscriptDeclSyntax.self) },
    convenienceIsMatch: { $0.isSubscriptDeclSyntax },
    convenienceAsMatch: { $0.asSubscriptDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SuperExprSyntax",
    expectedMatch: { $0.is(SuperExprSyntax.self) },
    convenienceIsMatch: { $0.isSuperExprSyntax },
    convenienceAsMatch: { $0.asSuperExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SuppressedTypeSyntax",
    expectedMatch: { $0.is(SuppressedTypeSyntax.self) },
    convenienceIsMatch: { $0.isSuppressedTypeSyntax },
    convenienceAsMatch: { $0.asSuppressedTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SwitchCaseItemListSyntax",
    expectedMatch: { $0.is(SwitchCaseItemListSyntax.self) },
    convenienceIsMatch: { $0.isSwitchCaseItemListSyntax },
    convenienceAsMatch: { $0.asSwitchCaseItemListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SwitchCaseItemSyntax",
    expectedMatch: { $0.is(SwitchCaseItemSyntax.self) },
    convenienceIsMatch: { $0.isSwitchCaseItemSyntax },
    convenienceAsMatch: { $0.asSwitchCaseItemSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SwitchCaseLabelSyntax",
    expectedMatch: { $0.is(SwitchCaseLabelSyntax.self) },
    convenienceIsMatch: { $0.isSwitchCaseLabelSyntax },
    convenienceAsMatch: { $0.asSwitchCaseLabelSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SwitchCaseListSyntax",
    expectedMatch: { $0.is(SwitchCaseListSyntax.self) },
    convenienceIsMatch: { $0.isSwitchCaseListSyntax },
    convenienceAsMatch: { $0.asSwitchCaseListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SwitchCaseSyntax",
    expectedMatch: { $0.is(SwitchCaseSyntax.self) },
    convenienceIsMatch: { $0.isSwitchCaseSyntax },
    convenienceAsMatch: { $0.asSwitchCaseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SwitchDefaultLabelSyntax",
    expectedMatch: { $0.is(SwitchDefaultLabelSyntax.self) },
    convenienceIsMatch: { $0.isSwitchDefaultLabelSyntax },
    convenienceAsMatch: { $0.asSwitchDefaultLabelSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "SwitchExprSyntax",
    expectedMatch: { $0.is(SwitchExprSyntax.self) },
    convenienceIsMatch: { $0.isSwitchExprSyntax },
    convenienceAsMatch: { $0.asSwitchExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TernaryExprSyntax",
    expectedMatch: { $0.is(TernaryExprSyntax.self) },
    convenienceIsMatch: { $0.isTernaryExprSyntax },
    convenienceAsMatch: { $0.asTernaryExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ThrowStmtSyntax",
    expectedMatch: { $0.is(ThrowStmtSyntax.self) },
    convenienceIsMatch: { $0.isThrowStmtSyntax },
    convenienceAsMatch: { $0.asThrowStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ThrowsClauseSyntax",
    expectedMatch: { $0.is(ThrowsClauseSyntax.self) },
    convenienceIsMatch: { $0.isThrowsClauseSyntax },
    convenienceAsMatch: { $0.asThrowsClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TokenSyntax",
    expectedMatch: { $0.is(TokenSyntax.self) },
    convenienceIsMatch: { $0.isTokenSyntax },
    convenienceAsMatch: { $0.asTokenSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TryExprSyntax",
    expectedMatch: { $0.is(TryExprSyntax.self) },
    convenienceIsMatch: { $0.isTryExprSyntax },
    convenienceAsMatch: { $0.asTryExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TupleExprSyntax",
    expectedMatch: { $0.is(TupleExprSyntax.self) },
    convenienceIsMatch: { $0.isTupleExprSyntax },
    convenienceAsMatch: { $0.asTupleExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TuplePatternElementListSyntax",
    expectedMatch: { $0.is(TuplePatternElementListSyntax.self) },
    convenienceIsMatch: { $0.isTuplePatternElementListSyntax },
    convenienceAsMatch: { $0.asTuplePatternElementListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TuplePatternElementSyntax",
    expectedMatch: { $0.is(TuplePatternElementSyntax.self) },
    convenienceIsMatch: { $0.isTuplePatternElementSyntax },
    convenienceAsMatch: { $0.asTuplePatternElementSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TuplePatternSyntax",
    expectedMatch: { $0.is(TuplePatternSyntax.self) },
    convenienceIsMatch: { $0.isTuplePatternSyntax },
    convenienceAsMatch: { $0.asTuplePatternSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TupleTypeElementListSyntax",
    expectedMatch: { $0.is(TupleTypeElementListSyntax.self) },
    convenienceIsMatch: { $0.isTupleTypeElementListSyntax },
    convenienceAsMatch: { $0.asTupleTypeElementListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TupleTypeElementSyntax",
    expectedMatch: { $0.is(TupleTypeElementSyntax.self) },
    convenienceIsMatch: { $0.isTupleTypeElementSyntax },
    convenienceAsMatch: { $0.asTupleTypeElementSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TupleTypeSyntax",
    expectedMatch: { $0.is(TupleTypeSyntax.self) },
    convenienceIsMatch: { $0.isTupleTypeSyntax },
    convenienceAsMatch: { $0.asTupleTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TypeAliasDeclSyntax",
    expectedMatch: { $0.is(TypeAliasDeclSyntax.self) },
    convenienceIsMatch: { $0.isTypeAliasDeclSyntax },
    convenienceAsMatch: { $0.asTypeAliasDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TypeAnnotationSyntax",
    expectedMatch: { $0.is(TypeAnnotationSyntax.self) },
    convenienceIsMatch: { $0.isTypeAnnotationSyntax },
    convenienceAsMatch: { $0.asTypeAnnotationSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TypeEffectSpecifiersSyntax",
    expectedMatch: { $0.is(TypeEffectSpecifiersSyntax.self) },
    convenienceIsMatch: { $0.isTypeEffectSpecifiersSyntax },
    convenienceAsMatch: { $0.asTypeEffectSpecifiersSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TypeExprSyntax",
    expectedMatch: { $0.is(TypeExprSyntax.self) },
    convenienceIsMatch: { $0.isTypeExprSyntax },
    convenienceAsMatch: { $0.asTypeExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TypeInitializerClauseSyntax",
    expectedMatch: { $0.is(TypeInitializerClauseSyntax.self) },
    convenienceIsMatch: { $0.isTypeInitializerClauseSyntax },
    convenienceAsMatch: { $0.asTypeInitializerClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TypeSpecifierListSyntax",
    expectedMatch: { $0.is(TypeSpecifierListSyntax.self) },
    convenienceIsMatch: { $0.isTypeSpecifierListSyntax },
    convenienceAsMatch: { $0.asTypeSpecifierListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "TypeSyntax",
    expectedMatch: { $0.is(TypeSyntax.self) },
    convenienceIsMatch: { $0.isTypeSyntax },
    convenienceAsMatch: { $0.asTypeSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "UnexpectedNodesSyntax",
    expectedMatch: { $0.is(UnexpectedNodesSyntax.self) },
    convenienceIsMatch: { $0.isUnexpectedNodesSyntax },
    convenienceAsMatch: { $0.asUnexpectedNodesSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "UnresolvedAsExprSyntax",
    expectedMatch: { $0.is(UnresolvedAsExprSyntax.self) },
    convenienceIsMatch: { $0.isUnresolvedAsExprSyntax },
    convenienceAsMatch: { $0.asUnresolvedAsExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "UnresolvedIsExprSyntax",
    expectedMatch: { $0.is(UnresolvedIsExprSyntax.self) },
    convenienceIsMatch: { $0.isUnresolvedIsExprSyntax },
    convenienceAsMatch: { $0.asUnresolvedIsExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "UnresolvedTernaryExprSyntax",
    expectedMatch: { $0.is(UnresolvedTernaryExprSyntax.self) },
    convenienceIsMatch: { $0.isUnresolvedTernaryExprSyntax },
    convenienceAsMatch: { $0.asUnresolvedTernaryExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "UnsafeExprSyntax",
    expectedMatch: { $0.is(UnsafeExprSyntax.self) },
    convenienceIsMatch: { $0.isUnsafeExprSyntax },
    convenienceAsMatch: { $0.asUnsafeExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "ValueBindingPatternSyntax",
    expectedMatch: { $0.is(ValueBindingPatternSyntax.self) },
    convenienceIsMatch: { $0.isValueBindingPatternSyntax },
    convenienceAsMatch: { $0.asValueBindingPatternSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "VariableDeclSyntax",
    expectedMatch: { $0.is(VariableDeclSyntax.self) },
    convenienceIsMatch: { $0.isVariableDeclSyntax },
    convenienceAsMatch: { $0.asVariableDeclSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "VersionComponentListSyntax",
    expectedMatch: { $0.is(VersionComponentListSyntax.self) },
    convenienceIsMatch: { $0.isVersionComponentListSyntax },
    convenienceAsMatch: { $0.asVersionComponentListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "VersionComponentSyntax",
    expectedMatch: { $0.is(VersionComponentSyntax.self) },
    convenienceIsMatch: { $0.isVersionComponentSyntax },
    convenienceAsMatch: { $0.asVersionComponentSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "VersionTupleSyntax",
    expectedMatch: { $0.is(VersionTupleSyntax.self) },
    convenienceIsMatch: { $0.isVersionTupleSyntax },
    convenienceAsMatch: { $0.asVersionTupleSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "WhereClauseSyntax",
    expectedMatch: { $0.is(WhereClauseSyntax.self) },
    convenienceIsMatch: { $0.isWhereClauseSyntax },
    convenienceAsMatch: { $0.asWhereClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "WhileStmtSyntax",
    expectedMatch: { $0.is(WhileStmtSyntax.self) },
    convenienceIsMatch: { $0.isWhileStmtSyntax },
    convenienceAsMatch: { $0.asWhileStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "WildcardPatternSyntax",
    expectedMatch: { $0.is(WildcardPatternSyntax.self) },
    convenienceIsMatch: { $0.isWildcardPatternSyntax },
    convenienceAsMatch: { $0.asWildcardPatternSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "YieldStmtSyntax",
    expectedMatch: { $0.is(YieldStmtSyntax.self) },
    convenienceIsMatch: { $0.isYieldStmtSyntax },
    convenienceAsMatch: { $0.asYieldStmtSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "YieldedExpressionListSyntax",
    expectedMatch: { $0.is(YieldedExpressionListSyntax.self) },
    convenienceIsMatch: { $0.isYieldedExpressionListSyntax },
    convenienceAsMatch: { $0.asYieldedExpressionListSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "YieldedExpressionSyntax",
    expectedMatch: { $0.is(YieldedExpressionSyntax.self) },
    convenienceIsMatch: { $0.isYieldedExpressionSyntax },
    convenienceAsMatch: { $0.asYieldedExpressionSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "YieldedExpressionsClauseSyntax",
    expectedMatch: { $0.is(YieldedExpressionsClauseSyntax.self) },
    convenienceIsMatch: { $0.isYieldedExpressionsClauseSyntax },
    convenienceAsMatch: { $0.asYieldedExpressionsClauseSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "_CanImportExprSyntax",
    expectedMatch: { $0.is(_CanImportExprSyntax.self) },
    convenienceIsMatch: { $0.isCanImportExprSyntax },
    convenienceAsMatch: { $0.asCanImportExprSyntax != nil }
  ),
  SyntaxCastConvenienceProbe(
    name: "_CanImportVersionInfoSyntax",
    expectedMatch: { $0.is(_CanImportVersionInfoSyntax.self) },
    convenienceIsMatch: { $0.isCanImportVersionInfoSyntax },
    convenienceAsMatch: { $0.asCanImportVersionInfoSyntax != nil }
  ),
]

@Test("Generated syntax-element cast conveniences agree with SwiftSyntax casting")
func testGeneratedSyntaxElementCastConveniencesAgreeWithSwiftSyntaxCasting() throws {
  // This property-style test mechanically covers every generated `as*` and `is*`
  // convenience. The property is that each wrapper must agree with SwiftSyntax's
  // generic casting API for several representative syntax trees, which is broader
  // than the hand-written representative example in `SyntaxProtocolConvenience+Tests`.
  for sample in try syntaxCastSamples() {
    for probe in syntaxCastConvenienceProbes {
      let expected = probe.expectedMatch(sample.syntax)

      #expect(probe.convenienceIsMatch(sample.syntax) == expected)
      #expect(probe.convenienceAsMatch(sample.syntax) == expected)
    }
  }
}

private func syntaxCastSamples() throws -> [SyntaxCastSample] {
  let source = """
  @available(macOS 14.0, *)
  public struct Widget<T>: Sendable where T: Sequence {
    public var count: Int = 0

    public func value(_ input: T) async throws -> Int {
      guard true else { return 0 }
      return count
    }
  }

  enum Choice {
    case one(Int)
    case two
  }

  let tuple: (Int, String) = (1, "value")
  _ = tuple.0
  """

  let sourceFile = try SourceFileSyntax.onlyParsed(from: source)

  return [
    SyntaxCastSample(name: "source file", syntax: Syntax(sourceFile)),
    SyntaxCastSample(name: "struct declaration", syntax: Syntax(try StructDeclSyntax.firstParsed(from: source))),
    SyntaxCastSample(name: "enum declaration", syntax: Syntax(try EnumDeclSyntax.firstParsed(from: source))),
    SyntaxCastSample(name: "function declaration", syntax: Syntax(try FunctionDeclSyntax.firstParsed(from: source))),
    SyntaxCastSample(name: "stored property", syntax: Syntax(try VariableDeclSyntax.firstParsed(from: source))),
    SyntaxCastSample(name: "identifier type", syntax: Syntax(try IdentifierTypeSyntax.firstParsed(from: source))),
    SyntaxCastSample(name: "boolean literal", syntax: Syntax(try BooleanLiteralExprSyntax.firstParsed(from: source))),
    SyntaxCastSample(name: "return statement", syntax: Syntax(try ReturnStmtSyntax.firstParsed(from: source))),
    SyntaxCastSample(name: "tuple expression", syntax: Syntax(try TupleExprSyntax.firstParsed(from: source))),
    SyntaxCastSample(name: "member access", syntax: Syntax(try MemberAccessExprSyntax.firstParsed(from: source))),
    SyntaxCastSample(name: "token", syntax: Syntax(TokenSyntax.identifier("Widget"))),
  ]
}
