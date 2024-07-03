import SwiftSyntax
import SwiftDiagnostics

extension MacroDiagnosticDomain {
  
  @inlinable
  public static func diagnosticError(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> DiagnosticsError {
    DiagnosticsError(
      diagnostics: [
        _diagnosticError(
          for: node,
          at: position,
          explanation: explanation,
          messageID: messageID,
          highlights: highlights,
          notes: notes,
          fixIts: fixIts
        )
      ]
    )
  }
  
  @inlinable
  public static func diagnosticWarning(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> DiagnosticsError {
    DiagnosticsError(
      diagnostics: [
        _diagnosticWarning(
          for: node,
          at: position,
          explanation: explanation,
          messageID: messageID,
          highlights: highlights,
          notes: notes,
          fixIts: fixIts
        )
      ]
    )
  }
  
  @inlinable
  public static func diagnosticNote(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> DiagnosticsError {
    DiagnosticsError(
      diagnostics: [
        _diagnosticNote(
          for: node,
          at: position,
          explanation: explanation,
          messageID: messageID,
          highlights: highlights,
          notes: notes,
          fixIts: fixIts
        )
      ]
    )
  }
  
  @inlinable
  public static func diagnosticRemark(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> DiagnosticsError {
    DiagnosticsError(
      diagnostics: [
        _diagnosticRemark(
          for: node,
          at: position,
          explanation: explanation,
          messageID: messageID,
          highlights: highlights,
          notes: notes,
          fixIts: fixIts
        )
      ]
    )
  }
  
}

extension MacroDiagnosticDomain {
  
  @inlinable
  public static func diagnostic(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    severity: DiagnosticSeverity,
    messageID messageIdentifier: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> Diagnostic {
    Diagnostic(
      node: node,
      message: HDXLMacroDiagnostic(
        message: explanation,
        severity: severity,
        diagnosticID: messageID(
          id: messageIdentifier
        )
      ),
      highlights: highlights,
      notes: notes,
      fixIts: fixIts
    )
  }
  
  @inlinable
  package static func _diagnosticError(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID messageIdentifier: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> Diagnostic {
    diagnostic(
      for: node,
      at: position,
      explanation: explanation,
      severity: .error,
      messageID: messageIdentifier,
      highlights: highlights,
      notes: notes,
      fixIts: fixIts
    )
  }
  
  @inlinable
  package static func _diagnosticWarning(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID messageIdentifier: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> Diagnostic {
    diagnostic(
      for: node,
      at: position,
      explanation: explanation,
      severity: .warning,
      messageID: messageIdentifier,
      highlights: highlights,
      notes: notes,
      fixIts: fixIts
    )
  }
  
  @inlinable
  package static func _diagnosticNote(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID messageIdentifier: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> Diagnostic {
    diagnostic(
      for: node,
      at: position,
      explanation: explanation,
      severity: .note,
      messageID: messageIdentifier,
      highlights: highlights,
      notes: notes,
      fixIts: fixIts
    )
  }
  
  @inlinable
  package static func _diagnosticRemark(
    for node: some SyntaxProtocol,
    at position: AbsolutePosition? = nil,
    explanation: String,
    messageID messageIdentifier: String = .standardMessageID,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) -> Diagnostic {
    diagnostic(
      for: node,
      at: position,
      explanation: explanation,
      severity: .remark,
      messageID: messageIdentifier,
      highlights: highlights,
      notes: notes,
      fixIts: fixIts
    )
  }
  
}

