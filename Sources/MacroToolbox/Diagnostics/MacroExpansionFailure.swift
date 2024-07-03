import SwiftSyntax
import SwiftDiagnostics

public struct MacroExpansionFailure : Error {
  
  public let explanation: String
  public let suberrors: [any Error]
      
  public let function: StaticString
  public let fileID: StaticString
  public let line: UInt
  public let column: UInt
  
  public init(
    explanation: String,
    suberrors: [any Error] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) {
    self.explanation = explanation
    self.suberrors = suberrors
    self.function = function
    self.fileID = fileID
    self.line = line
    self.column = column
  }

  public init(
    encapsulating anyOtherError: any Error,
    explanation: String,
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) {
    precondition(nil == anyOtherError as? MacroExpansionFailure)
    self.init(
      explanation: explanation,
      suberrors: [anyOtherError],
      function: function,
      fileID: fileID,
      line: line,
      column: column
    )
  }

  public func encapsulated(
    with explanation: String,
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) -> MacroExpansionFailure {
    MacroExpansionFailure(
      explanation: explanation,
      suberrors: [self] + suberrors,
      function: function,
      fileID: fileID,
      line: line,
      column: column
    )
  }
  
}

extension MacroExpansionFailure {
  
  public static func withAutomaticEncapsulation<R>(
    explanation: @autoclosure () -> String,
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column,
    _ closure: () throws -> R
  ) throws -> R {
    do {
      return try closure()
    }
    catch let macroExpansionFailure as MacroExpansionFailure {
      throw macroExpansionFailure
    }
    catch let anyOtherError {
      throw MacroExpansionFailure(
        encapsulating: anyOtherError,
        explanation: explanation(),
        function: function,
        fileID: fileID,
        line: line,
        column: column
      )
    }
  }
}

extension MacroExpansionFailure: CustomStringConvertible {
  
  public var description: String {
    "\(explanation) @ \(line) in \(function) from \(fileID)"
  }
  
}

extension MacroExpansionFailure: CustomDebugStringConvertible {
  
  public var debugDescription: String {
    String(
      forConstructorOf: Self.self,
      arguments: (
        ("explanation", explanation),
        ("suberrors", suberrors),
        ("function", function),
        ("fileID", fileID),
        ("line", line),
        ("column", column)
      )
    )
  }
  
}

extension String {
  
  mutating func appendAdditionalLine(_  additionalLine: String) {
    append("\n")
    append(additionalLine)
  }

  mutating func appendAdditionalLine(
    _  additionalLine: String,
    reindentedWith indent: String
  ) {
    appendAdditionalLine("\(indent)\(additionalLine)")
  }

  mutating func appendAdditionalLine(
    _  additionalLine: String,
    indentation: String,
    depth: Int
  ) {
    appendAdditionalLine(
      additionalLine,
      reindentedWith: String(
        repeating: indentation,
        count: depth
      )
    )
  }

  mutating func appendAdditionalLines(_  additionalLines: some Sequence<String>) {
    for additionalLine in additionalLines {
      appendAdditionalLine(additionalLine)
    }
  }
  
  mutating func appendAdditionalLines(
    _  additionalLines: some Sequence<String>,
    reindentedWith indent: String
  ) {
    appendAdditionalLines(
      additionalLines.lazy.map { "\(indent)\($0)" }
    )
  }

  mutating func appendAdditionalLines(
    _  additionalLines: some Sequence<String>,
    indentation: String,
    depth: Int
  ) {
    appendAdditionalLines(
      additionalLines,
      reindentedWith: String(
        repeating: indentation,
        count: depth
      )
    )
  }

}

extension MacroExpansionFailure {
  
  private func addPrettyPrintedFields(
    to inProgressString: inout String,
    indentation: String,
    depth: Int
  ) {
    inProgressString.appendAdditionalLines(
      [
        "- `explanation`: \(explanation)",
        "- `function`: \(function)",
        "- `fileID`: \(fileID)",
        "- `line`: \(line)",
        "- `column`: \(column)"
      ],
      indentation: indentation,
      depth: depth
    )
    
    inProgressString.appendAdditionalLine(
      "- `suberrors`:",
      indentation: indentation,
      depth: depth
    )
    
    let count = suberrors.count
    for (index, suberror) in suberrors.enumerated() {
      addPrettyPrintedSuberror(
        suberror,
        index: index,
        count: count,
        to: &inProgressString,
        indentation: indentation,
        depth: depth + 1
      )
    }
  }
  
  private func addPrettyPrintedSuberror(
    _ suberror: any Error,
    index: Int,
    count: Int,
    to inProgressString: inout String,
    indentation: String,
    depth: Int
  ) {
    inProgressString.appendAdditionalLine(
      "- `error` (\(1 + index)/\(count)):",
      indentation: indentation,
      depth: depth
    )
    inProgressString.appendAdditionalLine(
      "- `type`: \(String(reflecting: type(of: suberror)))",
      indentation: indentation,
      depth: depth + 1
    )
    switch suberror as? MacroExpansionFailure {
    case .some(let macroExpansionFailure):
      macroExpansionFailure.addPrettyPrintedFields(
        to: &inProgressString,
        indentation: indentation,
        depth: depth + 1
      )
    case .none:
      inProgressString.appendAdditionalLine(
        "- `debugDescription`: \(String(reflecting: suberror))",
        indentation: indentation,
        depth: depth + 1
      )
    }
  }
  
  public func prettyPrinted(
    indentation: String = "  ",
    depth: Int = 0
  ) -> String {
    var result = "`MacroExpansionFailure`"
    addPrettyPrintedFields(
      to: &result,
      indentation: indentation,
      depth: depth + 1
    )
    
    return result
  }
  
}
