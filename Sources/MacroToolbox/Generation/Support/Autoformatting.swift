import SwiftSyntax
import SwiftSyntaxMacros
import SwiftBasicFormat

/// Executes a closure and automatically reformats its syntax result.
///
/// This function provides a convenient way to generate formatted Swift syntax nodes.
/// The closure can generate any syntax node, which will then be automatically
/// formatted according to the specified parameters.
///
/// - Parameters:
///   - initialIndentation: The initial indentation to apply to the formatted syntax
///   - viewMode: The view mode to use when formatting the syntax
///   - function: The calling function (automatically provided)
///   - fileID: The calling file (automatically provided)
///   - line: The calling line (automatically provided)
///   - column: The calling column (automatically provided)
///   - closure: A closure that produces a syntax node to be formatted
/// - Returns: The formatted equivalent of the syntax node produced by the closure
/// - Throws: Rethrows any errors from the closure
@inlinable
public func withAutomaticReformatting<T>(
  initialIndentation: Trivia = Trivia(),
  viewMode: SyntaxTreeViewMode = .sourceAccurate,
  function: StaticString = #function,
  fileID: StaticString = #fileID,
  line: UInt = #line,
  column: UInt = #column,
  _ closure: () throws -> T
) throws -> T where T: SyntaxProtocol {
  try autoformattedEquivalent(
    of: try closure(),
    initialIndentation: initialIndentation,
    viewMode: viewMode,
    function: function,
    fileID: fileID,
    line: line,
    column: column
  )
}

/// Executes a closure that returns a sequence of syntax nodes and automatically reformats each one.
///
/// This overload works with sequences of syntax nodes, formatting each node in the sequence
/// and returning them as an array.
///
/// - Parameters:
///   - initialIndentation: The initial indentation to apply to the formatted syntax
///   - viewMode: The view mode to use when formatting the syntax
///   - function: The calling function (automatically provided)
///   - fileID: The calling file (automatically provided)
///   - line: The calling line (automatically provided)
///   - column: The calling column (automatically provided)
///   - closure: A closure that produces a sequence of syntax nodes to be formatted
/// - Returns: An array containing the formatted equivalents of the syntax nodes
/// - Throws: Rethrows any errors from the closure
@inlinable
public func withAutomaticReformatting<T>(
  initialIndentation: Trivia = Trivia(),
  viewMode: SyntaxTreeViewMode = .sourceAccurate,
  function: StaticString = #function,
  fileID: StaticString = #fileID,
  line: UInt = #line,
  column: UInt = #column,
  _ closure: () throws -> some Sequence<T>
) throws -> [T] where T: SyntaxProtocol {
  try autoformattedEquivalents(
    of: try closure(),
    initialIndentation: initialIndentation,
    viewMode: viewMode,
    function: function,
    fileID: fileID,
    line: line,
    column: column
  )
}
