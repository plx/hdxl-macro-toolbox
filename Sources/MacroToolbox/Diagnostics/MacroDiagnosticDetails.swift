import MacroToolboxSyntax
import SwiftDiagnostics
import SwiftSyntax

/// A host adapter's error already carrying typed source/diagnostic context. Requirement wrappers
/// must preserve it for the adapter's terminal boundary instead of replacing that context.
public protocol DeferredMacroError: Error {}

public func deferredMacroError(in error: any Error) -> (any DeferredMacroError)? {
  if let error = error as? any DeferredMacroError { return error }
  if let error = error as? MacroExpansionFailure {
    for cause in error.suberrors {
      if let deferred = deferredMacroError(in: cause) { return deferred }
    }
  }
  return nil
}

/// Caller-owned diagnostic presentation. Fix-its are accepted only as explicit, already-proven
/// replacements; this type does not guess edits or change their original source nodes.
public struct MacroDiagnosticDetails: Sendable {
  public var message: String
  public var severity: DiagnosticSeverity
  public var diagnosticID: MessageID
  public var position: AbsolutePosition?
  public var highlights: [Syntax]?
  public var notes: [Note]
  public var fixIts: [FixIt]

  public init(
    message: String, domain: String, messageID: String, severity: DiagnosticSeverity = .error,
    position: AbsolutePosition? = nil, highlights: [Syntax]? = nil,
    notes: [Note] = [], fixIts: [FixIt] = []
  ) {
    self.message = message; self.severity = severity
    diagnosticID = MessageID(domain: domain, id: messageID)
    self.position = position; self.highlights = highlights; self.notes = notes; self.fixIts = fixIts
  }

  public func diagnostic(at node: some SyntaxProtocol, additionalNotes: [Note] = []) -> Diagnostic {
    Diagnostic(node: node, position: position,
      message: HDXLMacroDiagnostic(message: message, severity: severity, diagnosticID: diagnosticID),
      highlights: highlights, notes: notes + additionalNotes, fixIts: fixIts)
  }
}

/// Recover an existing deferred diagnostic even if a legacy requirement encapsulated it.
/// This inspects error metadata only and never emits a diagnostic.
public func deferredMacroDiagnostics(in error: any Error) -> [Diagnostic]? {
  if let error = error as? DiagnosticsError { return error.diagnostics }
  if let error = error as? MacroExpansionFailure {
    for cause in error.suberrors {
      if let diagnostics = deferredMacroDiagnostics(in: cause) { return diagnostics }
    }
  }
  return nil
}
