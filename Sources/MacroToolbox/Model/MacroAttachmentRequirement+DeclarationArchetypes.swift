
extension MacroAttachmentRequirement<TypeDeclarationArchetype> {
  
  @inlinable
  public var equivalentDeclarationArchetypeRequirement: MacroAttachmentRequirement<DeclarationArchetype> {
    switch self {
    case .unspecified:
      .unspecified
    case .exactly(let exactType):
      .exactly(exactType.declarationArchetype)
    case .mustBeOneOf(let allowedTypes):
      .mustBeOneOf(allowedTypes.setMap(\.declarationArchetype))
    case .anythingBut(let excludedTypes):
      // this is the tricky case, b/c to get the semantics we actually want
      // we need to make sure our `anythingBut` includes all the cases from
      // `DeclarationArchetype` that are *not* included in `TypeDeclarationArchetype`.
      .anythingBut(
        DeclarationArchetype
          .setOfAllCases
          .subtracting(
            TypeDeclarationArchetype
              .setOfAllCases
              .subtracting(excludedTypes)
              .lazy
              .map(\.declarationArchetype)
          )
      )
    }
  }
  
}
