import SwiftSyntax
import SwiftSyntaxMacros
import MacroToolbox

extension ConcreteDeclSyntax {
  
  @inlinable
  package var couldReceiveAutomaticInlinabilityAttributes: Bool {
    // NOTE: in SwiftSyntax, the convention for decls is:
    //
    // - if the associated kind-of declaration *can* have attributes, then its `attributes` is a non-nil `AttributeListSyntax` (e.g. "empty" means no attributes, not nil)
    // - if the associated kind-of declaration *cannot* have attributes, then it has no `attributes` at all
    //
    // ...which situation then gets reflected up into `ConcreteDeclSyntax` as:
    //
    //
    attributes?.couldReceiveAutomaticInlinabilityAttributes ?? false
  }
  
  @inlinable
  package var couldReceiveAddAutomaticInliningAttribute: Bool {
    
    guard
      let visibilityLevel,
      !visibilityLevel.isWithinPrivateTier
    else {
      return false
    }
    
    return nil != strongestAvailableAutomaticInlinabilityDisposition(visibilityLevel: visibilityLevel)
  }
  
  @inlinable
  package func strongestAvailableAutomaticInlinabilityDisposition(visibilityLevel: VisibilityLevel) -> InlinabilityDisposition? {
    switch self {
    case .accessor:
      nil
    case .actor:
      InlinabilityDisposition.strongestAvailableTypeDeclarationInlinability(
        declarationVisibility: visibilityLevel,
        dispositionHint: .usableFromInline
      )
    case .associatedtype:
      nil
    case .class:
      InlinabilityDisposition.strongestAvailableTypeDeclarationInlinability(
        declarationVisibility: visibilityLevel,
        dispositionHint: .usableFromInline
      )
    case .deinitializer:
      nil
    case .editorPlaceholder:
      nil
    case .enumCase:
      // TODO: any sense in which @usableFromInline can be applied to individual enum cases?
      nil
    case .enum:
      InlinabilityDisposition.strongestAvailableTypeDeclarationInlinability(
        declarationVisibility: visibilityLevel,
        dispositionHint: .usableFromInline
      )
    case .extension:
      nil
    case .function:
      InlinabilityDisposition.strongestAvailableFunctionOrMethodInlinability(
        declarationVisibility: visibilityLevel,
        dispositionHint: .inlinable
      )
    case .ifConfig(_):
      nil
    case .import:
      nil
    case .initializer:
      InlinabilityDisposition.strongestAvailableFunctionOrMethodInlinability(
        declarationVisibility: visibilityLevel,
        dispositionHint: .inlinable
      )
    case .macro:
      nil
    case .macroExpansion:
      nil
    case .missing:
      nil
    case .operator:
      nil
    case .poundSourceLocation:
      nil
    case .precedenceGroup:
      nil
    case .protocol:
      // *protocols* can be @usableFromInline,
      // *but* protocols *cannot* be members of types!
      nil
    case .struct:
      InlinabilityDisposition.strongestAvailableTypeDeclarationInlinability(
        declarationVisibility: visibilityLevel,
        dispositionHint: .usableFromInline
      )
    case .subscript:
      InlinabilityDisposition.strongestAvailableFunctionOrMethodInlinability(
        declarationVisibility: visibilityLevel,
        dispositionHint: .inlinable
      )
    case .typealias:
      InlinabilityDisposition.strongestAvailableTypeDeclarationInlinability(
        declarationVisibility: visibilityLevel,
        dispositionHint: .usableFromInline
      )
    case .variable:
      InlinabilityDisposition.strongestAvailableStoredPropertyInlinability(
        declarationVisibility: visibilityLevel,
        dispositionHint: .usableFromInline
      )
    }
  }
}
