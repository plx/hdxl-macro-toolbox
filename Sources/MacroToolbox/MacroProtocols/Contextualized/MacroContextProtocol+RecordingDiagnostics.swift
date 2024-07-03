import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

extension MacroContextProtocol {
  
  /// Records a diagnostic (of arbitrary `severity`) with indicated `explanation` and `messageIdentifier`.
  ///
  /// - Parameters:
  ///   - severity: The diagnostic's severity.
  ///   - messageIdentifier: The (arbitrary) string identifier for this diagnostic.
  ///   - explanation: A freeform, developer-facing explanation of the diagnostic.
  ///   - attributionNode: The node to-which this diagnostic should be attributed; if `nil`, `primarySyntaxForDiagnostics` will be used.
  ///   - subjectNode: The node-to which this diagnostic should be attributed; if `nil`, `primarySyntaxForDiagnostics` will be used.
  ///   - highlights: If supplied, will be used for as the recorded `Diagnostic`'s `highlights`; defaults to `nil`.
  ///   - notes: If supplied, will be used for as the recorded `Diagnostic`'s `notes`; defaults to `nil`.
  ///   - fixIts: If supplied, will be used for as the recorded `Diagnostic`'s `fixIts`; defaults to `nil`.
  ///
  /// - seealso: ``recordError(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  /// - seealso: ``recordWarning(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  /// - seealso: ``recordNote(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  /// - seealso: ``recordRemark(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
 ///
  @inlinable
  public func recordDiagnostic(
    severity: DiagnosticSeverity,
    messageIdentifier: String,
    explanation: String,
    attributionNode: (any SyntaxProtocol)? = nil,
    subjectNode: (any SyntaxProtocol)? = nil,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) {
    expansionContext.recordDiagnostic(
      attributionNode: attributionNode ?? syntaxNodeForAttribution,
      subjectNode: subjectNode,
      severity: severity,
      domainID: diagnosticDomainIdentifier,
      messageID: messageIdentifier,
      explanation: explanation,
      highlights: highlights,
      notes: notes,
      fixIts: fixIts
    )
  }
  
  /// Records a `.error`-severity diagnostic with indicated `explanation` and `messageIdentifier`.
  ///
  /// - Parameters:
  ///   - messageIdentifier: The (arbitrary) string identifier for this diagnostic.
  ///   - explanation: A freeform, developer-facing explanation of the diagnostic.
  ///   - attributionNode: The node to-which this diagnostic should be attributed; if `nil`, `primarySyntaxForDiagnostics` will be used.
  ///   - subjectNode: The node-to which this diagnostic should be attributed; if `nil`, `primarySyntaxForDiagnostics` will be used.
  ///   - highlights: If supplied, will be used for as the recorded `Diagnostic`'s `highlights`; defaults to `nil`.
  ///   - notes: If supplied, will be used for as the recorded `Diagnostic`'s `notes`; defaults to `nil`.
  ///   - fixIts: If supplied, will be used for as the recorded `Diagnostic`'s `fixIts`; defaults to `nil`.
  ///
  /// - seealso: ``recordDiagnostic(severity:messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  /// - seealso: ``recordWarning(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  /// - seealso: ``recordNote(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  /// - seealso: ``recordRemark(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  ///
  @inlinable
  public func recordError(
    messageIdentifier: String,
    explanation: String,
    attributionNode: (any SyntaxProtocol)? = nil,
    subjectNode: (any SyntaxProtocol)? = nil,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) {
    recordDiagnostic(
      severity: .error,
      messageIdentifier: messageIdentifier,
      explanation: explanation,
      attributionNode: attributionNode,
      subjectNode: subjectNode,
      highlights: highlights,
      notes: notes,
      fixIts: fixIts
    )
  }

  /// Records a `.warning`-severity diagnostic with indicated `explanation` and `messageIdentifier`.
  ///
  /// - Parameters:
  ///   - messageIdentifier: The (arbitrary) string identifier for this diagnostic.
  ///   - explanation: A freeform, developer-facing explanation of the diagnostic.
  ///   - attributionNode: The node to-which this diagnostic should be attributed; if `nil`, `primarySyntaxForDiagnostics` will be used.
  ///   - subjectNode: The node-to which this diagnostic should be attributed; if `nil`, `primarySyntaxForDiagnostics` will be used.
  ///   - highlights: If supplied, will be used for as the recorded `Diagnostic`'s `highlights`; defaults to `nil`.
  ///   - notes: If supplied, will be used for as the recorded `Diagnostic`'s `notes`; defaults to `nil`.
  ///   - fixIts: If supplied, will be used for as the recorded `Diagnostic`'s `fixIts`; defaults to `nil`.
  ///
  /// - seealso: ``recordDiagnostic(severity:messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  /// - seealso: ``recordError(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  /// - seealso: ``recordNote(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  /// - seealso: ``recordRemark(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  ///
  @inlinable
  public func recordWarning(
    messageIdentifier: String,
    explanation: String,
    attributionNode: (any SyntaxProtocol)? = nil,
    subjectNode: (any SyntaxProtocol)? = nil,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) {
    recordDiagnostic(
      severity: .warning,
      messageIdentifier: messageIdentifier,
      explanation: explanation,
      attributionNode: attributionNode,
      subjectNode: subjectNode,
      highlights: highlights,
      notes: notes,
      fixIts: fixIts
    )
  }

  /// Records a `.note`-severity diagnostic with indicated `explanation` and `messageIdentifier`.
  ///
  /// - Parameters:
  ///   - messageIdentifier: The (arbitrary) string identifier for this diagnostic.
  ///   - explanation: A freeform, developer-facing explanation of the diagnostic.
  ///   - attributionNode: The node to-which this diagnostic should be attributed; if `nil`, `primarySyntaxForDiagnostics` will be used.
  ///   - subjectNode: The node-to which this diagnostic should be attributed; if `nil`, `primarySyntaxForDiagnostics` will be used.
  ///   - highlights: If supplied, will be used for as the recorded `Diagnostic`'s `highlights`; defaults to `nil`.
  ///   - notes: If supplied, will be used for as the recorded `Diagnostic`'s `notes`; defaults to `nil`.
  ///   - fixIts: If supplied, will be used for as the recorded `Diagnostic`'s `fixIts`; defaults to `nil`.
  ///
  /// - seealso: ``recordDiagnostic(severity:messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  /// - seealso: ``recordError(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  /// - seealso: ``recordWarning(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  /// - seealso: ``recordRemark(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  ///
 @inlinable
  public func recordNote(
    messageIdentifier: String,
    explanation: String,
    attributionNode: (any SyntaxProtocol)? = nil,
    subjectNode: (any SyntaxProtocol)? = nil,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) {
    recordDiagnostic(
      severity: .note,
      messageIdentifier: messageIdentifier,
      explanation: explanation,
      attributionNode: attributionNode,
      subjectNode: subjectNode,
      highlights: highlights,
      notes: notes,
      fixIts: fixIts
    )
  }

  /// Records a `.remark`-severity diagnostic with indicated `explanation` and `messageIdentifier`.
  ///
  /// - Parameters:
  ///   - messageIdentifier: The (arbitrary) string identifier for this diagnostic.
  ///   - explanation: A freeform, developer-facing explanation of the diagnostic.
  ///   - attributionNode: The node to-which this diagnostic should be attributed; if `nil`, `primarySyntaxForDiagnostics` will be used.
  ///   - subjectNode: The node-to which this diagnostic should be attributed; if `nil`, `primarySyntaxForDiagnostics` will be used.
  ///   - highlights: If supplied, will be used for as the recorded `Diagnostic`'s `highlights`; defaults to `nil`.
  ///   - notes: If supplied, will be used for as the recorded `Diagnostic`'s `notes`; defaults to `nil`.
  ///   - fixIts: If supplied, will be used for as the recorded `Diagnostic`'s `fixIts`; defaults to `nil`.
  ///
  /// - seealso: ``recordDiagnostic(severity:messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  /// - seealso: ``recordError(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  /// - seealso: ``recordWarning(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  /// - seealso: ``recordNote(messageIdentifier:explanation:attributionNode:subjectNode:highlights:notes:fixIts:)``
  ///
  @inlinable
  public func recordRemark(
    messageIdentifier: String,
    explanation: String,
    attributionNode: (any SyntaxProtocol)? = nil,
    subjectNode: (any SyntaxProtocol)? = nil,
    highlights: [Syntax]? = nil,
    notes: [Note] = [],
    fixIts: [FixIt] = []
  ) {
    recordDiagnostic(
      severity: .remark,
      messageIdentifier: messageIdentifier,
      explanation: explanation,
      attributionNode: attributionNode,
      subjectNode: subjectNode,
      highlights: highlights,
      notes: notes,
      fixIts: fixIts
    )
  }

}
