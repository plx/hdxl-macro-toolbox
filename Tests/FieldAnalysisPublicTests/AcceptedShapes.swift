// This file is compiled as Swift, then the public-consumer tests analyze this very source file.
// Actor isolation permits mutable static state under Swift 6's concurrency rules.
let acceptedShapesSourcePath = #filePath

@propertyWrapper
public struct MatrixWrapper<Value> {
  public var wrappedValue: Value
  public init(wrappedValue: Value) { self.wrappedValue = wrappedValue }
}

@MainActor
public struct FieldMatrixFixture {
  let value: String
  var a: Int = 1, b: Int = 2
  var inferred = 1
  var answer: Int { 42 }
  var explicitComputed: Int { get { 42 } }
  var observed: Int = 0 { didSet {} }
  static var total: Int = 0
  public private(set) var visible: String = ""
  lazy var deferred: String = ""
  @MatrixWrapper var wrapped: Int = 0
  struct Nested { var child: Int }
  func behavior() {}
  #if FEATURE
  var conditional: Int = 0
  #else
  var alternative: String = ""
  #endif
}

struct UnfamiliarAccessorFixture {
  var yielded: Int { _read { yield 42 } }
}

private struct PrivateAccessFixture {
  private(set) var local: Int = 0
  private(set) public var exposed: Int = 0
}
