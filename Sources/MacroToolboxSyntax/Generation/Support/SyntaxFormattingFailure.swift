import SwiftSyntax

/// Formatting must preserve the original concrete syntax kind, including under type erasure.
public enum SyntaxFormattingFailure: Error {
  case changedNodeKind(expected: SyntaxKind, actual: SyntaxKind)
}
