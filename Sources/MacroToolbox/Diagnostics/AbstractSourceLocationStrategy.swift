import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

public struct AbstractSourceLocationStrategy: @unchecked Sendable {
  public let positionInSyntaxNode: PositionInSyntaxNode
  public let filePathMode: SourceLocationFilePathMode
  
  public init(positionInSyntaxNode: PositionInSyntaxNode, filePathMode: SourceLocationFilePathMode) {
    self.positionInSyntaxNode = positionInSyntaxNode
    self.filePathMode = filePathMode
  }
  
  public static let standard = Self(
    positionInSyntaxNode: .afterLeadingTrivia,
    filePathMode: .filePath
  )
}
