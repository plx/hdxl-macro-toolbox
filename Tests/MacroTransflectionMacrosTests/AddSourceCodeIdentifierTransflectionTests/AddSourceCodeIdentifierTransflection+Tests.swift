import Testing
import MacroTransflection
import MacroTransflectionMacros
import MacroToolboxTestSupport

@AddSourceCodeIdentifierTransflection
enum ExampleTransflectableEnumeration {
  case foo
  case bar
  case baz
  
  @ExcludeFromTransflection
  case excludedQuuz
}

@Test(
  "`AddSourceCodeIdentifierTransflection` on `ExampleTransflectableEnumeration`",
  .tags(
    .transflection,
    .enumerationTransflections
  )
)
func testAddSourceCodeIdentifierTransflectionOnExampleTransflectableEnumeration() throws {
  // these should work:
  #expect(
    try (
      ExampleTransflectableEnumeration.foo
      ==
      ExampleTransflectableEnumeration(transflectingSourceCodeIdentifier: ".foo")
    )
  )
  #expect(
    try (
      ExampleTransflectableEnumeration.bar
      ==
      ExampleTransflectableEnumeration(transflectingSourceCodeIdentifier: ".bar")
    )
  )
  #expect(
    try (
      ExampleTransflectableEnumeration.baz
      ==
      ExampleTransflectableEnumeration(transflectingSourceCodeIdentifier: ".baz")
    )
  )

  // these should fail exactly like so:
  #expect(
    throws: AutomaticSourceIdentifierTransflectionError.self
  ) {
    try ExampleTransflectableEnumeration(transflectingSourceCodeIdentifier: ".quuz")
  }
  #expect(
    throws: AutomaticSourceIdentifierTransflectionError.self
  ) {
    try ExampleTransflectableEnumeration(transflectingSourceCodeIdentifier: ".notACase")
  }
  
  // we also reject the ones without a leading dot:
  #expect(
    throws: AutomaticSourceIdentifierTransflectionError.self
  ) {
    try ExampleTransflectableEnumeration(transflectingSourceCodeIdentifier: "foo")
  }
  #expect(
    throws: AutomaticSourceIdentifierTransflectionError.self
  ) {
    try ExampleTransflectableEnumeration(transflectingSourceCodeIdentifier: "bar")
  }
  #expect(
    throws: AutomaticSourceIdentifierTransflectionError.self
  ) {
    try ExampleTransflectableEnumeration(transflectingSourceCodeIdentifier: "baz")
  }
}
