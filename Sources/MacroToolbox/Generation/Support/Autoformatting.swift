import SwiftSyntax
import SwiftSyntaxMacros
import SwiftBasicFormat

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
