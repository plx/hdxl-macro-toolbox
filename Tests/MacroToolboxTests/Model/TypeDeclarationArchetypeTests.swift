import Testing
@testable import MacroToolbox

@Test(
  "`TypeDeclarationArchetype.caseNameWithoutLeadingDot` uniqueness."
)
func testTypeDeclarationArchetypeCaseNameWithoutLeadingDotUniqueness() {
  #expect(
    Set(TypeDeclarationArchetype
      .allCases
      .map(\.caseNameWithoutLeadingDot)
    ).count
    ==
    TypeDeclarationArchetype.allCases.count
  )
}


@Test(
  "`TypeDeclarationArchetype.declarationArchetype`"
)
func testTypeDeclarationArchetypeDeclarationArchetype() {
  #expect(
    TypeDeclarationArchetype.actor.declarationArchetype
    ==
    .actor
  )
  #expect(
    TypeDeclarationArchetype.class.declarationArchetype
    ==
    .class
  )
  #expect(
    TypeDeclarationArchetype.enum.declarationArchetype
    ==
    .enum
  )
  #expect(
    TypeDeclarationArchetype.struct.declarationArchetype
    ==
    .struct
  )
  #expect(
    TypeDeclarationArchetype.protocol.declarationArchetype
    ==
    .protocol
  )
}

@Test(
  "`TypeDeclarationArchetype.isNotAProtocol`",
  arguments: TypeDeclarationArchetype.allCases
)
func testTypeDeclarationArchetypeIsNotAProtocol(
  archetype: TypeDeclarationArchetype
) {
  #expect(
    archetype.isNotAProtocol
    ==
    (archetype != .protocol)
  )
}

@Test(
  "`TypeDeclarationArchetype.isEnumClassOrStruct`",
  arguments: TypeDeclarationArchetype.allCases
)
func testTypeDeclarationArchetypeIsEnumClassOrStruct(
  archetype: TypeDeclarationArchetype
) {
  #expect(
    archetype.isEnumClassOrStruct
    ==
    [.enum, .class, .struct].contains(archetype)
  )
}

@Test(
  "`TypeDeclarationArchetype.isActorClassOrStruct`",
  arguments: TypeDeclarationArchetype.allCases
)
func testTypeDeclarationArchetypeIsActorClassOrStruct(
  archetype: TypeDeclarationArchetype
) {
  #expect(
    archetype.isActorClassOrStruct
    ==
    [.actor, .class, .struct].contains(archetype)
  )
}
