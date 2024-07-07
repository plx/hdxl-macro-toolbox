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
    // NOTE: this doesn't work the way I want it to,
    // b/c the built-in formatter isn't guaranteed
    // to give you back the same syntax-node type(s) you
    // started with.
    //
    // Would like to get something along these lines working eventually,
    // b/c without it the larger macro outputs become human-unreadable.
    //
    // let result = formatted(
    //   using: .hdxlProjectFormatting(
    //     initialIndentation: initialIndentation,
    //     viewMode: viewMode
    //   )
    // )
    //
    // guard let sameType = result as? Self else {
    //   throw MacroExpansionFailure(
    //     explanation: "autoformatting-failure",
    //     function: function,
    //     fileID: fileID,
    //     line: line,
    //     column: column
    //   )
    // }
    //
    // return sameType
  }
  
}
