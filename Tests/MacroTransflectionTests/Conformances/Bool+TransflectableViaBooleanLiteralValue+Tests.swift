import Testing
import MacroTransflection

@Test(
  "`Bool` transflection",
  arguments: [true, false]
)
func testBooleanTransflectionConformance(
  probe: Bool
) throws {
  let transflected = try Bool(transflectingBooleanLiteralValue: probe)
  #expect(probe == transflected)
}
