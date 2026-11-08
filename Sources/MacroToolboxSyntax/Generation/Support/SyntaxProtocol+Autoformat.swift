import MacroToolboxModels
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
  /// Format a copy using the supplied formatter, rejecting recovered syntax and any changed
  /// concrete kind. The input node remains unchanged. This is formatting, not semantic validation.
  @inlinable
  public func formattedPreservingSyntaxKind(using formatter: BasicFormat) throws -> Self {
    _ = try validated()
    let result = formatted(using: formatter)
    guard result.kind == Syntax(self).kind, let sameType = result.as(Self.self) else {
      throw SyntaxFormattingFailure.changedNodeKind(expected: Syntax(self).kind, actual: result.kind)
    }
    return try sameType.validated()
  }

  /// Explicitly format generated output with SwiftBasicFormat and two-space indentation.
  /// Retains comments and the concrete node kind, validates before/after, and never mutates input.
  @inlinable
  public func autoFormattedForHDXLProject(
    initialIndentation: Trivia = Trivia(),
    viewMode: SyntaxTreeViewMode = .sourceAccurate,
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> Self {
    try formattedPreservingSyntaxKind(using: .hdxlProjectFormatting(
      initialIndentation: initialIndentation,
      viewMode: viewMode
    ))
  }
  
}
