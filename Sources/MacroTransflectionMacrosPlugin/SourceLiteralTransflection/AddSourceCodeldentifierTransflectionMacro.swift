import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros
import MacroToolbox

public enum AddSourceCodeIdentifierTransflectionMacro: DiagnosticDomainAwareMacro { }

extension AddSourceCodeIdentifierTransflectionMacro: ContextualizedTypeAttachedMacro {
  
  public static let typeAttachmentRequirement = MacroAttachmentRequirement<TypeDeclarationArchetype>.exactly(.enum)
  
}

extension AddSourceCodeIdentifierTransflectionMacro: ContextualizedExtensionMacro {
  
  public static func validateDeclarationDetails(
    for attachmentContext: some AttachedMacroContextProtocol
  ) throws {
    let enumDeclaration = try attachmentContext.requireDeclaration(
      as: EnumDeclSyntax.self
    )

    try attachmentContext.requireThat(
      enumDeclaration.allCasesAreSimpleWithoutPayload
    )
  }
  
  public static func contextualizedExpansion(
    in attachmentContext: some ExtensionMacroContextProtocol
  ) throws -> [ExtensionDeclSyntax] {
    let enumDeclaration = try attachmentContext.requireDeclaration(
      as: EnumDeclSyntax.self
    )
    
    let transflectableEnumerationCaseNames: [(TokenSyntax, Bool)] = try enumDeclaration.allCaseDeclarationsSatisfying {
      $0.isSimpleCaseWithoutPayload
    }.map { caseDeclaration in
      (
        try attachmentContext.requireProperty(
          \.primarySourceCodeIdentifier,
           of: caseDeclaration
        ),
        caseDeclaration.hasAttribute(named: "ExcludeFromTransflection")
      )
    }
    
    let visibility = attachmentContext.visibilityLevel.keywordRepresentation
    
    let caseBlocks: [String] = transflectableEnumerationCaseNames.map { (caseNameToken, isExcluded) in
      switch isExcluded {
      case true:
        """
        case ".\(caseNameToken)":
          throw AutomaticSourceIdentifierTransflectionError.excludedFromTransflection(
            AutomaticSourceIdentifierTransflectionError.TypeNameWithIdentifier(
              typeName: String(describing: Self.self),
              sourceCodeIdentifier: sourceCodeIdentifier
            )
          )
        """
      case false:
        """
        case ".\(caseNameToken)":
          self = .\(caseNameToken)
        """
      }
    }
    
    return [
      try ExtensionDeclSyntax(
        """
        extension \(attachmentContext.extendedType): TransflectableViaSourceCodeIdentifier {
        
          \(raw: visibility) init(transflectingSourceCodeIdentifier sourceCodeIdentifier: String) throws {
            switch sourceCodeIdentifier {
            \(raw: caseBlocks.joined(separator: "\n"))
            default:
              throw AutomaticSourceIdentifierTransflectionError.unsupportedSourceCodeIdentifier(
                AutomaticSourceIdentifierTransflectionError.TypeNameWithIdentifier(
                  typeName: String(describing: Self.self),
                  sourceCodeIdentifier: sourceCodeIdentifier
                )
              )
            }
          }
        
        }
        """
      )
    ]
  }
}
