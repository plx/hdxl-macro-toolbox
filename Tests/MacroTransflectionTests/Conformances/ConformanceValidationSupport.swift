import Testing

func validateTransflectionRoundTrip<Probe, Literal>(
  original: Probe,
  literal: Literal,
  function: StaticString = #function,
  sourceLocation: SourceLocation = .automatic(),
  transflection transflectionOperation: (Literal) throws -> Probe
) throws where Probe: Equatable {
  let transflected = try transflectionOperation(literal)
  #expect(
    original == transflected,
    """
    Unexpected transflection failure for type \(String(reflecting: Probe.self)) (via literal-type \(String(reflecting: Literal.self)))!
    
    - `original`: \(original)
    - `literal`: \(literal)
    - `transflected`: \(transflected)
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
}

func validateFloatingPointTransflectionRoundTrip<Probe, Literal>(
  original: Probe,
  literal: Literal,
  function: StaticString = #function,
  sourceLocation: SourceLocation = .automatic(),
  transflection transflectionOperation: (Literal) throws -> Probe
) throws where Probe: Equatable, Probe: FloatingPoint, Literal: FloatingPoint {
  let transflected = try transflectionOperation(literal)
  #expect(
    original == transflected
    ||
    ((original.isNaN || original.isSignalingNaN)
     ==
     (transflected.isNaN || transflected.isSignalingNaN)),
    """
    Unexpected transflection failure for type \(String(reflecting: Probe.self)) (via literal-type \(String(reflecting: Literal.self)))!
    
    - `original`: \(original)
    - `literal`: \(literal)
    - `transflected`: \(transflected)
    - `function`: \(function)
    - `fileID`: \(sourceLocation.fileID)
    - `line`: \(sourceLocation.line)
    - `column`: \(sourceLocation.column)
    """,
    sourceLocation: sourceLocation
  )
}
