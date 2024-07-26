

public enum SourceCodeIdentifierTransflectionError: Error {
  case unrecognizedSourceCodeIdentifier(String)
}

public protocol TransflectableViaSourceCodeIdentifier {
  
  init(transflectingSourceCodeIdentifier sourceCodeIdentifier: String) throws
  
}
