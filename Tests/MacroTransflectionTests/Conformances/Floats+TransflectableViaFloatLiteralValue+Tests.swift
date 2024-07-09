import Testing
import MacroToolboxTestSupport
@testable import MacroTransflection

// MARK: Conformance Basics

@Test(
  "`Float16` transflection",
  .tags(
    .transflection,
    .floatingPointTransflections,
    .float16Transflection
  ),
  arguments: probeValues(type: Float16.self)
)
func testFloat16TransflectionConformance(
  probe: Float16
) throws {
  try probe.validateTransflection()
}

@Test(
  "`Float` transflection",
  .tags(
    .transflection,
    .floatingPointTransflections,
    .floatTransflection
  ),
  arguments: probeValues(type: Float.self)
)
func testFloatTransflectionConformance(
  probe: Float
) throws {
  try probe.validateTransflection()
}

@Test(
  "`Double` transflection",
  .tags(
    .transflection,
    .floatingPointTransflections,
    .doubleTransflection
  ),
  arguments: probeValues(type: Double.self)
)
func testDoubleTransflectionConformance(
  probe: Double
) throws {
  try probe.validateTransflection()
}

// MARK: Unrepresentable Values

@Test(
  "`Float16` transflection throws on unrepresentable values",
  .tags(
    .transflection,
    .floatingPointTransflections,
    .float16Transflection,
    .negativeExamples,
    .unrepresentableValues
  ),
  arguments: unrepresentableProbes(forType: Float16.self)
)
func testFloat16TransflectionThrowsOnUnrepresentableValues(
  probe: Double
) throws {
  try probe.validateTransflectionFailure(forType: Float16.self)
}

@Test(
  "`Float` transflection throws on unrepresentable values",
  .tags(
    .transflection,
    .floatingPointTransflections,
    .floatTransflection,
    .negativeExamples,
    .unrepresentableValues
  ),
  arguments: unrepresentableProbes(forType: Float.self)
)
func testFloatTransflectionThrowsOnUnrepresentableValues(
  probe: Double
) throws {
  try probe.validateTransflectionFailure(forType: Float.self)
}

// MARK: Test Examples

fileprivate func probeValues<T>(
  type: T.Type,
  lowerBound: T = -2.0,
  upperBound: T = 2.0,
  stride: T = 0.1,
  includeNaNs: Bool = true,
  includeInfinities: Bool = true
) -> some Sendable & Collection<T> where T: BinaryFloatingPoint, T.Stride == T, T: Sendable {
  var numericExamples: [T] = []
  numericExamples.append(
    contentsOf: Swift.stride(
      from: lowerBound,
      through: upperBound,
      by: stride
    )
  )
  
  if includeNaNs {
    numericExamples.append(T.nan)
    numericExamples.append(T.signalingNaN)
  }
  if includeInfinities {
    numericExamples.append(T.infinity)
    numericExamples.append(-T.infinity)
  }
  
  return numericExamples
}

fileprivate func unrepresentableProbes<T>(
  forType type: T.Type
) -> some Sendable & Collection<Double> where T: BinaryFloatingPoint {
  guard
    let greatest = Double(exactly: T.greatestFiniteMagnitude),
    let leastNonZero = Double(exactly: T.leastNonzeroMagnitude)
  else {
    preconditionFailure()
  }
  
  return [
    greatest * 2.0,
    leastNonZero / 2.0
  ]
}

// MARK: Test Logic

extension BinaryFloatingPoint where Self: TransflectableViaFloatLiteralValue {
  
  fileprivate func validateTransflection(
    _ function: StaticString = #function,
    _ sourceLocation: SourceLocation = .automatic()
  ) throws {
    try validateFloatingPointTransflectionRoundTrip(
      original: self,
      literal: try #require(Double(exactLiteralEquivalent: self)),
      function: function,
      sourceLocation: sourceLocation,
      transflection: Self.init(transflectingFloatLiteralValue:)
    )
  }
  
}

extension Double {
  
  fileprivate init?<T>(exactLiteralEquivalent value: T) where T: BinaryFloatingPoint {
    if value.isSignalingNaN {
      self = .signalingNaN
    } else if value.isNaN {
      self = .nan
    } else if value == .infinity {
      self = .infinity
    } else if value == -.infinity {
      self = -.infinity
    } else {
      self.init(exactly: value)
    }
  }
  
  fileprivate func validateTransflectionFailure<T>(
    forType type: T.Type,
    _ function: StaticString = #function,
    _ sourceLocation: SourceLocation = .automatic()
  ) throws where T: TransflectableViaFloatLiteralValue {
    #expect(
      throws: FloatLiteralTransflectionError.self,
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
      try type.init(transflectingFloatLiteralValue: self)
    }
    
  }

}
