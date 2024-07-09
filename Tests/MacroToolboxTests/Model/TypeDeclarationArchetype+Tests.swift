import Testing
import MacroToolboxTestSupport
@testable import MacroToolbox

@Test(
  "`TypeDeclarationArchetype.description` uniqueness",
  .tags(.typeDeclarationArchetype)
)
func testTypeDeclarationArchetypeDescriptionUniqueness() {
  #expect(
    TypeDeclarationArchetype
      .allCases
      .count
    ==
    Set(
      TypeDeclarationArchetype
        .allCases
        .lazy
        .map(\.description)
    ).count
  )
}

@Test(
  "`TypeDeclarationArchetype.debugDescription` uniqueness",
  .tags(.typeDeclarationArchetype)
)
func testTypeDeclarationArchetypeDebugDescriptionUniqueness() {
  #expect(
    TypeDeclarationArchetype
      .allCases
      .count
    ==
    Set(
      TypeDeclarationArchetype
        .allCases
        .lazy
        .map(\.debugDescription)
    ).count
  )
}

@Test(
  "`TypeDeclarationArchetype.caseNameWithoutLeadingDot` uniqueness",
  .tags(.typeDeclarationArchetype)
)
func testTypeDeclarationArchetypeCaseNameWithoutLeadingDotUniqueness() {
  #expect(
    TypeDeclarationArchetype
      .allCases
      .count
    ==
    Set(
      TypeDeclarationArchetype
        .allCases
        .lazy
        .map(\.caseNameWithoutLeadingDot)
    ).count
  )
}

@Test(
  "`TypeDeclarationArchetype.declarationArchetype`",
  .tags(.typeDeclarationArchetype)
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
  .tags(.typeDeclarationArchetype),
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
  .tags(.typeDeclarationArchetype),
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
  .tags(.typeDeclarationArchetype),
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
