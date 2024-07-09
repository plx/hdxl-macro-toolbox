import Testing
import MacroToolboxTestSupport
@testable import MacroToolbox

@Test(
  "`MacroAttachmentRequirement<TypeDeclarationArchetype>` conversion equivalence (unspecified)",
  .tags(
    .macroAttachmentRequirement,
    .declarationArchetype,
    .typeDeclarationArchetype
  )
)
func testMacroAttachmentRequirementTypeDeclarationArchetypeConversionEquivalence_unspecified() {
  
  let typeAttachmentRequirement = MacroAttachmentRequirement<TypeDeclarationArchetype>.unspecified
  let attachmentRequirement = MacroAttachmentRequirement<DeclarationArchetype>.unspecified
  
  let equivalentAttachmentRequirement = typeAttachmentRequirement.equivalentDeclarationArchetypeRequirement
  
  for probe in TypeDeclarationArchetype.allCases {
    #expect(
      typeAttachmentRequirement.isCompatible(with: probe)
      ==
      attachmentRequirement.isCompatible(with: probe.declarationArchetype)
    )
  }
  
  for probe in DeclarationArchetype.allCases {
    #expect(
      equivalentAttachmentRequirement.isCompatible(with: probe)
      ==
      attachmentRequirement.isCompatible(with: probe)
    )
  }
}

@Test(
  "`MacroAttachmentRequirement<TypeDeclarationArchetype>` conversion equivalence (exactly)",
  .tags(
    .macroAttachmentRequirement,
    .declarationArchetype,
    .typeDeclarationArchetype
  ),
  arguments: TypeDeclarationArchetype.allCases, DeclarationArchetype.allCases
)
func testMacroAttachmentRequirementTypeDeclarationArchetypeConversionEquivalence_exactly(
  typeDeclarationArchetype: TypeDeclarationArchetype,
  declarationArchetype: DeclarationArchetype
) {
  let typeAttachmentRequirement = MacroAttachmentRequirement<TypeDeclarationArchetype>.exactly(
    typeDeclarationArchetype
  )
  
  let attachmentRequirement = MacroAttachmentRequirement<DeclarationArchetype>.exactly(
    typeDeclarationArchetype.declarationArchetype
  )
  
  let equivalentAttachmentRequirement = typeAttachmentRequirement.equivalentDeclarationArchetypeRequirement
  
  for probe in TypeDeclarationArchetype.allCases {
    #expect(
      typeAttachmentRequirement.isCompatible(with: probe)
      ==
      attachmentRequirement.isCompatible(with: probe.declarationArchetype)
    )
  }
  
  for probe in DeclarationArchetype.allCases {
    #expect(
      equivalentAttachmentRequirement.isCompatible(with: probe)
      ==
      attachmentRequirement.isCompatible(with: probe)
    )
  }
}

@Test(
  "`MacroAttachmentRequirement<TypeDeclarationArchetype>` conversion equivalence (mustBeOneOf)",
  .tags(
    .macroAttachmentRequirement,
    .declarationArchetype,
    .typeDeclarationArchetype
  ),
  arguments: TypeDeclarationArchetype.allCases, DeclarationArchetype.allCases
)
func testMacroAttachmentRequirementTypeDeclarationArchetypeConversionEquivalence_mustBeOneOf(
  typeDeclarationArchetype: TypeDeclarationArchetype,
  declarationArchetype: DeclarationArchetype
) {
  let typeAttachmentRequirement = MacroAttachmentRequirement<TypeDeclarationArchetype>.mustBeOneOf([
      typeDeclarationArchetype
  ])
  
  let attachmentRequirement = MacroAttachmentRequirement<DeclarationArchetype>.mustBeOneOf([
    typeDeclarationArchetype.declarationArchetype
  ])
  
  let equivalentAttachmentRequirement = typeAttachmentRequirement.equivalentDeclarationArchetypeRequirement
  
  for probe in TypeDeclarationArchetype.allCases {
    #expect(
      typeAttachmentRequirement.isCompatible(with: probe)
      ==
      attachmentRequirement.isCompatible(with: probe.declarationArchetype)
    )
  }
  
  for probe in DeclarationArchetype.allCases {
    #expect(
      equivalentAttachmentRequirement.isCompatible(with: probe)
      ==
      attachmentRequirement.isCompatible(with: probe)
    )
  }
}

@Test(
  "`MacroAttachmentRequirement<TypeDeclarationArchetype>` conversion equivalence (anythingBut)",
  .tags(
    .macroAttachmentRequirement,
    .declarationArchetype,
    .typeDeclarationArchetype
  ),
  arguments: TypeDeclarationArchetype.allCases, DeclarationArchetype.allCases
)
func testMacroAttachmentRequirementTypeDeclarationArchetypeConversionEquivalence_anythingBut(
  typeDeclarationArchetype: TypeDeclarationArchetype,
  declarationArchetype: DeclarationArchetype
) {
  let typeAttachmentRequirement = MacroAttachmentRequirement<TypeDeclarationArchetype>.anythingBut([
      typeDeclarationArchetype
  ])
  
  let attachmentRequirement = MacroAttachmentRequirement<DeclarationArchetype>.anythingBut(
    DeclarationArchetype
      .setOfAllCases
      .subtracting(
        TypeDeclarationArchetype
          .setOfAllCases
          .subtracting([typeDeclarationArchetype])
          .setMap(\.declarationArchetype)
      )
  )
  
  let equivalentAttachmentRequirement = typeAttachmentRequirement.equivalentDeclarationArchetypeRequirement
  
  for probe in TypeDeclarationArchetype.allCases {
    #expect(
      typeAttachmentRequirement.isCompatible(with: probe)
      ==
      attachmentRequirement.isCompatible(with: probe.declarationArchetype)
    )
  }
  
  for probe in DeclarationArchetype.allCases {
    #expect(
      equivalentAttachmentRequirement.isCompatible(with: probe)
      ==
      attachmentRequirement.isCompatible(with: probe)
    )
  }
}
