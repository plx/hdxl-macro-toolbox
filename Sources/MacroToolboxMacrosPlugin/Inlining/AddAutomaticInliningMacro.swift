import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros
import MacroToolbox

package enum AddAutomaticInliningMacro { }

extension AddAutomaticInliningMacro : DiagnosticDomainAwareMacro { }

extension AddAutomaticInliningMacro : ContextualizedMemberAttributeMacro {

  public static let typeAttachmentRequirement: MacroAttachmentRequirement<TypeDeclarationArchetype> = .mustNotBe(.protocol)
  
  @inlinable
  public static func contextualizedExpansion(
    in attachmentContext: some MemberAttributeMacroContextProtocol
  ) throws -> [AttributeSyntax] {
    let typeDeclaration = try attachmentContext.requireConcreteTypeDeclaration()
    let typeLevelVisibility = typeDeclaration.explicitVisibilityLevel ?? .internal
    guard !typeLevelVisibility.isWithinPrivateTier else {
      return []
    }
    
    let memberDeclaration = try attachmentContext.requireMemberAsConcreteDeclSyntax()
    guard memberDeclaration.couldReceiveAutomaticInlinabilityAttributes else {
      return []
    }


    let memberVisibility = memberDeclaration.visibilityLevel ?? .internal
    guard !memberVisibility.isWithinPrivateTier else {
      return []
    }
    
    guard
      let inlinabilityDisposition = memberDeclaration.strongestAvailableAutomaticInlinabilityDisposition(
        visibilityLevel: memberVisibility
      )
    else {
      return []
    }
    
    return [inlinabilityDisposition.attributeSyntax]
  }


}
