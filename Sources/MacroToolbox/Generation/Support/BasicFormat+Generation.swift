import SwiftBasicFormat
import SwiftSyntax

extension BasicFormat {
  
  public static func hdxlProjectFormatting(
    initialIndentation: Trivia? = nil,
    viewMode: SyntaxTreeViewMode = .sourceAccurate
  ) -> BasicFormat {
    BasicFormat(
      indentationWidth: .spaces(2),
      initialIndentation: initialIndentation ?? Trivia(),
      viewMode: viewMode
    )
  }
  
}
