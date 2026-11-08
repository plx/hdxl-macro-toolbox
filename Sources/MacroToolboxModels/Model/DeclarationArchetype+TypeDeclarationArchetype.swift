
extension TypeDeclarationArchetype {
  
  @inlinable
  public var declarationArchetype: DeclarationArchetype {
    switch self {
    case .actor:
      .actor
    case .class:
      .class
    case .enum:
      .enum
    case .struct:
      .struct
    case .protocol:
      .protocol
    }
  }
  
}
