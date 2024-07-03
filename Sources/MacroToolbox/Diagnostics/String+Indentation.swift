
extension String.StringInterpolation {
  
  package mutating func appendInterpolation(
    reindenting input: String,
    with indent: String
  ) {
    guard !indent.isEmpty else {
      appendLiteral(input)
      return
    }
    
    for (index,line) in input.split(separator: "\n", maxSplits: .max, omittingEmptySubsequences: false).enumerated() {
      let linePrefix = index > 0 ? "\n" : ""
      appendInterpolation("\(linePrefix)\(indent)\(line)")
    }
  }

  package mutating func appendInterpolation(
    reindenting input: String,
    indentation: String,
    depth: Int
  ) {
    appendInterpolation(
      reindenting: input,
      with: String(
        repeating: indentation,
        count: depth
      )
    )
  }

}
