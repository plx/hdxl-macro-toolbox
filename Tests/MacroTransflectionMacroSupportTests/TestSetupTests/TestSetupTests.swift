import Testing
import MacroToolboxTestSupport
@testable import MacroTransflectionMacroSupport

@Test(
  "Test `\"\\(type)\" produces clean type names",
  .tags(.testInfrastructure)
)
func testTypeValueStringInterpolationProducesCleanTypeNames() {
  verifyStringification(
    type: Int.self,
    expectation: "Int"
  )
  verifyStringification(
    type: Int8.self,
    expectation: "Int8"
  )
  verifyStringification(
    type: Int16.self,
    expectation: "Int16"
  )
  verifyStringification(
    type: Int32.self,
    expectation: "Int32"
  )
  verifyStringification(
    type: Int64.self,
    expectation: "Int64"
  )
  
  verifyStringification(
    type: UInt.self,
    expectation: "UInt"
  )
  verifyStringification(
    type: UInt8.self,
    expectation: "UInt8"
  )
  verifyStringification(
    type: UInt16.self,
    expectation: "UInt16"
  )
  verifyStringification(
    type: UInt32.self,
    expectation: "UInt32"
  )
  verifyStringification(
    type: UInt64.self,
    expectation: "UInt64"
  )
}

// MARK: Test Logic

fileprivate func verifyStringification<T>(
  type: T.Type,
  expectation: String,
  function: StaticString = #function,
  sourceLocation: Testing.SourceLocation = Testing.SourceLocation.automatic()
) {
  #expect(
    expectation == "\(type)",
    """
    Expected `"\\(type)"` to be `"\(expectation)"`, but got `"\(type)"` instead!
    
    - `type`: \(type)
    - `expectation`: \(expectation)
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
}
