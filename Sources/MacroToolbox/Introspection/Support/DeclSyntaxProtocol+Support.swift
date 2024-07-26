import SwiftSyntax
import SwiftSyntaxMacros

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
    for (value, concreteType) in repeat each associations {
      if self.is(concreteType) {
        return value
      }
    }
    
    return nil
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
    for (keyPath, concreteType) in repeat each associations {
      if let concreteValue = self.as(concreteType) {
        return concreteValue[keyPath: keyPath]
      }
    }
    
    return nil
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
    for (keyPath, concreteType) in repeat each associations {
      if let concreteValue = self.as(concreteType) {
        return concreteValue[keyPath: keyPath]
      }
    }
    
    return nil
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

