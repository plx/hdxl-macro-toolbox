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

@Test(
  "`MacroAttachmentRequirement` descriptions and direct compatibility",
  .tags(.macroAttachmentRequirement)
)
func testMacroAttachmentRequirementDescriptionsAndDirectCompatibility() {
  // Hand-written examples: each requirement case should describe itself, report
  // whether a probe value is accepted, and keep empty-set requirements marked as
  // internally inconsistent.
  let unspecified = MacroAttachmentRequirement<Int>.unspecified
  let exact = MacroAttachmentRequirement<Int>.exactly(2)
  let oneOf = MacroAttachmentRequirement<Int>.mustBeOneOf([1, 3])
  let anythingBut = MacroAttachmentRequirement<Int>.anythingBut([4])
  let mustNotBe = MacroAttachmentRequirement<Int>.mustNotBe(2)

  #expect(unspecified.description == ".unspecified")
  #expect(exact.description == ".exactly(2)")
  #expect(oneOf.description.contains(".mustBeOneOf"))
  #expect(anythingBut.description.contains(".anythingBut"))
  #expect(unspecified.debugDescription == "MacroAttachmentRequirement.unspecified")
  #expect(exact.debugDescription == "MacroAttachmentRequirement.exactly(2)")
  #expect(oneOf.debugDescription.contains("MacroAttachmentRequirement.mustBeOneOf"))
  #expect(anythingBut.debugDescription.contains("MacroAttachmentRequirement.anythingBut"))
  #expect(unspecified.isCompatible(with: 99))
  #expect(exact.isCompatible(with: 2))
  #expect(!exact.isCompatible(with: 1))
  #expect(oneOf.isCompatible(with: 3))
  #expect(!oneOf.isCompatible(with: 2))
  #expect(anythingBut.isCompatible(with: 2))
  #expect(!anythingBut.isCompatible(with: 4))
  #expect(mustNotBe.isCompatible(with: 1))
  #expect(!mustNotBe.isCompatible(with: 2))
  #expect(unspecified.hasConsistentInternalState)
  #expect(exact.hasConsistentInternalState)
  #expect(oneOf.hasConsistentInternalState)
  #expect(anythingBut.hasConsistentInternalState)
  #expect(!MacroAttachmentRequirement<Int>.mustBeOneOf([]).hasConsistentInternalState)
  #expect(!MacroAttachmentRequirement<Int>.anythingBut([]).hasConsistentInternalState)
}

@Test(
  "`MacroAttachmentRequirement.mapRequirements` preserves compatibility",
  .tags(.macroAttachmentRequirement)
)
func testMacroAttachmentRequirementMapRequirementsPreservesCompatibility() throws {
  // Property-style test: mapping requirements into another hashable domain should
  // preserve compatibility for every requirement shape when probes are mapped by
  // the same transformation.
  let requirements: [MacroAttachmentRequirement<Int>] = [
    .unspecified,
    .exactly(2),
    .mustBeOneOf([1, 3]),
    .anythingBut([4])
  ]

  for requirement in requirements {
    let mapped = requirement.mapRequirements { "value-\($0)" }

    for probe in [1, 2, 3, 4, 5] {
      #expect(
        mapped.isCompatible(with: "value-\(probe)")
        ==
        requirement.isCompatible(with: probe)
      )
    }
  }
}
