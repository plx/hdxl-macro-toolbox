import SwiftSyntax
import SwiftSyntaxMacros

@inlinable
func _updateConcreteTypeMappingResult<Declaration, R, T>(
  _ result: inout R?,
  foundMatch: inout Bool,
  declaration: Declaration,
  association: (R, T.Type)
)
where
  Declaration: DeclSyntaxProtocol,
  T: DeclSyntaxProtocol
{
  guard !foundMatch else {
    return
  }

  let (value, concreteType) = association
  guard declaration.is(concreteType) else {
    return
  }

  foundMatch = true
  result = value
}

@inlinable
func _updateHomogeneousValueResult<Declaration, R, T>(
  _ result: inout R?,
  foundMatch: inout Bool,
  declaration: Declaration,
  association: (KeyPath<T, R>, T.Type)
)
where
  Declaration: DeclSyntaxProtocol,
  T: DeclSyntaxProtocol
{
  guard !foundMatch else {
    return
  }

  let (keyPath, concreteType) = association
  guard let concreteValue = declaration.as(concreteType) else {
    return
  }

  foundMatch = true
  result = concreteValue[keyPath: keyPath]
}

@inlinable
func _updateOptionalHomogeneousValueResult<Declaration, R, T>(
  _ result: inout R?,
  foundMatch: inout Bool,
  declaration: Declaration,
  association: (KeyPath<T, R?>, T.Type)
)
where
  Declaration: DeclSyntaxProtocol,
  T: DeclSyntaxProtocol
{
  guard !foundMatch else {
    return
  }

  let (keyPath, concreteType) = association
  guard let concreteValue = declaration.as(concreteType) else {
    return
  }

  foundMatch = true
  result = concreteValue[keyPath: keyPath]
}

extension DeclSyntaxProtocol {

  /// Maps `self` to the supplied value that's associated-with `self`'s type.
  ///
  /// - note:
  ///
  /// This exists to declaratively select a value based on the type of `self`.
  ///
  /// For example, here is the source to ``typeDeclarationArchetype``:
  ///
  /// ```swift
  /// @inlinable
  /// public var typeDeclarationArchetype: TypeDeclarationArchetype? {
  ///   applyConcreteTypeMapping(
  ///     associations: (
  ///       (.actor, ActorDeclSyntax.self),
  ///       (.class, ClassDeclSyntax.self),
  ///       (.enum, EnumDeclSyntax.self),
  ///       (.struct, StructDeclSyntax.self),
  ///       (.protocol, ProtocolDeclSyntax.self)
  ///     )
  ///   )
  /// }
  /// ```
  ///
  /// ...wherein we map `self` to the appropriate ``TypeDeclarationArchetype`` value
  /// depending on `self`'s concrete type.
  ///
  /// - seealso: ``declarationArchetype``, for a concrete application of this method.
  /// - seealso: ``typeDeclarationArchetype``, for a concrete application of this method.
  @inlinable
  public func applyConcreteTypeMapping<R, each T: DeclSyntaxProtocol>(
    associations: (repeat (R, (each T).Type))
  ) -> R? {
    var result: R?
    var foundMatch = false
    _ = (
      repeat _updateConcreteTypeMappingResult(
        &result,
        foundMatch: &foundMatch,
        declaration: self,
        association: each associations
      )
    )

    return result
  }

  /// Given a list of pairs like ("possible type, keypath-on-type"), returns the appropriate value from `self` (or `nil`, if `self` isn't any of the supplied types).
  ///
  /// - note:
  ///
  /// The motivation for this was to extract the generic parameter list from a decl that could be any of a
  /// struct, enum, class, or actor declaration.
  ///
  /// - seealso: ``extractHomogeneousValues(using:)-1sy6d`` for the optional-property-extracting variant.
  @inlinable
  public func extractHomogeneousValues<R, each T: DeclSyntaxProtocol>(
    using associations: (repeat (KeyPath<each T,R>, (each T).Type))
  ) -> R? {
    var result: R?
    var foundMatch = false
    _ = (
      repeat _updateHomogeneousValueResult(
        &result,
        foundMatch: &foundMatch,
        declaration: self,
        association: each associations
      )
    )

    return result
  }

  /// Extracts homogeneously-typed values from `self`, if possible, using the first successful type-and-keypath pair.
  ///
  /// - note:
  ///
  /// The motivation for this was to extract the generic parameter list from a decl that could be any of a
  /// struct, enum, class, or actor declaration.
  ///
  /// - seealso: ``extractHomogeneousValues(using:)`` for non-optional variant
  @inlinable
  public func extractHomogeneousValues<R, each T: DeclSyntaxProtocol>(
    using associations: (repeat (KeyPath<each T,R?>, (each T).Type))
  ) -> R? {
    var result: R?
    var foundMatch = false
    _ = (
      repeat _updateOptionalHomogeneousValueResult(
        &result,
        foundMatch: &foundMatch,
        declaration: self,
        association: each associations
      )
    )

    return result
  }

  @inlinable
  public var typeDeclarationArchetype: TypeDeclarationArchetype? {
    applyConcreteTypeMapping(
      associations: (
        (.actor, ActorDeclSyntax.self),
        (.class, ClassDeclSyntax.self),
        (.enum, EnumDeclSyntax.self),
        (.struct, StructDeclSyntax.self),
        (.protocol, ProtocolDeclSyntax.self)
      )
    )
  }

  @inlinable
  public var declarationArchetype: DeclarationArchetype? {
    applyConcreteTypeMapping(
      associations: (
        (.accessor, AccessorDeclSyntax.self),
        (.actor, ActorDeclSyntax.self),
        (.associatedtype, AssociatedTypeDeclSyntax.self),
        (.class, ClassDeclSyntax.self),
        (.deinitializer, DeinitializerDeclSyntax.self),
        (.editorPlaceholder, EditorPlaceholderDeclSyntax.self),
        (.enumCase, EnumCaseDeclSyntax.self),
        (.enum, EnumDeclSyntax.self),
        (.extension, ExtensionDeclSyntax.self),
        (.function, FunctionDeclSyntax.self),
        (.ifConfig, IfConfigDeclSyntax.self),
        (.import, ImportDeclSyntax.self),
        (.initializer, InitializerDeclSyntax.self),
        (.macro, MacroDeclSyntax.self),
        (.macroExpansion, MacroExpansionDeclSyntax.self),
        (.missing, MissingDeclSyntax.self),
        (.operator, OperatorDeclSyntax.self),
        (.poundSourceLocation, PoundSourceLocationSyntax.self),
        (.precedenceGroup, PrecedenceGroupDeclSyntax.self),
        (.protocol, ProtocolDeclSyntax.self),
        (.struct, StructDeclSyntax.self),
        (.subscript, SubscriptDeclSyntax.self),
        (.typealias, TypeAliasDeclSyntax.self),
        (.variable, VariableDeclSyntax.self)
      )
    )
  }

}
