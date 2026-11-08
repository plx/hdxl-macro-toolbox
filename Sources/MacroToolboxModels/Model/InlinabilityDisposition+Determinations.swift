
extension InlinabilityDisposition {
  
  /// Determines the "strongest-available" inlinability disposition that could be applied for the provided context.
  /// - Parameters:
  ///   - attachmentSite: The general *type*  of the declaration **to-which** you want to apply an inlinability attribute.
  ///   - visibilityLevel: The visibility level of the declaration **to-which** you want to apply an inlinability attribute.
  ///   - dispositionHint: A "hint" as to the intended inlinability-disposition.
  /// - Returns: The "strongest" inlinability you could apply, or `nil` if no inlinability couple be applied.
  ///
  /// The point of this method is to handle cases like this:
  ///
  /// ```swift
  /// @usableFromInline
  /// internal class FooCoordinatorWithInlinability {
  ///    @inlinable
  ///    @SynthesizeCachedProperty
  ///    func recalculateFoo() -> Foo { /* */ }
  ///    // ^
  ///    // should be synthesizing:
  ///    // `@usableFromInline _cachedFoo: Foo?`
  ///    // `@inlinable var foo: Foo { get { ... } }`
  /// }
  ///
  /// // should *be synthesizing `@usableFromInline _cachedFoo: Foo?` and `@inlinable foo: Foo { get }`
  /// internal class FooCoordinatorWithoutInlinability {
  ///    @SynthesizeCachedProperty
  ///    func recalculateFoo() -> Foo { /* */ }
  ///    // ^
  ///    // should be synthesizing:
  ///    // `_cachedFoo: Foo?`
  ///    // `var foo: Foo { get { ... } }`
  /// }
  /// ```
  ///
  /// ...(and other similar scenarios).
  ///
  /// - seealso: ``InlinabilityDisposition.strongestAvailableFunctionOrMethodInlinability(declarationVisibility:dispositionHint:)``
  /// - seealso: ``InlinabilityDisposition.strongestAvailableTypeDeclarationInlinability(declarationVisibility:dispositionHint:)``
  /// - seealso: ``InlinabilityDisposition.strongestAvailableStoredPropertyInlinability(declarationVisibility:dispositionHint:)``
  ///
  @inlinable
  public static func strongestAvailableDisposition(
    attachmentSite: PerformanceAnnotationAttachmentSite,
    declarationVisibility: VisibilityLevel,
    dispositionHint: InlinabilityDisposition?
  ) -> InlinabilityDisposition? {
    switch attachmentSite {
    case .typeDeclaration:
      strongestAvailableTypeDeclarationInlinability(
        declarationVisibility: declarationVisibility,
        dispositionHint: dispositionHint
      )
    case .storedPropertyDeclaration:
      strongestAvailableStoredPropertyInlinability(
        declarationVisibility: declarationVisibility,
        dispositionHint: dispositionHint
      )
    case .functionOrMethodDeclaration:
      strongestAvailableFunctionOrMethodInlinability(
        declarationVisibility: declarationVisibility,
        dispositionHint: dispositionHint
      )
    }
  }
  
  /// Shorthand for the strongest-available inlinability for a function-or-method within the provided context.
  ///
  /// - seealso: ``InlinabilityDisposition.strongestAvailable(declarationType:declarationVisibility:dispositionHint:)``
  ///
  @inlinable
  public static func strongestAvailableFunctionOrMethodInlinability(
    declarationVisibility: VisibilityLevel,
    dispositionHint: InlinabilityDisposition?
  ) -> InlinabilityDisposition? {
    switch (declarationVisibility, dispositionHint) {
    case (.private, _):
      nil
    case (.fileprivate, _):
      nil
    case (.internal, .none):
      nil
    case (.internal, .inlinable):
      .inlinable
    case (.internal, .usableFromInline):
      .inlinable
    case (.package, .none):
      nil
    case (.package, .inlinable):
      .inlinable
    case (.package, .usableFromInline):
      .inlinable
    case (.public, _):
      .inlinable
    case (.open, _):
      nil
    }
  }
  
  /// Shorthand for the strongest-available inlinability for a type-declaration within the provided context.
  ///
  /// - seealso: ``InlinabilityDisposition.strongestAvailable(declarationType:declarationVisibility:dispositionHint:)``
  ///
  @inlinable
  public static func strongestAvailableTypeDeclarationInlinability(
    declarationVisibility: VisibilityLevel,
    dispositionHint: InlinabilityDisposition?
  ) -> InlinabilityDisposition? {
    switch (declarationVisibility, dispositionHint) {
    case (.private, _):
      nil
    case (.fileprivate, _):
      nil
    case (.internal, .none):
      nil
    case (.internal, .inlinable):
      .usableFromInline
    case (.internal, .usableFromInline):
      .usableFromInline
    case (.package, .none):
      nil
    case (.package, .inlinable):
      .usableFromInline
    case (.package, .usableFromInline):
      .usableFromInline
    case (.public, _):
      nil
    case (.open, _):
      nil
    }
  }
  
  /// Shorthand for the strongest-available inlinability for a stored-property-declaration within the provided context.
  ///
  /// - seealso: ``InlinabilityDisposition.strongestAvailable(declarationType:declarationVisibility:dispositionHint:)``
  ///
  @inlinable
  public static func strongestAvailableStoredPropertyInlinability(
    declarationVisibility: VisibilityLevel,
    dispositionHint: InlinabilityDisposition?
  ) -> InlinabilityDisposition? {
    switch (declarationVisibility, dispositionHint) {
    case (.private, _):
      nil
    case (.fileprivate, _):
      nil
    case (.internal, .none):
      nil
    case (.internal, .inlinable):
      .usableFromInline
    case (.internal, .usableFromInline):
      .usableFromInline
    case (.package, .none):
      nil
    case (.package, .inlinable):
      .usableFromInline
    case (.package, .usableFromInline):
      .usableFromInline
    case (.public, _):
      nil
    case (.open, _):
      nil
    }
  }
}
