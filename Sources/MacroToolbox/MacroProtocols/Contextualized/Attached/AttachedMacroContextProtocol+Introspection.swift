import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


extension AttachedMacroContextProtocol where Declaration: DeclGroupSyntax {
  
  /// The explicitly-specified visibility level (if any).
  @inlinable
  public var explicitVisibilityLevel: VisibilityLevel? {
    declaration.visibilityLevel
  }
  
  /// The presumptive visibility level (e.g. explicit, or `internal` if not).
  @inlinable
  public var visibilityLevel: VisibilityLevel {
    explicitVisibilityLevel ?? .internal
  }
  
  /// The explicitly-specified inlinability disposition (if any).
  @inlinable
  public var inlinabilityDisposition: InlinabilityDisposition? {
    declaration.inlinabilityDisposition
  }
  
  /// Convenience to grab the typical info useful for emitting functions during a macro expansion.
  @inlinable
  public var functionOrMethodGenerationDetails: (VisibilityLevel, InlinabilityDisposition?) {
    let visibilityLevel = visibilityLevel
    
    let inlinabilityDisposition = InlinabilityDisposition.strongestAvailableFunctionOrMethodInlinability(
      declarationVisibility: visibilityLevel,
      dispositionHint: declaration.inlinabilityDisposition
    )
    
    return (visibilityLevel, inlinabilityDisposition)
  }
}

