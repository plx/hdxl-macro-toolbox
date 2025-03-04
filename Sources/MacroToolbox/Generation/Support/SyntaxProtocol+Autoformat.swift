import SwiftSyntax
import SwiftBasicFormat

/// Returns an automatically-formatted equivalent of the provided syntax node.
///
/// This function applies project-specific formatting rules to a syntax node.
///
/// - Parameters:
///   - syntax: The syntax node to format
///   - initialIndentation: The initial indentation to apply
///   - viewMode: The view mode to use when formatting
///   - function: The calling function (automatically provided)
///   - fileID: The calling file (automatically provided)
///   - line: The calling line (automatically provided)
///   - column: The calling column (automatically provided)
/// - Returns: The formatted equivalent of the input syntax node
/// - Throws: If formatting fails
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

/// Returns automatically-formatted equivalents of the provided sequence of syntax nodes.
///
/// This function applies project-specific formatting rules to each syntax node in the sequence.
///
/// - Parameters:
///   - syntaxes: The sequence of syntax nodes to format
///   - initialIndentation: The initial indentation to apply to each node
///   - viewMode: The view mode to use when formatting
///   - function: The calling function (automatically provided)
///   - fileID: The calling file (automatically provided)
///   - line: The calling line (automatically provided)
///   - column: The calling column (automatically provided)
/// - Returns: An array containing the formatted equivalents of the input syntax nodes
/// - Throws: If formatting any node fails
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
  
  /// Returns a formatted version of this syntax node according to project formatting rules.
  ///
  /// Currently this method is a placeholder and returns the syntax node unchanged.
  /// Future implementations may apply actual formatting rules.
  ///
  /// - Parameters:
  ///   - initialIndentation: The initial indentation to apply
  ///   - viewMode: The view mode to use when formatting
  ///   - function: The calling function (automatically provided)
  ///   - fileID: The calling file (automatically provided)
  ///   - line: The calling line (automatically provided)
  ///   - column: The calling column (automatically provided)
  /// - Returns: The formatted syntax node (currently returns self unchanged)
  /// - Throws: If formatting fails (not currently applicable)
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
