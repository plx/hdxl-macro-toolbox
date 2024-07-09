import Testing
import MacroToolboxTestSupport
@testable import MacroTransflection

@Test(
  "`Bool` transflection",
  .tags(
    .transflection,
    .booleanTransflections
  ),
  arguments: [true, false]
)
func testBooleanTransflectionConformance(
  probe: Bool
) throws {
  let transflected = try Bool(transflectingBooleanLiteralValue: probe)
  #expect(probe == transflected)
}
