
public enum AutomaticSourceIdentifierTransflectionError: Sendable, Error, Equatable, Hashable, Codable {
  
  public struct TypeNameWithIdentifier: Sendable, Equatable, Hashable, Codable {
    public var typeName: String
    public var sourceCodeIdentifier: String
    
    public init(typeName: String, sourceCodeIdentifier: String) {
      self.typeName = typeName
      self.sourceCodeIdentifier = sourceCodeIdentifier
    }
  }
  
  case excludedFromTransflection(TypeNameWithIdentifier)
  case unsupportedSourceCodeIdentifier(TypeNameWithIdentifier)
  
}
