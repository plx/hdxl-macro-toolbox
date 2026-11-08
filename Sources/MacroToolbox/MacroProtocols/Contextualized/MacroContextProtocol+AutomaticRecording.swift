import MacroToolboxModels
import MacroToolboxSyntax
import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

extension MacroContextProtocol {
  /// Attach diagnostic context without emitting. The outer macro engine or an explicit
  /// recovering bridge boundary owns emission. Nested deferred diagnostics pass through intact.
  @inlinable
  public func withDiagnosticContextForRequiredOperation<R>(
    messageIdentifier: @autoclosure () -> String,
    explanation: @autoclosure () -> String,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)?,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    _ closure: () throws -> R
  ) throws -> R {
    do { return try closure() }
    catch {
      if let deferred = deferredMacroError(in: error) { throw deferred }
      if let diagnostics = deferredMacroDiagnostics(in: error) {
        throw DiagnosticsError(diagnostics: diagnostics)
      }
      throw DiagnosticsError(diagnostics: [Diagnostic(
        node: Syntax(fromProtocol: attributionNode() ?? syntaxNodeForAttribution),
        position: (subjectNode() ?? syntaxNodeForPositioning).positionAfterSkippingLeadingTrivia,
        message: HDXLMacroDiagnostic(
          message: "\(explanation()) failed: \(error)", severity: .error,
          diagnosticID: MessageID(domain: diagnosticDomainIdentifier, id: messageIdentifier())
        ),
        highlights: highlights(), notes: notes(), fixIts: fixIts()
      )])
    }
  }

  /// Compatibility spelling. This now defers emission, and is `throws` rather than `rethrows`.
  /// Migrate to `withDiagnosticContextForRequiredOperation` and let the outer boundary emit.
  @available(*, deprecated, renamed: "withDiagnosticContextForRequiredOperation")
  @inlinable
  public func withAutomaticRecordingForRequiredOperation<R>(
    messageIdentifier: @autoclosure () -> String,
    explanation: @autoclosure () -> String,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)?,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    _ closure: () throws -> R
  ) throws -> R {
    try withDiagnosticContextForRequiredOperation(
      messageIdentifier: messageIdentifier(), explanation: explanation(),
      attributionNode: attributionNode(), subjectNode: subjectNode(), highlights: highlights(),
      notes: notes(), fixIts: fixIts(), closure
    )
  }
}
