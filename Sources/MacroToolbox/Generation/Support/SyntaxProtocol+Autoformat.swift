import SwiftSyntax
import SwiftBasicFormat

@inlinable
public func autoformattedEquivalent<T>(
  of syntax: T,
  initialIndentation: Trivia = Trivia(),
  viewMode: SyntaxTreeViewMode = .sourceAccurate,
  function: StaticString = #function,
  fileID: StaticString = #fileID,
  line: UInt = #line,
  column: UInt = #column
) throws -> T where T: SyntaxProtocol {
  try syntax.autoFormattedForHDXLProject(
    initialIndentation: initialIndentation,
    viewMode: viewMode,
    function: function,
    fileID: fileID,
    line: line,
    column: column
  )
}

@inlinable
public func autoformattedEquivalents<T>(
  of syntaxes: some Sequence<T>,
  initialIndentation: Trivia = Trivia(),
  viewMode: SyntaxTreeViewMode = .sourceAccurate,
  function: StaticString = #function,
  fileID: StaticString = #fileID,
  line: UInt = #line,
  column: UInt = #column
) throws -> [T] where T: SyntaxProtocol {
  try syntaxes.map { syntax in
    try syntax.autoFormattedForHDXLProject(
      initialIndentation: initialIndentation,
      viewMode: viewMode,
      function: function,
      fileID: fileID,
      line: line,
      column: column
    )
  }
}

extension SyntaxProtocol {
  
  @inlinable
  public func autoFormattedForHDXLProject(
    initialIndentation: Trivia = Trivia(),
    viewMode: SyntaxTreeViewMode = .sourceAccurate,
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> Self {
    return self
//    let result = formatted(
//      using: .hdxlProjectFormatting(
//        initialIndentation: initialIndentation,
//        viewMode: viewMode
//      )
//    )
//    
//    guard let sameType = result as? Self else {
//      throw MacroExpansionFailure(
//        explanation: "autoformatting-failure",
//        function: function,
//        fileID: fileID,
//        line: line,
//        column: column
//      )
//    }
//    
//    return sameType
  }
  
}
