import SwiftSyntax

extension DeclGroupSyntax {

  @inlinable
  public var visibilityLevel: VisibilityLevel? {
    modifiers
      .lazy
      .compactMap(\.visibilityLevel)
      .first
  }
  
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

