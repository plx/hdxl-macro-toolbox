
public enum SpecializationStrategy {
  case full
  case partial
  
}

public struct ExportedSpecializationDirective {
  
  public var specializationStrategy: SpecializationStrategy
  
}
