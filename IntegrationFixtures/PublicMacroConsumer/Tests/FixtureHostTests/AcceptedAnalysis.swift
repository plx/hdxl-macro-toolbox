// Compiler-checked analysis shapes, read as original source by PublicAPITests.
public struct AnalysisShape {
  let seed: Int
  var a: Int = 1, b: Int = 2
  public private(set) var value: String
  static let shared: Int = 3
  var projected: Int { seed }
}
let analysisSourcePath = #filePath
