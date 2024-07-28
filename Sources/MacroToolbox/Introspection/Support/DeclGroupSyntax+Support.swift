import SwiftSyntax

extension DeclGroupSyntax {

  /// The *explicit* visibility level, if any.
  @inlinable
  ///
  /// - seealso: ``VisibilityLevel``
  public var visibilityLevel: VisibilityLevel? {
    modifiers
      .lazy
      .compactMap(\.visibilityLevel)
      .first
  }
  
  /// The *explicit* inlinability-disposition, if any.
  ///
  /// - seealso: ``InlinabilityDisposition``
  @inlinable
  public var inlinabilityDisposition: InlinabilityDisposition? {
    attributes
      .lazy
      .compactMap(\.inlinabilityDisposition)
      .first
  }
  
  @inlinable
  public var simpleGenericParameterNames: [String]? {
    extractHomogeneousValues(
      using: (
        (\.simpleGenericParameterNames, ActorDeclSyntax.self),
        (\.simpleGenericParameterNames, EnumDeclSyntax.self),
        (\.simpleGenericParameterNames, ClassDeclSyntax.self),
        (\.simpleGenericParameterNames, StructDeclSyntax.self)
      )
    )
  }

}

