import SwiftSyntax

extension SyntaxProtocol {

  /// Returns `self` as `type`, when possible.
  @inlinable
  public func asSyntaxElement<T>(
    _ type: T.Type = T.self
  ) -> T? where T: SyntaxProtocol {
    self.as(type)
  }

  /// `true` iff `self` can be viewed as `type`.
  @inlinable
  public func isSyntaxElement<T>(
    _ type: T.Type = T.self
  ) -> Bool where T: SyntaxProtocol {
    self.is(type)
  }

  /// Returns `self` as `ABIAttributeArgumentsSyntax`, when possible.
  @inlinable
  public var asABIAttributeArgumentsSyntax: ABIAttributeArgumentsSyntax? {
    self.as(ABIAttributeArgumentsSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ABIAttributeArgumentsSyntax`.
  @inlinable
  public var isABIAttributeArgumentsSyntax: Bool {
    self.is(ABIAttributeArgumentsSyntax.self)
  }

  /// Returns `self` as `AccessorBlockSyntax`, when possible.
  @inlinable
  public var asAccessorBlockSyntax: AccessorBlockSyntax? {
    self.as(AccessorBlockSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AccessorBlockSyntax`.
  @inlinable
  public var isAccessorBlockSyntax: Bool {
    self.is(AccessorBlockSyntax.self)
  }

  /// Returns `self` as `AccessorDeclListSyntax`, when possible.
  @inlinable
  public var asAccessorDeclListSyntax: AccessorDeclListSyntax? {
    self.as(AccessorDeclListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AccessorDeclListSyntax`.
  @inlinable
  public var isAccessorDeclListSyntax: Bool {
    self.is(AccessorDeclListSyntax.self)
  }

  /// Returns `self` as `AccessorDeclSyntax`, when possible.
  @inlinable
  public var asAccessorDeclSyntax: AccessorDeclSyntax? {
    self.as(AccessorDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AccessorDeclSyntax`.
  @inlinable
  public var isAccessorDeclSyntax: Bool {
    self.is(AccessorDeclSyntax.self)
  }

  /// Returns `self` as `AccessorEffectSpecifiersSyntax`, when possible.
  @inlinable
  public var asAccessorEffectSpecifiersSyntax: AccessorEffectSpecifiersSyntax? {
    self.as(AccessorEffectSpecifiersSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AccessorEffectSpecifiersSyntax`.
  @inlinable
  public var isAccessorEffectSpecifiersSyntax: Bool {
    self.is(AccessorEffectSpecifiersSyntax.self)
  }

  /// Returns `self` as `AccessorParametersSyntax`, when possible.
  @inlinable
  public var asAccessorParametersSyntax: AccessorParametersSyntax? {
    self.as(AccessorParametersSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AccessorParametersSyntax`.
  @inlinable
  public var isAccessorParametersSyntax: Bool {
    self.is(AccessorParametersSyntax.self)
  }

  /// Returns `self` as `ActorDeclSyntax`, when possible.
  @inlinable
  public var asActorDeclSyntax: ActorDeclSyntax? {
    self.as(ActorDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ActorDeclSyntax`.
  @inlinable
  public var isActorDeclSyntax: Bool {
    self.is(ActorDeclSyntax.self)
  }

  /// Returns `self` as `ArrayElementListSyntax`, when possible.
  @inlinable
  public var asArrayElementListSyntax: ArrayElementListSyntax? {
    self.as(ArrayElementListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ArrayElementListSyntax`.
  @inlinable
  public var isArrayElementListSyntax: Bool {
    self.is(ArrayElementListSyntax.self)
  }

  /// Returns `self` as `ArrayElementSyntax`, when possible.
  @inlinable
  public var asArrayElementSyntax: ArrayElementSyntax? {
    self.as(ArrayElementSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ArrayElementSyntax`.
  @inlinable
  public var isArrayElementSyntax: Bool {
    self.is(ArrayElementSyntax.self)
  }

  /// Returns `self` as `ArrayExprSyntax`, when possible.
  @inlinable
  public var asArrayExprSyntax: ArrayExprSyntax? {
    self.as(ArrayExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ArrayExprSyntax`.
  @inlinable
  public var isArrayExprSyntax: Bool {
    self.is(ArrayExprSyntax.self)
  }

  /// Returns `self` as `ArrayTypeSyntax`, when possible.
  @inlinable
  public var asArrayTypeSyntax: ArrayTypeSyntax? {
    self.as(ArrayTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ArrayTypeSyntax`.
  @inlinable
  public var isArrayTypeSyntax: Bool {
    self.is(ArrayTypeSyntax.self)
  }

  /// Returns `self` as `ArrowExprSyntax`, when possible.
  @inlinable
  public var asArrowExprSyntax: ArrowExprSyntax? {
    self.as(ArrowExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ArrowExprSyntax`.
  @inlinable
  public var isArrowExprSyntax: Bool {
    self.is(ArrowExprSyntax.self)
  }

  /// Returns `self` as `AsExprSyntax`, when possible.
  @inlinable
  public var asAsExprSyntax: AsExprSyntax? {
    self.as(AsExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AsExprSyntax`.
  @inlinable
  public var isAsExprSyntax: Bool {
    self.is(AsExprSyntax.self)
  }

  /// Returns `self` as `AssignmentExprSyntax`, when possible.
  @inlinable
  public var asAssignmentExprSyntax: AssignmentExprSyntax? {
    self.as(AssignmentExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AssignmentExprSyntax`.
  @inlinable
  public var isAssignmentExprSyntax: Bool {
    self.is(AssignmentExprSyntax.self)
  }

  /// Returns `self` as `AssociatedTypeDeclSyntax`, when possible.
  @inlinable
  public var asAssociatedTypeDeclSyntax: AssociatedTypeDeclSyntax? {
    self.as(AssociatedTypeDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AssociatedTypeDeclSyntax`.
  @inlinable
  public var isAssociatedTypeDeclSyntax: Bool {
    self.is(AssociatedTypeDeclSyntax.self)
  }

  /// Returns `self` as `AttributeListSyntax`, when possible.
  @inlinable
  public var asAttributeListSyntax: AttributeListSyntax? {
    self.as(AttributeListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AttributeListSyntax`.
  @inlinable
  public var isAttributeListSyntax: Bool {
    self.is(AttributeListSyntax.self)
  }

  /// Returns `self` as `AttributeSyntax`, when possible.
  @inlinable
  public var asAttributeSyntax: AttributeSyntax? {
    self.as(AttributeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AttributeSyntax`.
  @inlinable
  public var isAttributeSyntax: Bool {
    self.is(AttributeSyntax.self)
  }

  /// Returns `self` as `AttributedTypeSyntax`, when possible.
  @inlinable
  public var asAttributedTypeSyntax: AttributedTypeSyntax? {
    self.as(AttributedTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AttributedTypeSyntax`.
  @inlinable
  public var isAttributedTypeSyntax: Bool {
    self.is(AttributedTypeSyntax.self)
  }

  /// Returns `self` as `AvailabilityArgumentListSyntax`, when possible.
  @inlinable
  public var asAvailabilityArgumentListSyntax: AvailabilityArgumentListSyntax? {
    self.as(AvailabilityArgumentListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AvailabilityArgumentListSyntax`.
  @inlinable
  public var isAvailabilityArgumentListSyntax: Bool {
    self.is(AvailabilityArgumentListSyntax.self)
  }

  /// Returns `self` as `AvailabilityArgumentSyntax`, when possible.
  @inlinable
  public var asAvailabilityArgumentSyntax: AvailabilityArgumentSyntax? {
    self.as(AvailabilityArgumentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AvailabilityArgumentSyntax`.
  @inlinable
  public var isAvailabilityArgumentSyntax: Bool {
    self.is(AvailabilityArgumentSyntax.self)
  }

  /// Returns `self` as `AvailabilityConditionSyntax`, when possible.
  @inlinable
  public var asAvailabilityConditionSyntax: AvailabilityConditionSyntax? {
    self.as(AvailabilityConditionSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AvailabilityConditionSyntax`.
  @inlinable
  public var isAvailabilityConditionSyntax: Bool {
    self.is(AvailabilityConditionSyntax.self)
  }

  /// Returns `self` as `AvailabilityLabeledArgumentSyntax`, when possible.
  @inlinable
  public var asAvailabilityLabeledArgumentSyntax: AvailabilityLabeledArgumentSyntax? {
    self.as(AvailabilityLabeledArgumentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AvailabilityLabeledArgumentSyntax`.
  @inlinable
  public var isAvailabilityLabeledArgumentSyntax: Bool {
    self.is(AvailabilityLabeledArgumentSyntax.self)
  }

  /// Returns `self` as `AwaitExprSyntax`, when possible.
  @inlinable
  public var asAwaitExprSyntax: AwaitExprSyntax? {
    self.as(AwaitExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `AwaitExprSyntax`.
  @inlinable
  public var isAwaitExprSyntax: Bool {
    self.is(AwaitExprSyntax.self)
  }

  /// Returns `self` as `BackDeployedAttributeArgumentsSyntax`, when possible.
  @inlinable
  public var asBackDeployedAttributeArgumentsSyntax: BackDeployedAttributeArgumentsSyntax? {
    self.as(BackDeployedAttributeArgumentsSyntax.self)
  }

  /// `true` iff `self` can be viewed as `BackDeployedAttributeArgumentsSyntax`.
  @inlinable
  public var isBackDeployedAttributeArgumentsSyntax: Bool {
    self.is(BackDeployedAttributeArgumentsSyntax.self)
  }

  /// Returns `self` as `BinaryOperatorExprSyntax`, when possible.
  @inlinable
  public var asBinaryOperatorExprSyntax: BinaryOperatorExprSyntax? {
    self.as(BinaryOperatorExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `BinaryOperatorExprSyntax`.
  @inlinable
  public var isBinaryOperatorExprSyntax: Bool {
    self.is(BinaryOperatorExprSyntax.self)
  }

  /// Returns `self` as `BooleanLiteralExprSyntax`, when possible.
  @inlinable
  public var asBooleanLiteralExprSyntax: BooleanLiteralExprSyntax? {
    self.as(BooleanLiteralExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `BooleanLiteralExprSyntax`.
  @inlinable
  public var isBooleanLiteralExprSyntax: Bool {
    self.is(BooleanLiteralExprSyntax.self)
  }

  /// Returns `self` as `BorrowExprSyntax`, when possible.
  @inlinable
  public var asBorrowExprSyntax: BorrowExprSyntax? {
    self.as(BorrowExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `BorrowExprSyntax`.
  @inlinable
  public var isBorrowExprSyntax: Bool {
    self.is(BorrowExprSyntax.self)
  }

  /// Returns `self` as `BreakStmtSyntax`, when possible.
  @inlinable
  public var asBreakStmtSyntax: BreakStmtSyntax? {
    self.as(BreakStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `BreakStmtSyntax`.
  @inlinable
  public var isBreakStmtSyntax: Bool {
    self.is(BreakStmtSyntax.self)
  }

  /// Returns `self` as `CatchClauseListSyntax`, when possible.
  @inlinable
  public var asCatchClauseListSyntax: CatchClauseListSyntax? {
    self.as(CatchClauseListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `CatchClauseListSyntax`.
  @inlinable
  public var isCatchClauseListSyntax: Bool {
    self.is(CatchClauseListSyntax.self)
  }

  /// Returns `self` as `CatchClauseSyntax`, when possible.
  @inlinable
  public var asCatchClauseSyntax: CatchClauseSyntax? {
    self.as(CatchClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `CatchClauseSyntax`.
  @inlinable
  public var isCatchClauseSyntax: Bool {
    self.is(CatchClauseSyntax.self)
  }

  /// Returns `self` as `CatchItemListSyntax`, when possible.
  @inlinable
  public var asCatchItemListSyntax: CatchItemListSyntax? {
    self.as(CatchItemListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `CatchItemListSyntax`.
  @inlinable
  public var isCatchItemListSyntax: Bool {
    self.is(CatchItemListSyntax.self)
  }

  /// Returns `self` as `CatchItemSyntax`, when possible.
  @inlinable
  public var asCatchItemSyntax: CatchItemSyntax? {
    self.as(CatchItemSyntax.self)
  }

  /// `true` iff `self` can be viewed as `CatchItemSyntax`.
  @inlinable
  public var isCatchItemSyntax: Bool {
    self.is(CatchItemSyntax.self)
  }

  /// Returns `self` as `ClassDeclSyntax`, when possible.
  @inlinable
  public var asClassDeclSyntax: ClassDeclSyntax? {
    self.as(ClassDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ClassDeclSyntax`.
  @inlinable
  public var isClassDeclSyntax: Bool {
    self.is(ClassDeclSyntax.self)
  }

  /// Returns `self` as `ClassRestrictionTypeSyntax`, when possible.
  @inlinable
  public var asClassRestrictionTypeSyntax: ClassRestrictionTypeSyntax? {
    self.as(ClassRestrictionTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ClassRestrictionTypeSyntax`.
  @inlinable
  public var isClassRestrictionTypeSyntax: Bool {
    self.is(ClassRestrictionTypeSyntax.self)
  }

  /// Returns `self` as `ClosureCaptureClauseSyntax`, when possible.
  @inlinable
  public var asClosureCaptureClauseSyntax: ClosureCaptureClauseSyntax? {
    self.as(ClosureCaptureClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ClosureCaptureClauseSyntax`.
  @inlinable
  public var isClosureCaptureClauseSyntax: Bool {
    self.is(ClosureCaptureClauseSyntax.self)
  }

  /// Returns `self` as `ClosureCaptureListSyntax`, when possible.
  @inlinable
  public var asClosureCaptureListSyntax: ClosureCaptureListSyntax? {
    self.as(ClosureCaptureListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ClosureCaptureListSyntax`.
  @inlinable
  public var isClosureCaptureListSyntax: Bool {
    self.is(ClosureCaptureListSyntax.self)
  }

  /// Returns `self` as `ClosureCaptureSpecifierSyntax`, when possible.
  @inlinable
  public var asClosureCaptureSpecifierSyntax: ClosureCaptureSpecifierSyntax? {
    self.as(ClosureCaptureSpecifierSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ClosureCaptureSpecifierSyntax`.
  @inlinable
  public var isClosureCaptureSpecifierSyntax: Bool {
    self.is(ClosureCaptureSpecifierSyntax.self)
  }

  /// Returns `self` as `ClosureCaptureSyntax`, when possible.
  @inlinable
  public var asClosureCaptureSyntax: ClosureCaptureSyntax? {
    self.as(ClosureCaptureSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ClosureCaptureSyntax`.
  @inlinable
  public var isClosureCaptureSyntax: Bool {
    self.is(ClosureCaptureSyntax.self)
  }

  /// Returns `self` as `ClosureExprSyntax`, when possible.
  @inlinable
  public var asClosureExprSyntax: ClosureExprSyntax? {
    self.as(ClosureExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ClosureExprSyntax`.
  @inlinable
  public var isClosureExprSyntax: Bool {
    self.is(ClosureExprSyntax.self)
  }

  /// Returns `self` as `ClosureParameterClauseSyntax`, when possible.
  @inlinable
  public var asClosureParameterClauseSyntax: ClosureParameterClauseSyntax? {
    self.as(ClosureParameterClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ClosureParameterClauseSyntax`.
  @inlinable
  public var isClosureParameterClauseSyntax: Bool {
    self.is(ClosureParameterClauseSyntax.self)
  }

  /// Returns `self` as `ClosureParameterListSyntax`, when possible.
  @inlinable
  public var asClosureParameterListSyntax: ClosureParameterListSyntax? {
    self.as(ClosureParameterListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ClosureParameterListSyntax`.
  @inlinable
  public var isClosureParameterListSyntax: Bool {
    self.is(ClosureParameterListSyntax.self)
  }

  /// Returns `self` as `ClosureParameterSyntax`, when possible.
  @inlinable
  public var asClosureParameterSyntax: ClosureParameterSyntax? {
    self.as(ClosureParameterSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ClosureParameterSyntax`.
  @inlinable
  public var isClosureParameterSyntax: Bool {
    self.is(ClosureParameterSyntax.self)
  }

  /// Returns `self` as `ClosureShorthandParameterListSyntax`, when possible.
  @inlinable
  public var asClosureShorthandParameterListSyntax: ClosureShorthandParameterListSyntax? {
    self.as(ClosureShorthandParameterListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ClosureShorthandParameterListSyntax`.
  @inlinable
  public var isClosureShorthandParameterListSyntax: Bool {
    self.is(ClosureShorthandParameterListSyntax.self)
  }

  /// Returns `self` as `ClosureShorthandParameterSyntax`, when possible.
  @inlinable
  public var asClosureShorthandParameterSyntax: ClosureShorthandParameterSyntax? {
    self.as(ClosureShorthandParameterSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ClosureShorthandParameterSyntax`.
  @inlinable
  public var isClosureShorthandParameterSyntax: Bool {
    self.is(ClosureShorthandParameterSyntax.self)
  }

  /// Returns `self` as `ClosureSignatureSyntax`, when possible.
  @inlinable
  public var asClosureSignatureSyntax: ClosureSignatureSyntax? {
    self.as(ClosureSignatureSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ClosureSignatureSyntax`.
  @inlinable
  public var isClosureSignatureSyntax: Bool {
    self.is(ClosureSignatureSyntax.self)
  }

  /// Returns `self` as `CodeBlockItemListSyntax`, when possible.
  @inlinable
  public var asCodeBlockItemListSyntax: CodeBlockItemListSyntax? {
    self.as(CodeBlockItemListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `CodeBlockItemListSyntax`.
  @inlinable
  public var isCodeBlockItemListSyntax: Bool {
    self.is(CodeBlockItemListSyntax.self)
  }

  /// Returns `self` as `CodeBlockItemSyntax`, when possible.
  @inlinable
  public var asCodeBlockItemSyntax: CodeBlockItemSyntax? {
    self.as(CodeBlockItemSyntax.self)
  }

  /// `true` iff `self` can be viewed as `CodeBlockItemSyntax`.
  @inlinable
  public var isCodeBlockItemSyntax: Bool {
    self.is(CodeBlockItemSyntax.self)
  }

  /// Returns `self` as `CodeBlockSyntax`, when possible.
  @inlinable
  public var asCodeBlockSyntax: CodeBlockSyntax? {
    self.as(CodeBlockSyntax.self)
  }

  /// `true` iff `self` can be viewed as `CodeBlockSyntax`.
  @inlinable
  public var isCodeBlockSyntax: Bool {
    self.is(CodeBlockSyntax.self)
  }

  /// Returns `self` as `CompositionTypeElementListSyntax`, when possible.
  @inlinable
  public var asCompositionTypeElementListSyntax: CompositionTypeElementListSyntax? {
    self.as(CompositionTypeElementListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `CompositionTypeElementListSyntax`.
  @inlinable
  public var isCompositionTypeElementListSyntax: Bool {
    self.is(CompositionTypeElementListSyntax.self)
  }

  /// Returns `self` as `CompositionTypeElementSyntax`, when possible.
  @inlinable
  public var asCompositionTypeElementSyntax: CompositionTypeElementSyntax? {
    self.as(CompositionTypeElementSyntax.self)
  }

  /// `true` iff `self` can be viewed as `CompositionTypeElementSyntax`.
  @inlinable
  public var isCompositionTypeElementSyntax: Bool {
    self.is(CompositionTypeElementSyntax.self)
  }

  /// Returns `self` as `CompositionTypeSyntax`, when possible.
  @inlinable
  public var asCompositionTypeSyntax: CompositionTypeSyntax? {
    self.as(CompositionTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `CompositionTypeSyntax`.
  @inlinable
  public var isCompositionTypeSyntax: Bool {
    self.is(CompositionTypeSyntax.self)
  }

  /// Returns `self` as `ConditionElementListSyntax`, when possible.
  @inlinable
  public var asConditionElementListSyntax: ConditionElementListSyntax? {
    self.as(ConditionElementListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ConditionElementListSyntax`.
  @inlinable
  public var isConditionElementListSyntax: Bool {
    self.is(ConditionElementListSyntax.self)
  }

  /// Returns `self` as `ConditionElementSyntax`, when possible.
  @inlinable
  public var asConditionElementSyntax: ConditionElementSyntax? {
    self.as(ConditionElementSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ConditionElementSyntax`.
  @inlinable
  public var isConditionElementSyntax: Bool {
    self.is(ConditionElementSyntax.self)
  }

  /// Returns `self` as `ConformanceRequirementSyntax`, when possible.
  @inlinable
  public var asConformanceRequirementSyntax: ConformanceRequirementSyntax? {
    self.as(ConformanceRequirementSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ConformanceRequirementSyntax`.
  @inlinable
  public var isConformanceRequirementSyntax: Bool {
    self.is(ConformanceRequirementSyntax.self)
  }

  /// Returns `self` as `ConsumeExprSyntax`, when possible.
  @inlinable
  public var asConsumeExprSyntax: ConsumeExprSyntax? {
    self.as(ConsumeExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ConsumeExprSyntax`.
  @inlinable
  public var isConsumeExprSyntax: Bool {
    self.is(ConsumeExprSyntax.self)
  }

  /// Returns `self` as `ContinueStmtSyntax`, when possible.
  @inlinable
  public var asContinueStmtSyntax: ContinueStmtSyntax? {
    self.as(ContinueStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ContinueStmtSyntax`.
  @inlinable
  public var isContinueStmtSyntax: Bool {
    self.is(ContinueStmtSyntax.self)
  }

  /// Returns `self` as `CopyExprSyntax`, when possible.
  @inlinable
  public var asCopyExprSyntax: CopyExprSyntax? {
    self.as(CopyExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `CopyExprSyntax`.
  @inlinable
  public var isCopyExprSyntax: Bool {
    self.is(CopyExprSyntax.self)
  }

  /// Returns `self` as `DeclModifierDetailSyntax`, when possible.
  @inlinable
  public var asDeclModifierDetailSyntax: DeclModifierDetailSyntax? {
    self.as(DeclModifierDetailSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DeclModifierDetailSyntax`.
  @inlinable
  public var isDeclModifierDetailSyntax: Bool {
    self.is(DeclModifierDetailSyntax.self)
  }

  /// Returns `self` as `DeclModifierListSyntax`, when possible.
  @inlinable
  public var asDeclModifierListSyntax: DeclModifierListSyntax? {
    self.as(DeclModifierListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DeclModifierListSyntax`.
  @inlinable
  public var isDeclModifierListSyntax: Bool {
    self.is(DeclModifierListSyntax.self)
  }

  /// Returns `self` as `DeclModifierSyntax`, when possible.
  @inlinable
  public var asDeclModifierSyntax: DeclModifierSyntax? {
    self.as(DeclModifierSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DeclModifierSyntax`.
  @inlinable
  public var isDeclModifierSyntax: Bool {
    self.is(DeclModifierSyntax.self)
  }

  /// Returns `self` as `DeclNameArgumentListSyntax`, when possible.
  @inlinable
  public var asDeclNameArgumentListSyntax: DeclNameArgumentListSyntax? {
    self.as(DeclNameArgumentListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DeclNameArgumentListSyntax`.
  @inlinable
  public var isDeclNameArgumentListSyntax: Bool {
    self.is(DeclNameArgumentListSyntax.self)
  }

  /// Returns `self` as `DeclNameArgumentSyntax`, when possible.
  @inlinable
  public var asDeclNameArgumentSyntax: DeclNameArgumentSyntax? {
    self.as(DeclNameArgumentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DeclNameArgumentSyntax`.
  @inlinable
  public var isDeclNameArgumentSyntax: Bool {
    self.is(DeclNameArgumentSyntax.self)
  }

  /// Returns `self` as `DeclNameArgumentsSyntax`, when possible.
  @inlinable
  public var asDeclNameArgumentsSyntax: DeclNameArgumentsSyntax? {
    self.as(DeclNameArgumentsSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DeclNameArgumentsSyntax`.
  @inlinable
  public var isDeclNameArgumentsSyntax: Bool {
    self.is(DeclNameArgumentsSyntax.self)
  }

  /// Returns `self` as `DeclReferenceExprSyntax`, when possible.
  @inlinable
  public var asDeclReferenceExprSyntax: DeclReferenceExprSyntax? {
    self.as(DeclReferenceExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DeclReferenceExprSyntax`.
  @inlinable
  public var isDeclReferenceExprSyntax: Bool {
    self.is(DeclReferenceExprSyntax.self)
  }

  /// Returns `self` as `DeclSyntax`, when possible.
  @inlinable
  public var asDeclSyntax: DeclSyntax? {
    self.as(DeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DeclSyntax`.
  @inlinable
  public var isDeclSyntax: Bool {
    self.is(DeclSyntax.self)
  }

  /// Returns `self` as `DeferStmtSyntax`, when possible.
  @inlinable
  public var asDeferStmtSyntax: DeferStmtSyntax? {
    self.as(DeferStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DeferStmtSyntax`.
  @inlinable
  public var isDeferStmtSyntax: Bool {
    self.is(DeferStmtSyntax.self)
  }

  /// Returns `self` as `DeinitializerDeclSyntax`, when possible.
  @inlinable
  public var asDeinitializerDeclSyntax: DeinitializerDeclSyntax? {
    self.as(DeinitializerDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DeinitializerDeclSyntax`.
  @inlinable
  public var isDeinitializerDeclSyntax: Bool {
    self.is(DeinitializerDeclSyntax.self)
  }

  /// Returns `self` as `DeinitializerEffectSpecifiersSyntax`, when possible.
  @inlinable
  public var asDeinitializerEffectSpecifiersSyntax: DeinitializerEffectSpecifiersSyntax? {
    self.as(DeinitializerEffectSpecifiersSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DeinitializerEffectSpecifiersSyntax`.
  @inlinable
  public var isDeinitializerEffectSpecifiersSyntax: Bool {
    self.is(DeinitializerEffectSpecifiersSyntax.self)
  }

  /// Returns `self` as `DerivativeAttributeArgumentsSyntax`, when possible.
  @inlinable
  public var asDerivativeAttributeArgumentsSyntax: DerivativeAttributeArgumentsSyntax? {
    self.as(DerivativeAttributeArgumentsSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DerivativeAttributeArgumentsSyntax`.
  @inlinable
  public var isDerivativeAttributeArgumentsSyntax: Bool {
    self.is(DerivativeAttributeArgumentsSyntax.self)
  }

  /// Returns `self` as `DesignatedTypeListSyntax`, when possible.
  @inlinable
  public var asDesignatedTypeListSyntax: DesignatedTypeListSyntax? {
    self.as(DesignatedTypeListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DesignatedTypeListSyntax`.
  @inlinable
  public var isDesignatedTypeListSyntax: Bool {
    self.is(DesignatedTypeListSyntax.self)
  }

  /// Returns `self` as `DesignatedTypeSyntax`, when possible.
  @inlinable
  public var asDesignatedTypeSyntax: DesignatedTypeSyntax? {
    self.as(DesignatedTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DesignatedTypeSyntax`.
  @inlinable
  public var isDesignatedTypeSyntax: Bool {
    self.is(DesignatedTypeSyntax.self)
  }

  /// Returns `self` as `DictionaryElementListSyntax`, when possible.
  @inlinable
  public var asDictionaryElementListSyntax: DictionaryElementListSyntax? {
    self.as(DictionaryElementListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DictionaryElementListSyntax`.
  @inlinable
  public var isDictionaryElementListSyntax: Bool {
    self.is(DictionaryElementListSyntax.self)
  }

  /// Returns `self` as `DictionaryElementSyntax`, when possible.
  @inlinable
  public var asDictionaryElementSyntax: DictionaryElementSyntax? {
    self.as(DictionaryElementSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DictionaryElementSyntax`.
  @inlinable
  public var isDictionaryElementSyntax: Bool {
    self.is(DictionaryElementSyntax.self)
  }

  /// Returns `self` as `DictionaryExprSyntax`, when possible.
  @inlinable
  public var asDictionaryExprSyntax: DictionaryExprSyntax? {
    self.as(DictionaryExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DictionaryExprSyntax`.
  @inlinable
  public var isDictionaryExprSyntax: Bool {
    self.is(DictionaryExprSyntax.self)
  }

  /// Returns `self` as `DictionaryTypeSyntax`, when possible.
  @inlinable
  public var asDictionaryTypeSyntax: DictionaryTypeSyntax? {
    self.as(DictionaryTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DictionaryTypeSyntax`.
  @inlinable
  public var isDictionaryTypeSyntax: Bool {
    self.is(DictionaryTypeSyntax.self)
  }

  /// Returns `self` as `DifferentiabilityArgumentListSyntax`, when possible.
  @inlinable
  public var asDifferentiabilityArgumentListSyntax: DifferentiabilityArgumentListSyntax? {
    self.as(DifferentiabilityArgumentListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DifferentiabilityArgumentListSyntax`.
  @inlinable
  public var isDifferentiabilityArgumentListSyntax: Bool {
    self.is(DifferentiabilityArgumentListSyntax.self)
  }

  /// Returns `self` as `DifferentiabilityArgumentSyntax`, when possible.
  @inlinable
  public var asDifferentiabilityArgumentSyntax: DifferentiabilityArgumentSyntax? {
    self.as(DifferentiabilityArgumentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DifferentiabilityArgumentSyntax`.
  @inlinable
  public var isDifferentiabilityArgumentSyntax: Bool {
    self.is(DifferentiabilityArgumentSyntax.self)
  }

  /// Returns `self` as `DifferentiabilityArgumentsSyntax`, when possible.
  @inlinable
  public var asDifferentiabilityArgumentsSyntax: DifferentiabilityArgumentsSyntax? {
    self.as(DifferentiabilityArgumentsSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DifferentiabilityArgumentsSyntax`.
  @inlinable
  public var isDifferentiabilityArgumentsSyntax: Bool {
    self.is(DifferentiabilityArgumentsSyntax.self)
  }

  /// Returns `self` as `DifferentiabilityWithRespectToArgumentSyntax`, when possible.
  @inlinable
  public var asDifferentiabilityWithRespectToArgumentSyntax: DifferentiabilityWithRespectToArgumentSyntax? {
    self.as(DifferentiabilityWithRespectToArgumentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DifferentiabilityWithRespectToArgumentSyntax`.
  @inlinable
  public var isDifferentiabilityWithRespectToArgumentSyntax: Bool {
    self.is(DifferentiabilityWithRespectToArgumentSyntax.self)
  }

  /// Returns `self` as `DifferentiableAttributeArgumentsSyntax`, when possible.
  @inlinable
  public var asDifferentiableAttributeArgumentsSyntax: DifferentiableAttributeArgumentsSyntax? {
    self.as(DifferentiableAttributeArgumentsSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DifferentiableAttributeArgumentsSyntax`.
  @inlinable
  public var isDifferentiableAttributeArgumentsSyntax: Bool {
    self.is(DifferentiableAttributeArgumentsSyntax.self)
  }

  /// Returns `self` as `DiscardAssignmentExprSyntax`, when possible.
  @inlinable
  public var asDiscardAssignmentExprSyntax: DiscardAssignmentExprSyntax? {
    self.as(DiscardAssignmentExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DiscardAssignmentExprSyntax`.
  @inlinable
  public var isDiscardAssignmentExprSyntax: Bool {
    self.is(DiscardAssignmentExprSyntax.self)
  }

  /// Returns `self` as `DiscardStmtSyntax`, when possible.
  @inlinable
  public var asDiscardStmtSyntax: DiscardStmtSyntax? {
    self.as(DiscardStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DiscardStmtSyntax`.
  @inlinable
  public var isDiscardStmtSyntax: Bool {
    self.is(DiscardStmtSyntax.self)
  }

  /// Returns `self` as `DoStmtSyntax`, when possible.
  @inlinable
  public var asDoStmtSyntax: DoStmtSyntax? {
    self.as(DoStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DoStmtSyntax`.
  @inlinable
  public var isDoStmtSyntax: Bool {
    self.is(DoStmtSyntax.self)
  }

  /// Returns `self` as `DocumentationAttributeArgumentListSyntax`, when possible.
  @inlinable
  public var asDocumentationAttributeArgumentListSyntax: DocumentationAttributeArgumentListSyntax? {
    self.as(DocumentationAttributeArgumentListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DocumentationAttributeArgumentListSyntax`.
  @inlinable
  public var isDocumentationAttributeArgumentListSyntax: Bool {
    self.is(DocumentationAttributeArgumentListSyntax.self)
  }

  /// Returns `self` as `DocumentationAttributeArgumentSyntax`, when possible.
  @inlinable
  public var asDocumentationAttributeArgumentSyntax: DocumentationAttributeArgumentSyntax? {
    self.as(DocumentationAttributeArgumentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DocumentationAttributeArgumentSyntax`.
  @inlinable
  public var isDocumentationAttributeArgumentSyntax: Bool {
    self.is(DocumentationAttributeArgumentSyntax.self)
  }

  /// Returns `self` as `DynamicReplacementAttributeArgumentsSyntax`, when possible.
  @inlinable
  public var asDynamicReplacementAttributeArgumentsSyntax: DynamicReplacementAttributeArgumentsSyntax? {
    self.as(DynamicReplacementAttributeArgumentsSyntax.self)
  }

  /// `true` iff `self` can be viewed as `DynamicReplacementAttributeArgumentsSyntax`.
  @inlinable
  public var isDynamicReplacementAttributeArgumentsSyntax: Bool {
    self.is(DynamicReplacementAttributeArgumentsSyntax.self)
  }

  /// Returns `self` as `EditorPlaceholderDeclSyntax`, when possible.
  @inlinable
  public var asEditorPlaceholderDeclSyntax: EditorPlaceholderDeclSyntax? {
    self.as(EditorPlaceholderDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `EditorPlaceholderDeclSyntax`.
  @inlinable
  public var isEditorPlaceholderDeclSyntax: Bool {
    self.is(EditorPlaceholderDeclSyntax.self)
  }

  /// Returns `self` as `EditorPlaceholderExprSyntax`, when possible.
  @inlinable
  public var asEditorPlaceholderExprSyntax: EditorPlaceholderExprSyntax? {
    self.as(EditorPlaceholderExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `EditorPlaceholderExprSyntax`.
  @inlinable
  public var isEditorPlaceholderExprSyntax: Bool {
    self.is(EditorPlaceholderExprSyntax.self)
  }

  /// Returns `self` as `EffectsAttributeArgumentListSyntax`, when possible.
  @inlinable
  public var asEffectsAttributeArgumentListSyntax: EffectsAttributeArgumentListSyntax? {
    self.as(EffectsAttributeArgumentListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `EffectsAttributeArgumentListSyntax`.
  @inlinable
  public var isEffectsAttributeArgumentListSyntax: Bool {
    self.is(EffectsAttributeArgumentListSyntax.self)
  }

  /// Returns `self` as `EnumCaseDeclSyntax`, when possible.
  @inlinable
  public var asEnumCaseDeclSyntax: EnumCaseDeclSyntax? {
    self.as(EnumCaseDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `EnumCaseDeclSyntax`.
  @inlinable
  public var isEnumCaseDeclSyntax: Bool {
    self.is(EnumCaseDeclSyntax.self)
  }

  /// Returns `self` as `EnumCaseElementListSyntax`, when possible.
  @inlinable
  public var asEnumCaseElementListSyntax: EnumCaseElementListSyntax? {
    self.as(EnumCaseElementListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `EnumCaseElementListSyntax`.
  @inlinable
  public var isEnumCaseElementListSyntax: Bool {
    self.is(EnumCaseElementListSyntax.self)
  }

  /// Returns `self` as `EnumCaseElementSyntax`, when possible.
  @inlinable
  public var asEnumCaseElementSyntax: EnumCaseElementSyntax? {
    self.as(EnumCaseElementSyntax.self)
  }

  /// `true` iff `self` can be viewed as `EnumCaseElementSyntax`.
  @inlinable
  public var isEnumCaseElementSyntax: Bool {
    self.is(EnumCaseElementSyntax.self)
  }

  /// Returns `self` as `EnumCaseParameterClauseSyntax`, when possible.
  @inlinable
  public var asEnumCaseParameterClauseSyntax: EnumCaseParameterClauseSyntax? {
    self.as(EnumCaseParameterClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `EnumCaseParameterClauseSyntax`.
  @inlinable
  public var isEnumCaseParameterClauseSyntax: Bool {
    self.is(EnumCaseParameterClauseSyntax.self)
  }

  /// Returns `self` as `EnumCaseParameterListSyntax`, when possible.
  @inlinable
  public var asEnumCaseParameterListSyntax: EnumCaseParameterListSyntax? {
    self.as(EnumCaseParameterListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `EnumCaseParameterListSyntax`.
  @inlinable
  public var isEnumCaseParameterListSyntax: Bool {
    self.is(EnumCaseParameterListSyntax.self)
  }

  /// Returns `self` as `EnumCaseParameterSyntax`, when possible.
  @inlinable
  public var asEnumCaseParameterSyntax: EnumCaseParameterSyntax? {
    self.as(EnumCaseParameterSyntax.self)
  }

  /// `true` iff `self` can be viewed as `EnumCaseParameterSyntax`.
  @inlinable
  public var isEnumCaseParameterSyntax: Bool {
    self.is(EnumCaseParameterSyntax.self)
  }

  /// Returns `self` as `EnumDeclSyntax`, when possible.
  @inlinable
  public var asEnumDeclSyntax: EnumDeclSyntax? {
    self.as(EnumDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `EnumDeclSyntax`.
  @inlinable
  public var isEnumDeclSyntax: Bool {
    self.is(EnumDeclSyntax.self)
  }

  /// Returns `self` as `ExprListSyntax`, when possible.
  @inlinable
  public var asExprListSyntax: ExprListSyntax? {
    self.as(ExprListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ExprListSyntax`.
  @inlinable
  public var isExprListSyntax: Bool {
    self.is(ExprListSyntax.self)
  }

  /// Returns `self` as `ExprSyntax`, when possible.
  @inlinable
  public var asExprSyntax: ExprSyntax? {
    self.as(ExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ExprSyntax`.
  @inlinable
  public var isExprSyntax: Bool {
    self.is(ExprSyntax.self)
  }

  /// Returns `self` as `ExpressionPatternSyntax`, when possible.
  @inlinable
  public var asExpressionPatternSyntax: ExpressionPatternSyntax? {
    self.as(ExpressionPatternSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ExpressionPatternSyntax`.
  @inlinable
  public var isExpressionPatternSyntax: Bool {
    self.is(ExpressionPatternSyntax.self)
  }

  /// Returns `self` as `ExpressionSegmentSyntax`, when possible.
  @inlinable
  public var asExpressionSegmentSyntax: ExpressionSegmentSyntax? {
    self.as(ExpressionSegmentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ExpressionSegmentSyntax`.
  @inlinable
  public var isExpressionSegmentSyntax: Bool {
    self.is(ExpressionSegmentSyntax.self)
  }

  /// Returns `self` as `ExpressionStmtSyntax`, when possible.
  @inlinable
  public var asExpressionStmtSyntax: ExpressionStmtSyntax? {
    self.as(ExpressionStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ExpressionStmtSyntax`.
  @inlinable
  public var isExpressionStmtSyntax: Bool {
    self.is(ExpressionStmtSyntax.self)
  }

  /// Returns `self` as `ExtensionDeclSyntax`, when possible.
  @inlinable
  public var asExtensionDeclSyntax: ExtensionDeclSyntax? {
    self.as(ExtensionDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ExtensionDeclSyntax`.
  @inlinable
  public var isExtensionDeclSyntax: Bool {
    self.is(ExtensionDeclSyntax.self)
  }

  /// Returns `self` as `FallThroughStmtSyntax`, when possible.
  @inlinable
  public var asFallThroughStmtSyntax: FallThroughStmtSyntax? {
    self.as(FallThroughStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `FallThroughStmtSyntax`.
  @inlinable
  public var isFallThroughStmtSyntax: Bool {
    self.is(FallThroughStmtSyntax.self)
  }

  /// Returns `self` as `FloatLiteralExprSyntax`, when possible.
  @inlinable
  public var asFloatLiteralExprSyntax: FloatLiteralExprSyntax? {
    self.as(FloatLiteralExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `FloatLiteralExprSyntax`.
  @inlinable
  public var isFloatLiteralExprSyntax: Bool {
    self.is(FloatLiteralExprSyntax.self)
  }

  /// Returns `self` as `ForStmtSyntax`, when possible.
  @inlinable
  public var asForStmtSyntax: ForStmtSyntax? {
    self.as(ForStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ForStmtSyntax`.
  @inlinable
  public var isForStmtSyntax: Bool {
    self.is(ForStmtSyntax.self)
  }

  /// Returns `self` as `ForceUnwrapExprSyntax`, when possible.
  @inlinable
  public var asForceUnwrapExprSyntax: ForceUnwrapExprSyntax? {
    self.as(ForceUnwrapExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ForceUnwrapExprSyntax`.
  @inlinable
  public var isForceUnwrapExprSyntax: Bool {
    self.is(ForceUnwrapExprSyntax.self)
  }

  /// Returns `self` as `FunctionCallExprSyntax`, when possible.
  @inlinable
  public var asFunctionCallExprSyntax: FunctionCallExprSyntax? {
    self.as(FunctionCallExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `FunctionCallExprSyntax`.
  @inlinable
  public var isFunctionCallExprSyntax: Bool {
    self.is(FunctionCallExprSyntax.self)
  }

  /// Returns `self` as `FunctionDeclSyntax`, when possible.
  @inlinable
  public var asFunctionDeclSyntax: FunctionDeclSyntax? {
    self.as(FunctionDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `FunctionDeclSyntax`.
  @inlinable
  public var isFunctionDeclSyntax: Bool {
    self.is(FunctionDeclSyntax.self)
  }

  /// Returns `self` as `FunctionEffectSpecifiersSyntax`, when possible.
  @inlinable
  public var asFunctionEffectSpecifiersSyntax: FunctionEffectSpecifiersSyntax? {
    self.as(FunctionEffectSpecifiersSyntax.self)
  }

  /// `true` iff `self` can be viewed as `FunctionEffectSpecifiersSyntax`.
  @inlinable
  public var isFunctionEffectSpecifiersSyntax: Bool {
    self.is(FunctionEffectSpecifiersSyntax.self)
  }

  /// Returns `self` as `FunctionParameterClauseSyntax`, when possible.
  @inlinable
  public var asFunctionParameterClauseSyntax: FunctionParameterClauseSyntax? {
    self.as(FunctionParameterClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `FunctionParameterClauseSyntax`.
  @inlinable
  public var isFunctionParameterClauseSyntax: Bool {
    self.is(FunctionParameterClauseSyntax.self)
  }

  /// Returns `self` as `FunctionParameterListSyntax`, when possible.
  @inlinable
  public var asFunctionParameterListSyntax: FunctionParameterListSyntax? {
    self.as(FunctionParameterListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `FunctionParameterListSyntax`.
  @inlinable
  public var isFunctionParameterListSyntax: Bool {
    self.is(FunctionParameterListSyntax.self)
  }

  /// Returns `self` as `FunctionParameterSyntax`, when possible.
  @inlinable
  public var asFunctionParameterSyntax: FunctionParameterSyntax? {
    self.as(FunctionParameterSyntax.self)
  }

  /// `true` iff `self` can be viewed as `FunctionParameterSyntax`.
  @inlinable
  public var isFunctionParameterSyntax: Bool {
    self.is(FunctionParameterSyntax.self)
  }

  /// Returns `self` as `FunctionSignatureSyntax`, when possible.
  @inlinable
  public var asFunctionSignatureSyntax: FunctionSignatureSyntax? {
    self.as(FunctionSignatureSyntax.self)
  }

  /// `true` iff `self` can be viewed as `FunctionSignatureSyntax`.
  @inlinable
  public var isFunctionSignatureSyntax: Bool {
    self.is(FunctionSignatureSyntax.self)
  }

  /// Returns `self` as `FunctionTypeSyntax`, when possible.
  @inlinable
  public var asFunctionTypeSyntax: FunctionTypeSyntax? {
    self.as(FunctionTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `FunctionTypeSyntax`.
  @inlinable
  public var isFunctionTypeSyntax: Bool {
    self.is(FunctionTypeSyntax.self)
  }

  /// Returns `self` as `GenericArgumentClauseSyntax`, when possible.
  @inlinable
  public var asGenericArgumentClauseSyntax: GenericArgumentClauseSyntax? {
    self.as(GenericArgumentClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `GenericArgumentClauseSyntax`.
  @inlinable
  public var isGenericArgumentClauseSyntax: Bool {
    self.is(GenericArgumentClauseSyntax.self)
  }

  /// Returns `self` as `GenericArgumentListSyntax`, when possible.
  @inlinable
  public var asGenericArgumentListSyntax: GenericArgumentListSyntax? {
    self.as(GenericArgumentListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `GenericArgumentListSyntax`.
  @inlinable
  public var isGenericArgumentListSyntax: Bool {
    self.is(GenericArgumentListSyntax.self)
  }

  /// Returns `self` as `GenericArgumentSyntax`, when possible.
  @inlinable
  public var asGenericArgumentSyntax: GenericArgumentSyntax? {
    self.as(GenericArgumentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `GenericArgumentSyntax`.
  @inlinable
  public var isGenericArgumentSyntax: Bool {
    self.is(GenericArgumentSyntax.self)
  }

  /// Returns `self` as `GenericParameterClauseSyntax`, when possible.
  @inlinable
  public var asGenericParameterClauseSyntax: GenericParameterClauseSyntax? {
    self.as(GenericParameterClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `GenericParameterClauseSyntax`.
  @inlinable
  public var isGenericParameterClauseSyntax: Bool {
    self.is(GenericParameterClauseSyntax.self)
  }

  /// Returns `self` as `GenericParameterListSyntax`, when possible.
  @inlinable
  public var asGenericParameterListSyntax: GenericParameterListSyntax? {
    self.as(GenericParameterListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `GenericParameterListSyntax`.
  @inlinable
  public var isGenericParameterListSyntax: Bool {
    self.is(GenericParameterListSyntax.self)
  }

  /// Returns `self` as `GenericParameterSyntax`, when possible.
  @inlinable
  public var asGenericParameterSyntax: GenericParameterSyntax? {
    self.as(GenericParameterSyntax.self)
  }

  /// `true` iff `self` can be viewed as `GenericParameterSyntax`.
  @inlinable
  public var isGenericParameterSyntax: Bool {
    self.is(GenericParameterSyntax.self)
  }

  /// Returns `self` as `GenericRequirementListSyntax`, when possible.
  @inlinable
  public var asGenericRequirementListSyntax: GenericRequirementListSyntax? {
    self.as(GenericRequirementListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `GenericRequirementListSyntax`.
  @inlinable
  public var isGenericRequirementListSyntax: Bool {
    self.is(GenericRequirementListSyntax.self)
  }

  /// Returns `self` as `GenericRequirementSyntax`, when possible.
  @inlinable
  public var asGenericRequirementSyntax: GenericRequirementSyntax? {
    self.as(GenericRequirementSyntax.self)
  }

  /// `true` iff `self` can be viewed as `GenericRequirementSyntax`.
  @inlinable
  public var isGenericRequirementSyntax: Bool {
    self.is(GenericRequirementSyntax.self)
  }

  /// Returns `self` as `GenericSpecializationExprSyntax`, when possible.
  @inlinable
  public var asGenericSpecializationExprSyntax: GenericSpecializationExprSyntax? {
    self.as(GenericSpecializationExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `GenericSpecializationExprSyntax`.
  @inlinable
  public var isGenericSpecializationExprSyntax: Bool {
    self.is(GenericSpecializationExprSyntax.self)
  }

  /// Returns `self` as `GenericWhereClauseSyntax`, when possible.
  @inlinable
  public var asGenericWhereClauseSyntax: GenericWhereClauseSyntax? {
    self.as(GenericWhereClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `GenericWhereClauseSyntax`.
  @inlinable
  public var isGenericWhereClauseSyntax: Bool {
    self.is(GenericWhereClauseSyntax.self)
  }

  /// Returns `self` as `GuardStmtSyntax`, when possible.
  @inlinable
  public var asGuardStmtSyntax: GuardStmtSyntax? {
    self.as(GuardStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `GuardStmtSyntax`.
  @inlinable
  public var isGuardStmtSyntax: Bool {
    self.is(GuardStmtSyntax.self)
  }

  /// Returns `self` as `IdentifierPatternSyntax`, when possible.
  @inlinable
  public var asIdentifierPatternSyntax: IdentifierPatternSyntax? {
    self.as(IdentifierPatternSyntax.self)
  }

  /// `true` iff `self` can be viewed as `IdentifierPatternSyntax`.
  @inlinable
  public var isIdentifierPatternSyntax: Bool {
    self.is(IdentifierPatternSyntax.self)
  }

  /// Returns `self` as `IdentifierTypeSyntax`, when possible.
  @inlinable
  public var asIdentifierTypeSyntax: IdentifierTypeSyntax? {
    self.as(IdentifierTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `IdentifierTypeSyntax`.
  @inlinable
  public var isIdentifierTypeSyntax: Bool {
    self.is(IdentifierTypeSyntax.self)
  }

  /// Returns `self` as `IfConfigClauseListSyntax`, when possible.
  @inlinable
  public var asIfConfigClauseListSyntax: IfConfigClauseListSyntax? {
    self.as(IfConfigClauseListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `IfConfigClauseListSyntax`.
  @inlinable
  public var isIfConfigClauseListSyntax: Bool {
    self.is(IfConfigClauseListSyntax.self)
  }

  /// Returns `self` as `IfConfigClauseSyntax`, when possible.
  @inlinable
  public var asIfConfigClauseSyntax: IfConfigClauseSyntax? {
    self.as(IfConfigClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `IfConfigClauseSyntax`.
  @inlinable
  public var isIfConfigClauseSyntax: Bool {
    self.is(IfConfigClauseSyntax.self)
  }

  /// Returns `self` as `IfConfigDeclSyntax`, when possible.
  @inlinable
  public var asIfConfigDeclSyntax: IfConfigDeclSyntax? {
    self.as(IfConfigDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `IfConfigDeclSyntax`.
  @inlinable
  public var isIfConfigDeclSyntax: Bool {
    self.is(IfConfigDeclSyntax.self)
  }

  /// Returns `self` as `IfExprSyntax`, when possible.
  @inlinable
  public var asIfExprSyntax: IfExprSyntax? {
    self.as(IfExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `IfExprSyntax`.
  @inlinable
  public var isIfExprSyntax: Bool {
    self.is(IfExprSyntax.self)
  }

  /// Returns `self` as `ImplementsAttributeArgumentsSyntax`, when possible.
  @inlinable
  public var asImplementsAttributeArgumentsSyntax: ImplementsAttributeArgumentsSyntax? {
    self.as(ImplementsAttributeArgumentsSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ImplementsAttributeArgumentsSyntax`.
  @inlinable
  public var isImplementsAttributeArgumentsSyntax: Bool {
    self.is(ImplementsAttributeArgumentsSyntax.self)
  }

  /// Returns `self` as `ImplicitlyUnwrappedOptionalTypeSyntax`, when possible.
  @inlinable
  public var asImplicitlyUnwrappedOptionalTypeSyntax: ImplicitlyUnwrappedOptionalTypeSyntax? {
    self.as(ImplicitlyUnwrappedOptionalTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ImplicitlyUnwrappedOptionalTypeSyntax`.
  @inlinable
  public var isImplicitlyUnwrappedOptionalTypeSyntax: Bool {
    self.is(ImplicitlyUnwrappedOptionalTypeSyntax.self)
  }

  /// Returns `self` as `ImportDeclSyntax`, when possible.
  @inlinable
  public var asImportDeclSyntax: ImportDeclSyntax? {
    self.as(ImportDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ImportDeclSyntax`.
  @inlinable
  public var isImportDeclSyntax: Bool {
    self.is(ImportDeclSyntax.self)
  }

  /// Returns `self` as `ImportPathComponentListSyntax`, when possible.
  @inlinable
  public var asImportPathComponentListSyntax: ImportPathComponentListSyntax? {
    self.as(ImportPathComponentListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ImportPathComponentListSyntax`.
  @inlinable
  public var isImportPathComponentListSyntax: Bool {
    self.is(ImportPathComponentListSyntax.self)
  }

  /// Returns `self` as `ImportPathComponentSyntax`, when possible.
  @inlinable
  public var asImportPathComponentSyntax: ImportPathComponentSyntax? {
    self.as(ImportPathComponentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ImportPathComponentSyntax`.
  @inlinable
  public var isImportPathComponentSyntax: Bool {
    self.is(ImportPathComponentSyntax.self)
  }

  /// Returns `self` as `InOutExprSyntax`, when possible.
  @inlinable
  public var asInOutExprSyntax: InOutExprSyntax? {
    self.as(InOutExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `InOutExprSyntax`.
  @inlinable
  public var isInOutExprSyntax: Bool {
    self.is(InOutExprSyntax.self)
  }

  /// Returns `self` as `InfixOperatorExprSyntax`, when possible.
  @inlinable
  public var asInfixOperatorExprSyntax: InfixOperatorExprSyntax? {
    self.as(InfixOperatorExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `InfixOperatorExprSyntax`.
  @inlinable
  public var isInfixOperatorExprSyntax: Bool {
    self.is(InfixOperatorExprSyntax.self)
  }

  /// Returns `self` as `InheritanceClauseSyntax`, when possible.
  @inlinable
  public var asInheritanceClauseSyntax: InheritanceClauseSyntax? {
    self.as(InheritanceClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `InheritanceClauseSyntax`.
  @inlinable
  public var isInheritanceClauseSyntax: Bool {
    self.is(InheritanceClauseSyntax.self)
  }

  /// Returns `self` as `InheritedTypeListSyntax`, when possible.
  @inlinable
  public var asInheritedTypeListSyntax: InheritedTypeListSyntax? {
    self.as(InheritedTypeListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `InheritedTypeListSyntax`.
  @inlinable
  public var isInheritedTypeListSyntax: Bool {
    self.is(InheritedTypeListSyntax.self)
  }

  /// Returns `self` as `InheritedTypeSyntax`, when possible.
  @inlinable
  public var asInheritedTypeSyntax: InheritedTypeSyntax? {
    self.as(InheritedTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `InheritedTypeSyntax`.
  @inlinable
  public var isInheritedTypeSyntax: Bool {
    self.is(InheritedTypeSyntax.self)
  }

  /// Returns `self` as `InitializerClauseSyntax`, when possible.
  @inlinable
  public var asInitializerClauseSyntax: InitializerClauseSyntax? {
    self.as(InitializerClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `InitializerClauseSyntax`.
  @inlinable
  public var isInitializerClauseSyntax: Bool {
    self.is(InitializerClauseSyntax.self)
  }

  /// Returns `self` as `InitializerDeclSyntax`, when possible.
  @inlinable
  public var asInitializerDeclSyntax: InitializerDeclSyntax? {
    self.as(InitializerDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `InitializerDeclSyntax`.
  @inlinable
  public var isInitializerDeclSyntax: Bool {
    self.is(InitializerDeclSyntax.self)
  }

  /// Returns `self` as `InlineArrayTypeSyntax`, when possible.
  @inlinable
  public var asInlineArrayTypeSyntax: InlineArrayTypeSyntax? {
    self.as(InlineArrayTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `InlineArrayTypeSyntax`.
  @inlinable
  public var isInlineArrayTypeSyntax: Bool {
    self.is(InlineArrayTypeSyntax.self)
  }

  /// Returns `self` as `IntegerLiteralExprSyntax`, when possible.
  @inlinable
  public var asIntegerLiteralExprSyntax: IntegerLiteralExprSyntax? {
    self.as(IntegerLiteralExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `IntegerLiteralExprSyntax`.
  @inlinable
  public var isIntegerLiteralExprSyntax: Bool {
    self.is(IntegerLiteralExprSyntax.self)
  }

  /// Returns `self` as `IsExprSyntax`, when possible.
  @inlinable
  public var asIsExprSyntax: IsExprSyntax? {
    self.as(IsExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `IsExprSyntax`.
  @inlinable
  public var isIsExprSyntax: Bool {
    self.is(IsExprSyntax.self)
  }

  /// Returns `self` as `IsTypePatternSyntax`, when possible.
  @inlinable
  public var asIsTypePatternSyntax: IsTypePatternSyntax? {
    self.as(IsTypePatternSyntax.self)
  }

  /// `true` iff `self` can be viewed as `IsTypePatternSyntax`.
  @inlinable
  public var isIsTypePatternSyntax: Bool {
    self.is(IsTypePatternSyntax.self)
  }

  /// Returns `self` as `KeyPathComponentListSyntax`, when possible.
  @inlinable
  public var asKeyPathComponentListSyntax: KeyPathComponentListSyntax? {
    self.as(KeyPathComponentListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `KeyPathComponentListSyntax`.
  @inlinable
  public var isKeyPathComponentListSyntax: Bool {
    self.is(KeyPathComponentListSyntax.self)
  }

  /// Returns `self` as `KeyPathComponentSyntax`, when possible.
  @inlinable
  public var asKeyPathComponentSyntax: KeyPathComponentSyntax? {
    self.as(KeyPathComponentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `KeyPathComponentSyntax`.
  @inlinable
  public var isKeyPathComponentSyntax: Bool {
    self.is(KeyPathComponentSyntax.self)
  }

  /// Returns `self` as `KeyPathExprSyntax`, when possible.
  @inlinable
  public var asKeyPathExprSyntax: KeyPathExprSyntax? {
    self.as(KeyPathExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `KeyPathExprSyntax`.
  @inlinable
  public var isKeyPathExprSyntax: Bool {
    self.is(KeyPathExprSyntax.self)
  }

  /// Returns `self` as `KeyPathOptionalComponentSyntax`, when possible.
  @inlinable
  public var asKeyPathOptionalComponentSyntax: KeyPathOptionalComponentSyntax? {
    self.as(KeyPathOptionalComponentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `KeyPathOptionalComponentSyntax`.
  @inlinable
  public var isKeyPathOptionalComponentSyntax: Bool {
    self.is(KeyPathOptionalComponentSyntax.self)
  }

  /// Returns `self` as `KeyPathPropertyComponentSyntax`, when possible.
  @inlinable
  public var asKeyPathPropertyComponentSyntax: KeyPathPropertyComponentSyntax? {
    self.as(KeyPathPropertyComponentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `KeyPathPropertyComponentSyntax`.
  @inlinable
  public var isKeyPathPropertyComponentSyntax: Bool {
    self.is(KeyPathPropertyComponentSyntax.self)
  }

  /// Returns `self` as `KeyPathSubscriptComponentSyntax`, when possible.
  @inlinable
  public var asKeyPathSubscriptComponentSyntax: KeyPathSubscriptComponentSyntax? {
    self.as(KeyPathSubscriptComponentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `KeyPathSubscriptComponentSyntax`.
  @inlinable
  public var isKeyPathSubscriptComponentSyntax: Bool {
    self.is(KeyPathSubscriptComponentSyntax.self)
  }

  /// Returns `self` as `LabeledExprListSyntax`, when possible.
  @inlinable
  public var asLabeledExprListSyntax: LabeledExprListSyntax? {
    self.as(LabeledExprListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `LabeledExprListSyntax`.
  @inlinable
  public var isLabeledExprListSyntax: Bool {
    self.is(LabeledExprListSyntax.self)
  }

  /// Returns `self` as `LabeledExprSyntax`, when possible.
  @inlinable
  public var asLabeledExprSyntax: LabeledExprSyntax? {
    self.as(LabeledExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `LabeledExprSyntax`.
  @inlinable
  public var isLabeledExprSyntax: Bool {
    self.is(LabeledExprSyntax.self)
  }

  /// Returns `self` as `LabeledSpecializeArgumentSyntax`, when possible.
  @inlinable
  public var asLabeledSpecializeArgumentSyntax: LabeledSpecializeArgumentSyntax? {
    self.as(LabeledSpecializeArgumentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `LabeledSpecializeArgumentSyntax`.
  @inlinable
  public var isLabeledSpecializeArgumentSyntax: Bool {
    self.is(LabeledSpecializeArgumentSyntax.self)
  }

  /// Returns `self` as `LabeledStmtSyntax`, when possible.
  @inlinable
  public var asLabeledStmtSyntax: LabeledStmtSyntax? {
    self.as(LabeledStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `LabeledStmtSyntax`.
  @inlinable
  public var isLabeledStmtSyntax: Bool {
    self.is(LabeledStmtSyntax.self)
  }

  /// Returns `self` as `LayoutRequirementSyntax`, when possible.
  @inlinable
  public var asLayoutRequirementSyntax: LayoutRequirementSyntax? {
    self.as(LayoutRequirementSyntax.self)
  }

  /// `true` iff `self` can be viewed as `LayoutRequirementSyntax`.
  @inlinable
  public var isLayoutRequirementSyntax: Bool {
    self.is(LayoutRequirementSyntax.self)
  }

  /// Returns `self` as `MacroDeclSyntax`, when possible.
  @inlinable
  public var asMacroDeclSyntax: MacroDeclSyntax? {
    self.as(MacroDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MacroDeclSyntax`.
  @inlinable
  public var isMacroDeclSyntax: Bool {
    self.is(MacroDeclSyntax.self)
  }

  /// Returns `self` as `MacroExpansionDeclSyntax`, when possible.
  @inlinable
  public var asMacroExpansionDeclSyntax: MacroExpansionDeclSyntax? {
    self.as(MacroExpansionDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MacroExpansionDeclSyntax`.
  @inlinable
  public var isMacroExpansionDeclSyntax: Bool {
    self.is(MacroExpansionDeclSyntax.self)
  }

  /// Returns `self` as `MacroExpansionExprSyntax`, when possible.
  @inlinable
  public var asMacroExpansionExprSyntax: MacroExpansionExprSyntax? {
    self.as(MacroExpansionExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MacroExpansionExprSyntax`.
  @inlinable
  public var isMacroExpansionExprSyntax: Bool {
    self.is(MacroExpansionExprSyntax.self)
  }

  /// Returns `self` as `MatchingPatternConditionSyntax`, when possible.
  @inlinable
  public var asMatchingPatternConditionSyntax: MatchingPatternConditionSyntax? {
    self.as(MatchingPatternConditionSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MatchingPatternConditionSyntax`.
  @inlinable
  public var isMatchingPatternConditionSyntax: Bool {
    self.is(MatchingPatternConditionSyntax.self)
  }

  /// Returns `self` as `MemberAccessExprSyntax`, when possible.
  @inlinable
  public var asMemberAccessExprSyntax: MemberAccessExprSyntax? {
    self.as(MemberAccessExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MemberAccessExprSyntax`.
  @inlinable
  public var isMemberAccessExprSyntax: Bool {
    self.is(MemberAccessExprSyntax.self)
  }

  /// Returns `self` as `MemberBlockItemListSyntax`, when possible.
  @inlinable
  public var asMemberBlockItemListSyntax: MemberBlockItemListSyntax? {
    self.as(MemberBlockItemListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MemberBlockItemListSyntax`.
  @inlinable
  public var isMemberBlockItemListSyntax: Bool {
    self.is(MemberBlockItemListSyntax.self)
  }

  /// Returns `self` as `MemberBlockItemSyntax`, when possible.
  @inlinable
  public var asMemberBlockItemSyntax: MemberBlockItemSyntax? {
    self.as(MemberBlockItemSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MemberBlockItemSyntax`.
  @inlinable
  public var isMemberBlockItemSyntax: Bool {
    self.is(MemberBlockItemSyntax.self)
  }

  /// Returns `self` as `MemberBlockSyntax`, when possible.
  @inlinable
  public var asMemberBlockSyntax: MemberBlockSyntax? {
    self.as(MemberBlockSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MemberBlockSyntax`.
  @inlinable
  public var isMemberBlockSyntax: Bool {
    self.is(MemberBlockSyntax.self)
  }

  /// Returns `self` as `MemberTypeSyntax`, when possible.
  @inlinable
  public var asMemberTypeSyntax: MemberTypeSyntax? {
    self.as(MemberTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MemberTypeSyntax`.
  @inlinable
  public var isMemberTypeSyntax: Bool {
    self.is(MemberTypeSyntax.self)
  }

  /// Returns `self` as `MetatypeTypeSyntax`, when possible.
  @inlinable
  public var asMetatypeTypeSyntax: MetatypeTypeSyntax? {
    self.as(MetatypeTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MetatypeTypeSyntax`.
  @inlinable
  public var isMetatypeTypeSyntax: Bool {
    self.is(MetatypeTypeSyntax.self)
  }

  /// Returns `self` as `MissingDeclSyntax`, when possible.
  @inlinable
  public var asMissingDeclSyntax: MissingDeclSyntax? {
    self.as(MissingDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MissingDeclSyntax`.
  @inlinable
  public var isMissingDeclSyntax: Bool {
    self.is(MissingDeclSyntax.self)
  }

  /// Returns `self` as `MissingExprSyntax`, when possible.
  @inlinable
  public var asMissingExprSyntax: MissingExprSyntax? {
    self.as(MissingExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MissingExprSyntax`.
  @inlinable
  public var isMissingExprSyntax: Bool {
    self.is(MissingExprSyntax.self)
  }

  /// Returns `self` as `MissingPatternSyntax`, when possible.
  @inlinable
  public var asMissingPatternSyntax: MissingPatternSyntax? {
    self.as(MissingPatternSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MissingPatternSyntax`.
  @inlinable
  public var isMissingPatternSyntax: Bool {
    self.is(MissingPatternSyntax.self)
  }

  /// Returns `self` as `MissingStmtSyntax`, when possible.
  @inlinable
  public var asMissingStmtSyntax: MissingStmtSyntax? {
    self.as(MissingStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MissingStmtSyntax`.
  @inlinable
  public var isMissingStmtSyntax: Bool {
    self.is(MissingStmtSyntax.self)
  }

  /// Returns `self` as `MissingSyntax`, when possible.
  @inlinable
  public var asMissingSyntax: MissingSyntax? {
    self.as(MissingSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MissingSyntax`.
  @inlinable
  public var isMissingSyntax: Bool {
    self.is(MissingSyntax.self)
  }

  /// Returns `self` as `MissingTypeSyntax`, when possible.
  @inlinable
  public var asMissingTypeSyntax: MissingTypeSyntax? {
    self.as(MissingTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MissingTypeSyntax`.
  @inlinable
  public var isMissingTypeSyntax: Bool {
    self.is(MissingTypeSyntax.self)
  }

  /// Returns `self` as `MultipleTrailingClosureElementListSyntax`, when possible.
  @inlinable
  public var asMultipleTrailingClosureElementListSyntax: MultipleTrailingClosureElementListSyntax? {
    self.as(MultipleTrailingClosureElementListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MultipleTrailingClosureElementListSyntax`.
  @inlinable
  public var isMultipleTrailingClosureElementListSyntax: Bool {
    self.is(MultipleTrailingClosureElementListSyntax.self)
  }

  /// Returns `self` as `MultipleTrailingClosureElementSyntax`, when possible.
  @inlinable
  public var asMultipleTrailingClosureElementSyntax: MultipleTrailingClosureElementSyntax? {
    self.as(MultipleTrailingClosureElementSyntax.self)
  }

  /// `true` iff `self` can be viewed as `MultipleTrailingClosureElementSyntax`.
  @inlinable
  public var isMultipleTrailingClosureElementSyntax: Bool {
    self.is(MultipleTrailingClosureElementSyntax.self)
  }

  /// Returns `self` as `NamedOpaqueReturnTypeSyntax`, when possible.
  @inlinable
  public var asNamedOpaqueReturnTypeSyntax: NamedOpaqueReturnTypeSyntax? {
    self.as(NamedOpaqueReturnTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `NamedOpaqueReturnTypeSyntax`.
  @inlinable
  public var isNamedOpaqueReturnTypeSyntax: Bool {
    self.is(NamedOpaqueReturnTypeSyntax.self)
  }

  /// Returns `self` as `NilLiteralExprSyntax`, when possible.
  @inlinable
  public var asNilLiteralExprSyntax: NilLiteralExprSyntax? {
    self.as(NilLiteralExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `NilLiteralExprSyntax`.
  @inlinable
  public var isNilLiteralExprSyntax: Bool {
    self.is(NilLiteralExprSyntax.self)
  }

  /// Returns `self` as `NonisolatedSpecifierArgumentSyntax`, when possible.
  @inlinable
  public var asNonisolatedSpecifierArgumentSyntax: NonisolatedSpecifierArgumentSyntax? {
    self.as(NonisolatedSpecifierArgumentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `NonisolatedSpecifierArgumentSyntax`.
  @inlinable
  public var isNonisolatedSpecifierArgumentSyntax: Bool {
    self.is(NonisolatedSpecifierArgumentSyntax.self)
  }

  /// Returns `self` as `NonisolatedTypeSpecifierSyntax`, when possible.
  @inlinable
  public var asNonisolatedTypeSpecifierSyntax: NonisolatedTypeSpecifierSyntax? {
    self.as(NonisolatedTypeSpecifierSyntax.self)
  }

  /// `true` iff `self` can be viewed as `NonisolatedTypeSpecifierSyntax`.
  @inlinable
  public var isNonisolatedTypeSpecifierSyntax: Bool {
    self.is(NonisolatedTypeSpecifierSyntax.self)
  }

  /// Returns `self` as `ObjCSelectorPieceListSyntax`, when possible.
  @inlinable
  public var asObjCSelectorPieceListSyntax: ObjCSelectorPieceListSyntax? {
    self.as(ObjCSelectorPieceListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ObjCSelectorPieceListSyntax`.
  @inlinable
  public var isObjCSelectorPieceListSyntax: Bool {
    self.is(ObjCSelectorPieceListSyntax.self)
  }

  /// Returns `self` as `ObjCSelectorPieceSyntax`, when possible.
  @inlinable
  public var asObjCSelectorPieceSyntax: ObjCSelectorPieceSyntax? {
    self.as(ObjCSelectorPieceSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ObjCSelectorPieceSyntax`.
  @inlinable
  public var isObjCSelectorPieceSyntax: Bool {
    self.is(ObjCSelectorPieceSyntax.self)
  }

  /// Returns `self` as `OperatorDeclSyntax`, when possible.
  @inlinable
  public var asOperatorDeclSyntax: OperatorDeclSyntax? {
    self.as(OperatorDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `OperatorDeclSyntax`.
  @inlinable
  public var isOperatorDeclSyntax: Bool {
    self.is(OperatorDeclSyntax.self)
  }

  /// Returns `self` as `OperatorPrecedenceAndTypesSyntax`, when possible.
  @inlinable
  public var asOperatorPrecedenceAndTypesSyntax: OperatorPrecedenceAndTypesSyntax? {
    self.as(OperatorPrecedenceAndTypesSyntax.self)
  }

  /// `true` iff `self` can be viewed as `OperatorPrecedenceAndTypesSyntax`.
  @inlinable
  public var isOperatorPrecedenceAndTypesSyntax: Bool {
    self.is(OperatorPrecedenceAndTypesSyntax.self)
  }

  /// Returns `self` as `OptionalBindingConditionSyntax`, when possible.
  @inlinable
  public var asOptionalBindingConditionSyntax: OptionalBindingConditionSyntax? {
    self.as(OptionalBindingConditionSyntax.self)
  }

  /// `true` iff `self` can be viewed as `OptionalBindingConditionSyntax`.
  @inlinable
  public var isOptionalBindingConditionSyntax: Bool {
    self.is(OptionalBindingConditionSyntax.self)
  }

  /// Returns `self` as `OptionalChainingExprSyntax`, when possible.
  @inlinable
  public var asOptionalChainingExprSyntax: OptionalChainingExprSyntax? {
    self.as(OptionalChainingExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `OptionalChainingExprSyntax`.
  @inlinable
  public var isOptionalChainingExprSyntax: Bool {
    self.is(OptionalChainingExprSyntax.self)
  }

  /// Returns `self` as `OptionalTypeSyntax`, when possible.
  @inlinable
  public var asOptionalTypeSyntax: OptionalTypeSyntax? {
    self.as(OptionalTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `OptionalTypeSyntax`.
  @inlinable
  public var isOptionalTypeSyntax: Bool {
    self.is(OptionalTypeSyntax.self)
  }

  /// Returns `self` as `OriginallyDefinedInAttributeArgumentsSyntax`, when possible.
  @inlinable
  public var asOriginallyDefinedInAttributeArgumentsSyntax: OriginallyDefinedInAttributeArgumentsSyntax? {
    self.as(OriginallyDefinedInAttributeArgumentsSyntax.self)
  }

  /// `true` iff `self` can be viewed as `OriginallyDefinedInAttributeArgumentsSyntax`.
  @inlinable
  public var isOriginallyDefinedInAttributeArgumentsSyntax: Bool {
    self.is(OriginallyDefinedInAttributeArgumentsSyntax.self)
  }

  /// Returns `self` as `PackElementExprSyntax`, when possible.
  @inlinable
  public var asPackElementExprSyntax: PackElementExprSyntax? {
    self.as(PackElementExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PackElementExprSyntax`.
  @inlinable
  public var isPackElementExprSyntax: Bool {
    self.is(PackElementExprSyntax.self)
  }

  /// Returns `self` as `PackElementTypeSyntax`, when possible.
  @inlinable
  public var asPackElementTypeSyntax: PackElementTypeSyntax? {
    self.as(PackElementTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PackElementTypeSyntax`.
  @inlinable
  public var isPackElementTypeSyntax: Bool {
    self.is(PackElementTypeSyntax.self)
  }

  /// Returns `self` as `PackExpansionExprSyntax`, when possible.
  @inlinable
  public var asPackExpansionExprSyntax: PackExpansionExprSyntax? {
    self.as(PackExpansionExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PackExpansionExprSyntax`.
  @inlinable
  public var isPackExpansionExprSyntax: Bool {
    self.is(PackExpansionExprSyntax.self)
  }

  /// Returns `self` as `PackExpansionTypeSyntax`, when possible.
  @inlinable
  public var asPackExpansionTypeSyntax: PackExpansionTypeSyntax? {
    self.as(PackExpansionTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PackExpansionTypeSyntax`.
  @inlinable
  public var isPackExpansionTypeSyntax: Bool {
    self.is(PackExpansionTypeSyntax.self)
  }

  /// Returns `self` as `PatternBindingListSyntax`, when possible.
  @inlinable
  public var asPatternBindingListSyntax: PatternBindingListSyntax? {
    self.as(PatternBindingListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PatternBindingListSyntax`.
  @inlinable
  public var isPatternBindingListSyntax: Bool {
    self.is(PatternBindingListSyntax.self)
  }

  /// Returns `self` as `PatternBindingSyntax`, when possible.
  @inlinable
  public var asPatternBindingSyntax: PatternBindingSyntax? {
    self.as(PatternBindingSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PatternBindingSyntax`.
  @inlinable
  public var isPatternBindingSyntax: Bool {
    self.is(PatternBindingSyntax.self)
  }

  /// Returns `self` as `PatternExprSyntax`, when possible.
  @inlinable
  public var asPatternExprSyntax: PatternExprSyntax? {
    self.as(PatternExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PatternExprSyntax`.
  @inlinable
  public var isPatternExprSyntax: Bool {
    self.is(PatternExprSyntax.self)
  }

  /// Returns `self` as `PatternSyntax`, when possible.
  @inlinable
  public var asPatternSyntax: PatternSyntax? {
    self.as(PatternSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PatternSyntax`.
  @inlinable
  public var isPatternSyntax: Bool {
    self.is(PatternSyntax.self)
  }

  /// Returns `self` as `PlatformVersionItemListSyntax`, when possible.
  @inlinable
  public var asPlatformVersionItemListSyntax: PlatformVersionItemListSyntax? {
    self.as(PlatformVersionItemListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PlatformVersionItemListSyntax`.
  @inlinable
  public var isPlatformVersionItemListSyntax: Bool {
    self.is(PlatformVersionItemListSyntax.self)
  }

  /// Returns `self` as `PlatformVersionItemSyntax`, when possible.
  @inlinable
  public var asPlatformVersionItemSyntax: PlatformVersionItemSyntax? {
    self.as(PlatformVersionItemSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PlatformVersionItemSyntax`.
  @inlinable
  public var isPlatformVersionItemSyntax: Bool {
    self.is(PlatformVersionItemSyntax.self)
  }

  /// Returns `self` as `PlatformVersionSyntax`, when possible.
  @inlinable
  public var asPlatformVersionSyntax: PlatformVersionSyntax? {
    self.as(PlatformVersionSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PlatformVersionSyntax`.
  @inlinable
  public var isPlatformVersionSyntax: Bool {
    self.is(PlatformVersionSyntax.self)
  }

  /// Returns `self` as `PostfixIfConfigExprSyntax`, when possible.
  @inlinable
  public var asPostfixIfConfigExprSyntax: PostfixIfConfigExprSyntax? {
    self.as(PostfixIfConfigExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PostfixIfConfigExprSyntax`.
  @inlinable
  public var isPostfixIfConfigExprSyntax: Bool {
    self.is(PostfixIfConfigExprSyntax.self)
  }

  /// Returns `self` as `PostfixOperatorExprSyntax`, when possible.
  @inlinable
  public var asPostfixOperatorExprSyntax: PostfixOperatorExprSyntax? {
    self.as(PostfixOperatorExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PostfixOperatorExprSyntax`.
  @inlinable
  public var isPostfixOperatorExprSyntax: Bool {
    self.is(PostfixOperatorExprSyntax.self)
  }

  /// Returns `self` as `PoundSourceLocationArgumentsSyntax`, when possible.
  @inlinable
  public var asPoundSourceLocationArgumentsSyntax: PoundSourceLocationArgumentsSyntax? {
    self.as(PoundSourceLocationArgumentsSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PoundSourceLocationArgumentsSyntax`.
  @inlinable
  public var isPoundSourceLocationArgumentsSyntax: Bool {
    self.is(PoundSourceLocationArgumentsSyntax.self)
  }

  /// Returns `self` as `PoundSourceLocationSyntax`, when possible.
  @inlinable
  public var asPoundSourceLocationSyntax: PoundSourceLocationSyntax? {
    self.as(PoundSourceLocationSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PoundSourceLocationSyntax`.
  @inlinable
  public var isPoundSourceLocationSyntax: Bool {
    self.is(PoundSourceLocationSyntax.self)
  }

  /// Returns `self` as `PrecedenceGroupAssignmentSyntax`, when possible.
  @inlinable
  public var asPrecedenceGroupAssignmentSyntax: PrecedenceGroupAssignmentSyntax? {
    self.as(PrecedenceGroupAssignmentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PrecedenceGroupAssignmentSyntax`.
  @inlinable
  public var isPrecedenceGroupAssignmentSyntax: Bool {
    self.is(PrecedenceGroupAssignmentSyntax.self)
  }

  /// Returns `self` as `PrecedenceGroupAssociativitySyntax`, when possible.
  @inlinable
  public var asPrecedenceGroupAssociativitySyntax: PrecedenceGroupAssociativitySyntax? {
    self.as(PrecedenceGroupAssociativitySyntax.self)
  }

  /// `true` iff `self` can be viewed as `PrecedenceGroupAssociativitySyntax`.
  @inlinable
  public var isPrecedenceGroupAssociativitySyntax: Bool {
    self.is(PrecedenceGroupAssociativitySyntax.self)
  }

  /// Returns `self` as `PrecedenceGroupAttributeListSyntax`, when possible.
  @inlinable
  public var asPrecedenceGroupAttributeListSyntax: PrecedenceGroupAttributeListSyntax? {
    self.as(PrecedenceGroupAttributeListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PrecedenceGroupAttributeListSyntax`.
  @inlinable
  public var isPrecedenceGroupAttributeListSyntax: Bool {
    self.is(PrecedenceGroupAttributeListSyntax.self)
  }

  /// Returns `self` as `PrecedenceGroupDeclSyntax`, when possible.
  @inlinable
  public var asPrecedenceGroupDeclSyntax: PrecedenceGroupDeclSyntax? {
    self.as(PrecedenceGroupDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PrecedenceGroupDeclSyntax`.
  @inlinable
  public var isPrecedenceGroupDeclSyntax: Bool {
    self.is(PrecedenceGroupDeclSyntax.self)
  }

  /// Returns `self` as `PrecedenceGroupNameListSyntax`, when possible.
  @inlinable
  public var asPrecedenceGroupNameListSyntax: PrecedenceGroupNameListSyntax? {
    self.as(PrecedenceGroupNameListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PrecedenceGroupNameListSyntax`.
  @inlinable
  public var isPrecedenceGroupNameListSyntax: Bool {
    self.is(PrecedenceGroupNameListSyntax.self)
  }

  /// Returns `self` as `PrecedenceGroupNameSyntax`, when possible.
  @inlinable
  public var asPrecedenceGroupNameSyntax: PrecedenceGroupNameSyntax? {
    self.as(PrecedenceGroupNameSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PrecedenceGroupNameSyntax`.
  @inlinable
  public var isPrecedenceGroupNameSyntax: Bool {
    self.is(PrecedenceGroupNameSyntax.self)
  }

  /// Returns `self` as `PrecedenceGroupRelationSyntax`, when possible.
  @inlinable
  public var asPrecedenceGroupRelationSyntax: PrecedenceGroupRelationSyntax? {
    self.as(PrecedenceGroupRelationSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PrecedenceGroupRelationSyntax`.
  @inlinable
  public var isPrecedenceGroupRelationSyntax: Bool {
    self.is(PrecedenceGroupRelationSyntax.self)
  }

  /// Returns `self` as `PrefixOperatorExprSyntax`, when possible.
  @inlinable
  public var asPrefixOperatorExprSyntax: PrefixOperatorExprSyntax? {
    self.as(PrefixOperatorExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PrefixOperatorExprSyntax`.
  @inlinable
  public var isPrefixOperatorExprSyntax: Bool {
    self.is(PrefixOperatorExprSyntax.self)
  }

  /// Returns `self` as `PrimaryAssociatedTypeClauseSyntax`, when possible.
  @inlinable
  public var asPrimaryAssociatedTypeClauseSyntax: PrimaryAssociatedTypeClauseSyntax? {
    self.as(PrimaryAssociatedTypeClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PrimaryAssociatedTypeClauseSyntax`.
  @inlinable
  public var isPrimaryAssociatedTypeClauseSyntax: Bool {
    self.is(PrimaryAssociatedTypeClauseSyntax.self)
  }

  /// Returns `self` as `PrimaryAssociatedTypeListSyntax`, when possible.
  @inlinable
  public var asPrimaryAssociatedTypeListSyntax: PrimaryAssociatedTypeListSyntax? {
    self.as(PrimaryAssociatedTypeListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PrimaryAssociatedTypeListSyntax`.
  @inlinable
  public var isPrimaryAssociatedTypeListSyntax: Bool {
    self.is(PrimaryAssociatedTypeListSyntax.self)
  }

  /// Returns `self` as `PrimaryAssociatedTypeSyntax`, when possible.
  @inlinable
  public var asPrimaryAssociatedTypeSyntax: PrimaryAssociatedTypeSyntax? {
    self.as(PrimaryAssociatedTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `PrimaryAssociatedTypeSyntax`.
  @inlinable
  public var isPrimaryAssociatedTypeSyntax: Bool {
    self.is(PrimaryAssociatedTypeSyntax.self)
  }

  /// Returns `self` as `ProtocolDeclSyntax`, when possible.
  @inlinable
  public var asProtocolDeclSyntax: ProtocolDeclSyntax? {
    self.as(ProtocolDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ProtocolDeclSyntax`.
  @inlinable
  public var isProtocolDeclSyntax: Bool {
    self.is(ProtocolDeclSyntax.self)
  }

  /// Returns `self` as `RegexLiteralExprSyntax`, when possible.
  @inlinable
  public var asRegexLiteralExprSyntax: RegexLiteralExprSyntax? {
    self.as(RegexLiteralExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `RegexLiteralExprSyntax`.
  @inlinable
  public var isRegexLiteralExprSyntax: Bool {
    self.is(RegexLiteralExprSyntax.self)
  }

  /// Returns `self` as `RepeatStmtSyntax`, when possible.
  @inlinable
  public var asRepeatStmtSyntax: RepeatStmtSyntax? {
    self.as(RepeatStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `RepeatStmtSyntax`.
  @inlinable
  public var isRepeatStmtSyntax: Bool {
    self.is(RepeatStmtSyntax.self)
  }

  /// Returns `self` as `ReturnClauseSyntax`, when possible.
  @inlinable
  public var asReturnClauseSyntax: ReturnClauseSyntax? {
    self.as(ReturnClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ReturnClauseSyntax`.
  @inlinable
  public var isReturnClauseSyntax: Bool {
    self.is(ReturnClauseSyntax.self)
  }

  /// Returns `self` as `ReturnStmtSyntax`, when possible.
  @inlinable
  public var asReturnStmtSyntax: ReturnStmtSyntax? {
    self.as(ReturnStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ReturnStmtSyntax`.
  @inlinable
  public var isReturnStmtSyntax: Bool {
    self.is(ReturnStmtSyntax.self)
  }

  /// Returns `self` as `SameTypeRequirementSyntax`, when possible.
  @inlinable
  public var asSameTypeRequirementSyntax: SameTypeRequirementSyntax? {
    self.as(SameTypeRequirementSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SameTypeRequirementSyntax`.
  @inlinable
  public var isSameTypeRequirementSyntax: Bool {
    self.is(SameTypeRequirementSyntax.self)
  }

  /// Returns `self` as `SequenceExprSyntax`, when possible.
  @inlinable
  public var asSequenceExprSyntax: SequenceExprSyntax? {
    self.as(SequenceExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SequenceExprSyntax`.
  @inlinable
  public var isSequenceExprSyntax: Bool {
    self.is(SequenceExprSyntax.self)
  }

  /// Returns `self` as `SimpleStringLiteralExprSyntax`, when possible.
  @inlinable
  public var asSimpleStringLiteralExprSyntax: SimpleStringLiteralExprSyntax? {
    self.as(SimpleStringLiteralExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SimpleStringLiteralExprSyntax`.
  @inlinable
  public var isSimpleStringLiteralExprSyntax: Bool {
    self.is(SimpleStringLiteralExprSyntax.self)
  }

  /// Returns `self` as `SimpleStringLiteralSegmentListSyntax`, when possible.
  @inlinable
  public var asSimpleStringLiteralSegmentListSyntax: SimpleStringLiteralSegmentListSyntax? {
    self.as(SimpleStringLiteralSegmentListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SimpleStringLiteralSegmentListSyntax`.
  @inlinable
  public var isSimpleStringLiteralSegmentListSyntax: Bool {
    self.is(SimpleStringLiteralSegmentListSyntax.self)
  }

  /// Returns `self` as `SimpleTypeSpecifierSyntax`, when possible.
  @inlinable
  public var asSimpleTypeSpecifierSyntax: SimpleTypeSpecifierSyntax? {
    self.as(SimpleTypeSpecifierSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SimpleTypeSpecifierSyntax`.
  @inlinable
  public var isSimpleTypeSpecifierSyntax: Bool {
    self.is(SimpleTypeSpecifierSyntax.self)
  }

  /// Returns `self` as `SomeOrAnyTypeSyntax`, when possible.
  @inlinable
  public var asSomeOrAnyTypeSyntax: SomeOrAnyTypeSyntax? {
    self.as(SomeOrAnyTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SomeOrAnyTypeSyntax`.
  @inlinable
  public var isSomeOrAnyTypeSyntax: Bool {
    self.is(SomeOrAnyTypeSyntax.self)
  }

  /// Returns `self` as `SourceFileSyntax`, when possible.
  @inlinable
  public var asSourceFileSyntax: SourceFileSyntax? {
    self.as(SourceFileSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SourceFileSyntax`.
  @inlinable
  public var isSourceFileSyntax: Bool {
    self.is(SourceFileSyntax.self)
  }

  /// Returns `self` as `SpecializeAttributeArgumentListSyntax`, when possible.
  @inlinable
  public var asSpecializeAttributeArgumentListSyntax: SpecializeAttributeArgumentListSyntax? {
    self.as(SpecializeAttributeArgumentListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SpecializeAttributeArgumentListSyntax`.
  @inlinable
  public var isSpecializeAttributeArgumentListSyntax: Bool {
    self.is(SpecializeAttributeArgumentListSyntax.self)
  }

  /// Returns `self` as `SpecializeAvailabilityArgumentSyntax`, when possible.
  @inlinable
  public var asSpecializeAvailabilityArgumentSyntax: SpecializeAvailabilityArgumentSyntax? {
    self.as(SpecializeAvailabilityArgumentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SpecializeAvailabilityArgumentSyntax`.
  @inlinable
  public var isSpecializeAvailabilityArgumentSyntax: Bool {
    self.is(SpecializeAvailabilityArgumentSyntax.self)
  }

  /// Returns `self` as `SpecializeTargetFunctionArgumentSyntax`, when possible.
  @inlinable
  public var asSpecializeTargetFunctionArgumentSyntax: SpecializeTargetFunctionArgumentSyntax? {
    self.as(SpecializeTargetFunctionArgumentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SpecializeTargetFunctionArgumentSyntax`.
  @inlinable
  public var isSpecializeTargetFunctionArgumentSyntax: Bool {
    self.is(SpecializeTargetFunctionArgumentSyntax.self)
  }

  /// Returns `self` as `StmtSyntax`, when possible.
  @inlinable
  public var asStmtSyntax: StmtSyntax? {
    self.as(StmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `StmtSyntax`.
  @inlinable
  public var isStmtSyntax: Bool {
    self.is(StmtSyntax.self)
  }

  /// Returns `self` as `StringLiteralExprSyntax`, when possible.
  @inlinable
  public var asStringLiteralExprSyntax: StringLiteralExprSyntax? {
    self.as(StringLiteralExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `StringLiteralExprSyntax`.
  @inlinable
  public var isStringLiteralExprSyntax: Bool {
    self.is(StringLiteralExprSyntax.self)
  }

  /// Returns `self` as `StringLiteralSegmentListSyntax`, when possible.
  @inlinable
  public var asStringLiteralSegmentListSyntax: StringLiteralSegmentListSyntax? {
    self.as(StringLiteralSegmentListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `StringLiteralSegmentListSyntax`.
  @inlinable
  public var isStringLiteralSegmentListSyntax: Bool {
    self.is(StringLiteralSegmentListSyntax.self)
  }

  /// Returns `self` as `StringSegmentSyntax`, when possible.
  @inlinable
  public var asStringSegmentSyntax: StringSegmentSyntax? {
    self.as(StringSegmentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `StringSegmentSyntax`.
  @inlinable
  public var isStringSegmentSyntax: Bool {
    self.is(StringSegmentSyntax.self)
  }

  /// Returns `self` as `StructDeclSyntax`, when possible.
  @inlinable
  public var asStructDeclSyntax: StructDeclSyntax? {
    self.as(StructDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `StructDeclSyntax`.
  @inlinable
  public var isStructDeclSyntax: Bool {
    self.is(StructDeclSyntax.self)
  }

  /// Returns `self` as `SubscriptCallExprSyntax`, when possible.
  @inlinable
  public var asSubscriptCallExprSyntax: SubscriptCallExprSyntax? {
    self.as(SubscriptCallExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SubscriptCallExprSyntax`.
  @inlinable
  public var isSubscriptCallExprSyntax: Bool {
    self.is(SubscriptCallExprSyntax.self)
  }

  /// Returns `self` as `SubscriptDeclSyntax`, when possible.
  @inlinable
  public var asSubscriptDeclSyntax: SubscriptDeclSyntax? {
    self.as(SubscriptDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SubscriptDeclSyntax`.
  @inlinable
  public var isSubscriptDeclSyntax: Bool {
    self.is(SubscriptDeclSyntax.self)
  }

  /// Returns `self` as `SuperExprSyntax`, when possible.
  @inlinable
  public var asSuperExprSyntax: SuperExprSyntax? {
    self.as(SuperExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SuperExprSyntax`.
  @inlinable
  public var isSuperExprSyntax: Bool {
    self.is(SuperExprSyntax.self)
  }

  /// Returns `self` as `SuppressedTypeSyntax`, when possible.
  @inlinable
  public var asSuppressedTypeSyntax: SuppressedTypeSyntax? {
    self.as(SuppressedTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SuppressedTypeSyntax`.
  @inlinable
  public var isSuppressedTypeSyntax: Bool {
    self.is(SuppressedTypeSyntax.self)
  }

  /// Returns `self` as `SwitchCaseItemListSyntax`, when possible.
  @inlinable
  public var asSwitchCaseItemListSyntax: SwitchCaseItemListSyntax? {
    self.as(SwitchCaseItemListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SwitchCaseItemListSyntax`.
  @inlinable
  public var isSwitchCaseItemListSyntax: Bool {
    self.is(SwitchCaseItemListSyntax.self)
  }

  /// Returns `self` as `SwitchCaseItemSyntax`, when possible.
  @inlinable
  public var asSwitchCaseItemSyntax: SwitchCaseItemSyntax? {
    self.as(SwitchCaseItemSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SwitchCaseItemSyntax`.
  @inlinable
  public var isSwitchCaseItemSyntax: Bool {
    self.is(SwitchCaseItemSyntax.self)
  }

  /// Returns `self` as `SwitchCaseLabelSyntax`, when possible.
  @inlinable
  public var asSwitchCaseLabelSyntax: SwitchCaseLabelSyntax? {
    self.as(SwitchCaseLabelSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SwitchCaseLabelSyntax`.
  @inlinable
  public var isSwitchCaseLabelSyntax: Bool {
    self.is(SwitchCaseLabelSyntax.self)
  }

  /// Returns `self` as `SwitchCaseListSyntax`, when possible.
  @inlinable
  public var asSwitchCaseListSyntax: SwitchCaseListSyntax? {
    self.as(SwitchCaseListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SwitchCaseListSyntax`.
  @inlinable
  public var isSwitchCaseListSyntax: Bool {
    self.is(SwitchCaseListSyntax.self)
  }

  /// Returns `self` as `SwitchCaseSyntax`, when possible.
  @inlinable
  public var asSwitchCaseSyntax: SwitchCaseSyntax? {
    self.as(SwitchCaseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SwitchCaseSyntax`.
  @inlinable
  public var isSwitchCaseSyntax: Bool {
    self.is(SwitchCaseSyntax.self)
  }

  /// Returns `self` as `SwitchDefaultLabelSyntax`, when possible.
  @inlinable
  public var asSwitchDefaultLabelSyntax: SwitchDefaultLabelSyntax? {
    self.as(SwitchDefaultLabelSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SwitchDefaultLabelSyntax`.
  @inlinable
  public var isSwitchDefaultLabelSyntax: Bool {
    self.is(SwitchDefaultLabelSyntax.self)
  }

  /// Returns `self` as `SwitchExprSyntax`, when possible.
  @inlinable
  public var asSwitchExprSyntax: SwitchExprSyntax? {
    self.as(SwitchExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `SwitchExprSyntax`.
  @inlinable
  public var isSwitchExprSyntax: Bool {
    self.is(SwitchExprSyntax.self)
  }

  /// Returns `self` as `TernaryExprSyntax`, when possible.
  @inlinable
  public var asTernaryExprSyntax: TernaryExprSyntax? {
    self.as(TernaryExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TernaryExprSyntax`.
  @inlinable
  public var isTernaryExprSyntax: Bool {
    self.is(TernaryExprSyntax.self)
  }

  /// Returns `self` as `ThrowStmtSyntax`, when possible.
  @inlinable
  public var asThrowStmtSyntax: ThrowStmtSyntax? {
    self.as(ThrowStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ThrowStmtSyntax`.
  @inlinable
  public var isThrowStmtSyntax: Bool {
    self.is(ThrowStmtSyntax.self)
  }

  /// Returns `self` as `ThrowsClauseSyntax`, when possible.
  @inlinable
  public var asThrowsClauseSyntax: ThrowsClauseSyntax? {
    self.as(ThrowsClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ThrowsClauseSyntax`.
  @inlinable
  public var isThrowsClauseSyntax: Bool {
    self.is(ThrowsClauseSyntax.self)
  }

  /// Returns `self` as `TokenSyntax`, when possible.
  @inlinable
  public var asTokenSyntax: TokenSyntax? {
    self.as(TokenSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TokenSyntax`.
  @inlinable
  public var isTokenSyntax: Bool {
    self.is(TokenSyntax.self)
  }

  /// Returns `self` as `TryExprSyntax`, when possible.
  @inlinable
  public var asTryExprSyntax: TryExprSyntax? {
    self.as(TryExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TryExprSyntax`.
  @inlinable
  public var isTryExprSyntax: Bool {
    self.is(TryExprSyntax.self)
  }

  /// Returns `self` as `TupleExprSyntax`, when possible.
  @inlinable
  public var asTupleExprSyntax: TupleExprSyntax? {
    self.as(TupleExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TupleExprSyntax`.
  @inlinable
  public var isTupleExprSyntax: Bool {
    self.is(TupleExprSyntax.self)
  }

  /// Returns `self` as `TuplePatternElementListSyntax`, when possible.
  @inlinable
  public var asTuplePatternElementListSyntax: TuplePatternElementListSyntax? {
    self.as(TuplePatternElementListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TuplePatternElementListSyntax`.
  @inlinable
  public var isTuplePatternElementListSyntax: Bool {
    self.is(TuplePatternElementListSyntax.self)
  }

  /// Returns `self` as `TuplePatternElementSyntax`, when possible.
  @inlinable
  public var asTuplePatternElementSyntax: TuplePatternElementSyntax? {
    self.as(TuplePatternElementSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TuplePatternElementSyntax`.
  @inlinable
  public var isTuplePatternElementSyntax: Bool {
    self.is(TuplePatternElementSyntax.self)
  }

  /// Returns `self` as `TuplePatternSyntax`, when possible.
  @inlinable
  public var asTuplePatternSyntax: TuplePatternSyntax? {
    self.as(TuplePatternSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TuplePatternSyntax`.
  @inlinable
  public var isTuplePatternSyntax: Bool {
    self.is(TuplePatternSyntax.self)
  }

  /// Returns `self` as `TupleTypeElementListSyntax`, when possible.
  @inlinable
  public var asTupleTypeElementListSyntax: TupleTypeElementListSyntax? {
    self.as(TupleTypeElementListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TupleTypeElementListSyntax`.
  @inlinable
  public var isTupleTypeElementListSyntax: Bool {
    self.is(TupleTypeElementListSyntax.self)
  }

  /// Returns `self` as `TupleTypeElementSyntax`, when possible.
  @inlinable
  public var asTupleTypeElementSyntax: TupleTypeElementSyntax? {
    self.as(TupleTypeElementSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TupleTypeElementSyntax`.
  @inlinable
  public var isTupleTypeElementSyntax: Bool {
    self.is(TupleTypeElementSyntax.self)
  }

  /// Returns `self` as `TupleTypeSyntax`, when possible.
  @inlinable
  public var asTupleTypeSyntax: TupleTypeSyntax? {
    self.as(TupleTypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TupleTypeSyntax`.
  @inlinable
  public var isTupleTypeSyntax: Bool {
    self.is(TupleTypeSyntax.self)
  }

  /// Returns `self` as `TypeAliasDeclSyntax`, when possible.
  @inlinable
  public var asTypeAliasDeclSyntax: TypeAliasDeclSyntax? {
    self.as(TypeAliasDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TypeAliasDeclSyntax`.
  @inlinable
  public var isTypeAliasDeclSyntax: Bool {
    self.is(TypeAliasDeclSyntax.self)
  }

  /// Returns `self` as `TypeAnnotationSyntax`, when possible.
  @inlinable
  public var asTypeAnnotationSyntax: TypeAnnotationSyntax? {
    self.as(TypeAnnotationSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TypeAnnotationSyntax`.
  @inlinable
  public var isTypeAnnotationSyntax: Bool {
    self.is(TypeAnnotationSyntax.self)
  }

  /// Returns `self` as `TypeEffectSpecifiersSyntax`, when possible.
  @inlinable
  public var asTypeEffectSpecifiersSyntax: TypeEffectSpecifiersSyntax? {
    self.as(TypeEffectSpecifiersSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TypeEffectSpecifiersSyntax`.
  @inlinable
  public var isTypeEffectSpecifiersSyntax: Bool {
    self.is(TypeEffectSpecifiersSyntax.self)
  }

  /// Returns `self` as `TypeExprSyntax`, when possible.
  @inlinable
  public var asTypeExprSyntax: TypeExprSyntax? {
    self.as(TypeExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TypeExprSyntax`.
  @inlinable
  public var isTypeExprSyntax: Bool {
    self.is(TypeExprSyntax.self)
  }

  /// Returns `self` as `TypeInitializerClauseSyntax`, when possible.
  @inlinable
  public var asTypeInitializerClauseSyntax: TypeInitializerClauseSyntax? {
    self.as(TypeInitializerClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TypeInitializerClauseSyntax`.
  @inlinable
  public var isTypeInitializerClauseSyntax: Bool {
    self.is(TypeInitializerClauseSyntax.self)
  }

  /// Returns `self` as `TypeSpecifierListSyntax`, when possible.
  @inlinable
  public var asTypeSpecifierListSyntax: TypeSpecifierListSyntax? {
    self.as(TypeSpecifierListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TypeSpecifierListSyntax`.
  @inlinable
  public var isTypeSpecifierListSyntax: Bool {
    self.is(TypeSpecifierListSyntax.self)
  }

  /// Returns `self` as `TypeSyntax`, when possible.
  @inlinable
  public var asTypeSyntax: TypeSyntax? {
    self.as(TypeSyntax.self)
  }

  /// `true` iff `self` can be viewed as `TypeSyntax`.
  @inlinable
  public var isTypeSyntax: Bool {
    self.is(TypeSyntax.self)
  }

  /// Returns `self` as `UnexpectedNodesSyntax`, when possible.
  @inlinable
  public var asUnexpectedNodesSyntax: UnexpectedNodesSyntax? {
    self.as(UnexpectedNodesSyntax.self)
  }

  /// `true` iff `self` can be viewed as `UnexpectedNodesSyntax`.
  @inlinable
  public var isUnexpectedNodesSyntax: Bool {
    self.is(UnexpectedNodesSyntax.self)
  }

  /// Returns `self` as `UnresolvedAsExprSyntax`, when possible.
  @inlinable
  public var asUnresolvedAsExprSyntax: UnresolvedAsExprSyntax? {
    self.as(UnresolvedAsExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `UnresolvedAsExprSyntax`.
  @inlinable
  public var isUnresolvedAsExprSyntax: Bool {
    self.is(UnresolvedAsExprSyntax.self)
  }

  /// Returns `self` as `UnresolvedIsExprSyntax`, when possible.
  @inlinable
  public var asUnresolvedIsExprSyntax: UnresolvedIsExprSyntax? {
    self.as(UnresolvedIsExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `UnresolvedIsExprSyntax`.
  @inlinable
  public var isUnresolvedIsExprSyntax: Bool {
    self.is(UnresolvedIsExprSyntax.self)
  }

  /// Returns `self` as `UnresolvedTernaryExprSyntax`, when possible.
  @inlinable
  public var asUnresolvedTernaryExprSyntax: UnresolvedTernaryExprSyntax? {
    self.as(UnresolvedTernaryExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `UnresolvedTernaryExprSyntax`.
  @inlinable
  public var isUnresolvedTernaryExprSyntax: Bool {
    self.is(UnresolvedTernaryExprSyntax.self)
  }

  /// Returns `self` as `UnsafeExprSyntax`, when possible.
  @inlinable
  public var asUnsafeExprSyntax: UnsafeExprSyntax? {
    self.as(UnsafeExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `UnsafeExprSyntax`.
  @inlinable
  public var isUnsafeExprSyntax: Bool {
    self.is(UnsafeExprSyntax.self)
  }

  /// Returns `self` as `ValueBindingPatternSyntax`, when possible.
  @inlinable
  public var asValueBindingPatternSyntax: ValueBindingPatternSyntax? {
    self.as(ValueBindingPatternSyntax.self)
  }

  /// `true` iff `self` can be viewed as `ValueBindingPatternSyntax`.
  @inlinable
  public var isValueBindingPatternSyntax: Bool {
    self.is(ValueBindingPatternSyntax.self)
  }

  /// Returns `self` as `VariableDeclSyntax`, when possible.
  @inlinable
  public var asVariableDeclSyntax: VariableDeclSyntax? {
    self.as(VariableDeclSyntax.self)
  }

  /// `true` iff `self` can be viewed as `VariableDeclSyntax`.
  @inlinable
  public var isVariableDeclSyntax: Bool {
    self.is(VariableDeclSyntax.self)
  }

  /// Returns `self` as `VersionComponentListSyntax`, when possible.
  @inlinable
  public var asVersionComponentListSyntax: VersionComponentListSyntax? {
    self.as(VersionComponentListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `VersionComponentListSyntax`.
  @inlinable
  public var isVersionComponentListSyntax: Bool {
    self.is(VersionComponentListSyntax.self)
  }

  /// Returns `self` as `VersionComponentSyntax`, when possible.
  @inlinable
  public var asVersionComponentSyntax: VersionComponentSyntax? {
    self.as(VersionComponentSyntax.self)
  }

  /// `true` iff `self` can be viewed as `VersionComponentSyntax`.
  @inlinable
  public var isVersionComponentSyntax: Bool {
    self.is(VersionComponentSyntax.self)
  }

  /// Returns `self` as `VersionTupleSyntax`, when possible.
  @inlinable
  public var asVersionTupleSyntax: VersionTupleSyntax? {
    self.as(VersionTupleSyntax.self)
  }

  /// `true` iff `self` can be viewed as `VersionTupleSyntax`.
  @inlinable
  public var isVersionTupleSyntax: Bool {
    self.is(VersionTupleSyntax.self)
  }

  /// Returns `self` as `WhereClauseSyntax`, when possible.
  @inlinable
  public var asWhereClauseSyntax: WhereClauseSyntax? {
    self.as(WhereClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `WhereClauseSyntax`.
  @inlinable
  public var isWhereClauseSyntax: Bool {
    self.is(WhereClauseSyntax.self)
  }

  /// Returns `self` as `WhileStmtSyntax`, when possible.
  @inlinable
  public var asWhileStmtSyntax: WhileStmtSyntax? {
    self.as(WhileStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `WhileStmtSyntax`.
  @inlinable
  public var isWhileStmtSyntax: Bool {
    self.is(WhileStmtSyntax.self)
  }

  /// Returns `self` as `WildcardPatternSyntax`, when possible.
  @inlinable
  public var asWildcardPatternSyntax: WildcardPatternSyntax? {
    self.as(WildcardPatternSyntax.self)
  }

  /// `true` iff `self` can be viewed as `WildcardPatternSyntax`.
  @inlinable
  public var isWildcardPatternSyntax: Bool {
    self.is(WildcardPatternSyntax.self)
  }

  /// Returns `self` as `YieldStmtSyntax`, when possible.
  @inlinable
  public var asYieldStmtSyntax: YieldStmtSyntax? {
    self.as(YieldStmtSyntax.self)
  }

  /// `true` iff `self` can be viewed as `YieldStmtSyntax`.
  @inlinable
  public var isYieldStmtSyntax: Bool {
    self.is(YieldStmtSyntax.self)
  }

  /// Returns `self` as `YieldedExpressionListSyntax`, when possible.
  @inlinable
  public var asYieldedExpressionListSyntax: YieldedExpressionListSyntax? {
    self.as(YieldedExpressionListSyntax.self)
  }

  /// `true` iff `self` can be viewed as `YieldedExpressionListSyntax`.
  @inlinable
  public var isYieldedExpressionListSyntax: Bool {
    self.is(YieldedExpressionListSyntax.self)
  }

  /// Returns `self` as `YieldedExpressionSyntax`, when possible.
  @inlinable
  public var asYieldedExpressionSyntax: YieldedExpressionSyntax? {
    self.as(YieldedExpressionSyntax.self)
  }

  /// `true` iff `self` can be viewed as `YieldedExpressionSyntax`.
  @inlinable
  public var isYieldedExpressionSyntax: Bool {
    self.is(YieldedExpressionSyntax.self)
  }

  /// Returns `self` as `YieldedExpressionsClauseSyntax`, when possible.
  @inlinable
  public var asYieldedExpressionsClauseSyntax: YieldedExpressionsClauseSyntax? {
    self.as(YieldedExpressionsClauseSyntax.self)
  }

  /// `true` iff `self` can be viewed as `YieldedExpressionsClauseSyntax`.
  @inlinable
  public var isYieldedExpressionsClauseSyntax: Bool {
    self.is(YieldedExpressionsClauseSyntax.self)
  }

  /// Returns `self` as `_CanImportExprSyntax`, when possible.
  @inlinable
  public var asCanImportExprSyntax: _CanImportExprSyntax? {
    self.as(_CanImportExprSyntax.self)
  }

  /// `true` iff `self` can be viewed as `_CanImportExprSyntax`.
  @inlinable
  public var isCanImportExprSyntax: Bool {
    self.is(_CanImportExprSyntax.self)
  }

  /// Returns `self` as `_CanImportVersionInfoSyntax`, when possible.
  @inlinable
  public var asCanImportVersionInfoSyntax: _CanImportVersionInfoSyntax? {
    self.as(_CanImportVersionInfoSyntax.self)
  }

  /// `true` iff `self` can be viewed as `_CanImportVersionInfoSyntax`.
  @inlinable
  public var isCanImportVersionInfoSyntax: Bool {
    self.is(_CanImportVersionInfoSyntax.self)
  }

}
