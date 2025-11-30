import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


// MARK: - Automatic Recording

extension MacroContextProtocol {
  
  /// Internal utility to intercept a thrown error, record an error diagnostic, and then re-throw the error (if necessary).
  ///
  /// - Parameters:
  ///   - messageIdentifier: The (arbitrary) string-identifier to use as the diagnostic's message-identifier (only evaluated *if* an error is thrown).
  ///   - explanation: A freeform, developer-facing description of the operation being performed (only evaluated *if* an error is thrown).
  ///   - primaryNode: The node to-which this diagnostic should be attributed; if `nil`, `primarySyntaxForDiagnostics` will be used.
  ///   - subject: The node-to which this diagnostic should be attributed; if `nil`, `primarySyntaxForDiagnostics` will be used.
  ///   - highlights: If supplied, will be used for as the recorded `Diagnostic`'s `highlights`; defaults to `nil`.
  ///   - notes: If supplied, will be used for as the recorded `Diagnostic`'s `notes`; defaults to `nil`.
  ///   - fixIts: If supplied, will be used for as the recorded `Diagnostic`'s `fixIts`; defaults to `nil`.
  ///   - closure: The (possibly-throwing) operation to perform.
  ///
  /// - Returns: The result of `closure()` (if no error is thrown).
  /// - Throws: Will re-throw any error thrown by `closure()`
  ///
  /// - Warning: this is public to make available as a building-block, but *generally* this isn't something you want to use directly.
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
  ) rethrows -> R {
    do {
      return try closure()
    }
    catch let error {
      recordDiagnostic(
        severity: .error,
        messageIdentifier: messageIdentifier(),
        explanation: "\(explanation()) failed w/error: \(error)",
        attributionNode: attributionNode() ?? syntaxNodeForAttribution,
        subjectNode: subjectNode() ?? syntaxNodeForPositioning,
        highlights: highlights(),
        notes: notes(),
        fixIts: fixIts()
      )

      throw error
    }
  }
  
}
