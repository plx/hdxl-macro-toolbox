import Testing
import MacroTransflection

// MARK: Signed Integer

@Test(
  "`Int` transflection",
  arguments: probeRange(type: Int.self)
)
func testIntTransflectionConformance(
  probe: Int
) throws {
  try probe.validateTransflection()
}

@Test(
  "`Int8` transflection",
  arguments: probeRange(type: Int8.self)
)
func testInt8TransflectionConformance(
  probe: Int8
) throws {
  try probe.validateTransflection()
}

@Test(
  "`Int16` transflection",
  arguments: probeRange(type: Int16.self)
)
func testInt16TransflectionConformance(
  probe: Int16
) throws {
  try probe.validateTransflection()
}

@Test(
  "`Int32` transflection",
  arguments: probeRange(type: Int32.self)
)
func testInt32TransflectionConformance(
  probe: Int32
) throws {
  try probe.validateTransflection()
}

@Test(
  "`Int64` transflection",
  arguments: probeRange(type: Int64.self)
)
func testInt64TransflectionConformance(
  probe: Int64
) throws {
  try probe.validateTransflection()
}

// MARK: Unsigned Integer

@Test(
  "`UInt` transflection",
  arguments: probeRange(type: UInt.self)
)
func testUIntTransflectionConformance(
  probe: UInt
) throws {
  try probe.validateTransflection()
}

@Test(
  "`UInt8` transflection",
  arguments: probeRange(type: UInt8.self)
)
func testUInt8TransflectionConformance(
  probe: UInt8
) throws {
  try probe.validateTransflection()
}

@Test(
  "`UInt16` transflection",
  arguments: probeRange(type: UInt16.self)
)
func testUInt16TransflectionConformance(
  probe: UInt16
) throws {
  try probe.validateTransflection()
}

@Test(
  "`UInt32` transflection",
  arguments: probeRange(type: UInt32.self)
)
func testUInt32TransflectionConformance(
  probe: UInt32
) throws {
  try probe.validateTransflection()
}

@Test(
  "`UInt64` transflection",
  arguments: probeRange(type: UInt64.self)
)
func testUInt64TransflectionConformance(
  probe: UInt64
) throws {
  try probe.validateTransflection()
}

// MARK: Integer - Throws on Unrepresentable

// we skip `Int` b/c it's always representable as an `Int`

@Test(
  "`Int8` throws on unrepresentable literals",
  arguments: unrepresentableProbes(forType: Int8.self)
)
func testInt8TransflectionThrowsOnUnrepresentableLiterals(
  literalValue: Int
) throws {
  try literalValue.validateTransflectionFailure(forType: Int8.self)
}

@Test(
  "`Int16` throws on unrepresentable literals",
  arguments: unrepresentableProbes(forType: Int16.self)
)
func testInt16TransflectionThrowsOnUnrepresentableLiterals(
  literalValue: Int
) throws {
  try literalValue.validateTransflectionFailure(forType: Int16.self)
}

@Test(
  "`Int32` throws on unrepresentable literals",
  arguments: unrepresentableProbes(forType: Int32.self)
)
func testInt32TransflectionThrowsOnUnrepresentableLiterals(
  literalValue: Int
) throws {
  try literalValue.validateTransflectionFailure(forType: Int32.self)
}

// we skip Int64 b/c it's also never unrepresentable by `Int`

// MARK: Unsigned Integer - Throws on Unrepresentable

@Test(
  "`UInt` throws on unrepresentable literals",
  arguments: unrepresentableProbes(forType: UInt.self)
)
func testUIntTransflectionThrowsOnUnrepresentableLiterals(
  literalValue: Int
) throws {
  try literalValue.validateTransflectionFailure(forType: UInt.self)
}

@Test(
  "`UInt8` throws on unrepresentable literals",
  arguments: unrepresentableProbes(forType: UInt8.self)
)
func testUInt8TransflectionThrowsOnUnrepresentableLiterals(
  literalValue: Int
) throws {
  try literalValue.validateTransflectionFailure(forType: UInt8.self)
}

@Test(
  "`UInt16` throws on unrepresentable literals",
  arguments: unrepresentableProbes(forType: UInt16.self)
)
func testUInt16TransflectionThrowsOnUnrepresentableLiterals(
  literalValue: Int
) throws {
  try literalValue.validateTransflectionFailure(forType: UInt16.self)
}

@Test(
  "`UInt32` throws on unrepresentable literals",
  arguments: unrepresentableProbes(forType: UInt32.self)
)
func testUInt32TransflectionThrowsOnUnrepresentableLiterals(
  literalValue: Int
) throws {
  try literalValue.validateTransflectionFailure(forType: UInt32.self)
}

@Test(
  "`UInt64` throws on unrepresentable literals",
  arguments: unrepresentableProbes(forType: UInt64.self)
)
func testUInt64TransflectionThrowsOnUnrepresentableLiterals(
  literalValue: Int
) throws {
  try literalValue.validateTransflectionFailure(forType: UInt64.self)
}

// MARK: Test Ranges

fileprivate func unrepresentableProbes<T>(
  forType type: T.Type
) -> some Sendable & Collection<Int> where T: SignedInteger, T: FixedWidthInteger {
  precondition(type != Int64.self && type != Int.self)
  guard
    let largestRepresentableValue = Int(exactly: type.max),
    let smallestRepresentableValue = Int(exactly: type.min)
  else {
    preconditionFailure()
  }
  
  return (
    [Int.min, Int.max]
    +
    Array((largestRepresentableValue + 1)...(largestRepresentableValue + 4))
    +
    Array((smallestRepresentableValue - 5)...(smallestRepresentableValue - 1))
  )
}

fileprivate func unrepresentableProbes<T>(
  forType type: T.Type
) -> some Sendable & Collection<Int> where T: UnsignedInteger, T: FixedWidthInteger {
  let negativeExamples: [Int] = Array((-5)...(-1))
  guard 
    type != UInt64.self,
    let largestRepresentableValue = Int(exactly: type.max)
  else {
    return negativeExamples
  }
  
  return (
    [Int.max, Int.min]
    +
    Array((largestRepresentableValue + 1)...(largestRepresentableValue + 4))
    +
    Array((-5)...(-1)))
}

fileprivate func probeRange<T>(
  type: T.Type,
  lowerBound: T = -4,
  upperBound: T = 5
) -> some Sendable & Collection<T> where T: SignedInteger, T.Stride: SignedInteger {
  lowerBound..<upperBound
}

fileprivate func probeRange<T>(
  type: T.Type,
  lowerBound: T = 0,
  upperBound: T = 5
) -> some Sendable & Collection<T> where T: UnsignedInteger, T.Stride: SignedInteger {
  lowerBound..<upperBound
}

fileprivate func negativeLiterals() -> some Sendable & Collection<Int> {
  (-5)...(-1)
}

// MARK: Test Logic

extension BinaryInteger where Self: TransflectableViaIntegerLiteralValue {
  
  fileprivate func validateTransflection(
    _ function: StaticString = #function,
    _ sourceLocation: SourceLocation = SourceLocation()
  ) throws {
    try validateTransflectionRoundTrip(
      original: self,
      literal: try #require(Int(exactly: self)),
      function: function,
      sourceLocation: sourceLocation,
      transflection: Self.init(transflectingIntegerLiteralValue:)
    )
  }
  
}

extension Int {
  
  fileprivate func validateTransflectionFailure<T>(
    forType type: T.Type,
    _ function: StaticString = #function,
    _ sourceLocation: SourceLocation = SourceLocation()
  ) throws where T: TransflectableViaIntegerLiteralValue {
    #expect(
      throws: IntegerLiteralTransflectionError.self,
      """
      We expected a transflection-error, but didn't get one!
      
      - `type`: \(type)
      - `literal`: \(self)
      - `function`: \(function)
      - `fileID`: \(sourceLocation.fileID)
      - `line`: \(sourceLocation.line)
      - `column`: \(sourceLocation.column)
      """,
      sourceLocation: sourceLocation
    ) {
      try type.init(transflectingIntegerLiteralValue: self)
    }
    
  }

}
