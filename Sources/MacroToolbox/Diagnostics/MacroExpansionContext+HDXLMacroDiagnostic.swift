import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

extension MacroExpansionContext {

  @inlinable
  public func diagnose(possibleDiagnostic: Diagnostic?) {
    guard let diagnostic = possibleDiagnostic else { return }
    diagnose(diagnostic)
  }
  
  @inlinable
  public func diagnose(diagnostics: some Sequence<Diagnostic>) {
    for diagnostic in diagnostics {
      diagnose(diagnostic)
    }
  }
  
  @inlinable
  public func diagnose(possibleDiagnostics: (some Sequence<Diagnostic>)?) {
    guard let possibleDiagnostics else { return }
    diagnose(possibleDiagnostics: possibleDiagnostics)
  }

}

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

public enum DiagnosticPositionStrategy : @unchecked Sendable {
  case explicit(AbstractSourceLocation)
  case automatic(AbstractSourceLocationStrategy)
  
  public static let standard = Self.automatic(.standard)
}



extension MacroExpansionContext {
  
  @inlinable
  public func abstractSourceLocation(
    attributionNode node: some SyntaxProtocol,
    position: DiagnosticPositionStrategy
  ) -> AbstractSourceLocation? {
    switch position {
    case .explicit(let abstractSourceLocation):
      abstractSourceLocation
    case .automatic(let abstractSourceLocationStrategy):
      location(
        of: node,
        at: abstractSourceLocationStrategy.positionInSyntaxNode,
        filePathMode: abstractSourceLocationStrategy.filePathMode
      )
    }
  }

  @inlinable
  public func recordDiagnostic(
    attributionNode node: any SyntaxProtocol,
    subjectNode: (any SyntaxProtocol)? = nil,
    severity: DiagnosticSeverity,
    domainID domainIdentifier: String,
    messageID messageIdentifier: String,
    explanation: String,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) {
    diagnose(
      Diagnostic(
        node: node,
        position: subjectNode?.positionAfterSkippingLeadingTrivia, // TODO: more-granular location reporting
        message: HDXLMacroDiagnostic(
          message: explanation,
          severity: severity,
          diagnosticID: MessageID(
            domain: domainIdentifier,
            id: messageIdentifier
          )
        ),
        highlights: highlights,
        notes: notes,
        fixIts: fixIts
      )
    )
  }

}
