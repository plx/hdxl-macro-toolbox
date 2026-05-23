import SwiftParser
import SwiftSyntax

extension SyntaxProtocol {
  
  /// Parses `sourceCode` and returns the first syntax element of this type.
  ///
  /// This is intentionally broad: some syntax elements cannot be parsed as a
  /// complete source file by themselves, but can be constructed by parsing a
  /// larger source fragment and extracting the desired node.
  @inlinable
  public static func firstParsed(
    from sourceCode: String,
    viewMode: SyntaxTreeViewMode = .sourceAccurate,
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> Self {
    let sourceFile = Parser.parse(source: sourceCode)
    guard let result = sourceFile.firstSyntaxElement(
      ofType: Self.self,
      viewMode: viewMode
    ) else {
      throw MacroExpansionFailure(
        explanation: "Unable to find \(String(reflecting: Self.self)) in parsed source.",
        function: function,
        fileID: fileID,
        line: line,
        column: column
      )
    }
    
    return result
  }
  
  /// Parses `sourceCode` and initializes `self` with the first syntax element of this type.
  @inlinable
  public init(
    firstParsedFrom sourceCode: String,
    viewMode: SyntaxTreeViewMode = .sourceAccurate,
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws {
    self = try Self.firstParsed(
      from: sourceCode,
      viewMode: viewMode,
      function: function,
      fileID: fileID,
      line: line,
      column: column
    )
  }
  
  /// Parses `sourceCode` and returns the only syntax element of this type.
  @inlinable
  public static func onlyParsed(
    from sourceCode: String,
    viewMode: SyntaxTreeViewMode = .sourceAccurate,
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> Self {
    let matches = Parser
      .parse(source: sourceCode)
      .allSyntaxElements(
        ofType: Self.self,
        viewMode: viewMode
      )
    
    guard matches.count == 1, let result = matches.first else {
      throw MacroExpansionFailure(
        explanation: "Expected exactly one \(String(reflecting: Self.self)) in parsed source; found \(matches.count).",
        function: function,
        fileID: fileID,
        line: line,
        column: column
      )
    }
    
    return result
  }
  
  /// Parses `sourceCode` and initializes `self` with its only syntax element of this type.
  @inlinable
  public init(
    onlyParsedFrom sourceCode: String,
    viewMode: SyntaxTreeViewMode = .sourceAccurate,
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws {
    self = try Self.onlyParsed(
      from: sourceCode,
      viewMode: viewMode,
      function: function,
      fileID: fileID,
      line: line,
      column: column
    )
  }
  
}
