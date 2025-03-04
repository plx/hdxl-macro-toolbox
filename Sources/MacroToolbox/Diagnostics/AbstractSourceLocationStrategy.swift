import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

/// A strategy for determining source locations in diagnostic messages.
///
/// This struct provides configuration for how source locations should be determined
/// when generating diagnostic messages, including positioning within syntax nodes
/// and file path representation.
public struct AbstractSourceLocationStrategy: @unchecked Sendable {
  /// Specifies where in a syntax node the diagnostic position should be located.
  public let positionInSyntaxNode: PositionInSyntaxNode
  
  /// Specifies how file paths should be represented in source locations.
  public let filePathMode: SourceLocationFilePathMode
  
  /// Creates a new source location strategy with the specified configuration.
  ///
  /// - Parameters:
  ///   - positionInSyntaxNode: Where in a syntax node the diagnostic position should be located
  ///   - filePathMode: How file paths should be represented in source locations
  public init(positionInSyntaxNode: PositionInSyntaxNode, filePathMode: SourceLocationFilePathMode) {
    self.positionInSyntaxNode = positionInSyntaxNode
    self.filePathMode = filePathMode
  }
  
  /// A standard source location strategy that positions diagnostics after leading trivia and uses file paths.
  public static let standard = Self(
    positionInSyntaxNode: .afterLeadingTrivia,
    filePathMode: .filePath
  )
}
