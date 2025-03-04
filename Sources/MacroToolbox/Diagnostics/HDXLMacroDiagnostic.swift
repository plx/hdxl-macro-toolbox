import SwiftDiagnostics

/// A structured diagnostic message for use in macro expansions.
///
/// This struct encapsulates diagnostic information including the message text,
/// severity level, and a unique message identifier.
public struct HDXLMacroDiagnostic : DiagnosticMessage {
  
  /// The diagnostic message text to display to the user.
  public let message: String
  
  /// The severity level of the diagnostic.
  public let severity: DiagnosticSeverity
  
  /// A unique identifier for this type of diagnostic message.
  public let diagnosticID: MessageID
  
  /// Creates a new macro diagnostic with the specified properties.
  ///
  /// - Parameters:
  ///   - message: The diagnostic message text
  ///   - severity: The severity level of the diagnostic
  ///   - diagnosticID: A unique identifier for this type of diagnostic
  @inlinable
  public init(
    message: String,
    severity: DiagnosticSeverity,
    diagnosticID: MessageID
  ) {
    self.message = message
    self.severity = severity
    self.diagnosticID = diagnosticID
  }
    
}

extension HDXLMacroDiagnostic : Sendable { }
extension HDXLMacroDiagnostic : Equatable { }
extension HDXLMacroDiagnostic : Hashable { }

extension HDXLMacroDiagnostic : CustomStringConvertible {
  
  @inlinable
  public var description: String {
    "\(severity): \"\(message)\""
  }
  
}

extension HDXLMacroDiagnostic : CustomDebugStringConvertible {
  
  @inlinable
  public var debugDescription: String {
    String(
      forConstructorOf: Self.self,
      arguments: (
        ("message", message),
        ("severity", severity),
        ("diagnosticID", diagnosticID)
      )
    )
  }
  
}

extension HDXLMacroDiagnostic {

  /// Creates an error-level diagnostic message.
  ///
  /// - Parameters:
  ///   - message: The diagnostic message text
  ///   - diagnosticID: A unique identifier for this type of diagnostic
  /// - Returns: A new diagnostic with error severity
  @inlinable
  public static func error(
    _ message: String,
    diagnosticID: MessageID
  ) -> Self {
    Self(
      message: message,
      severity: .error,
      diagnosticID: diagnosticID
    )
  }
  
  /// Creates a warning-level diagnostic message.
  ///
  /// - Parameters:
  ///   - message: The diagnostic message text
  ///   - diagnosticID: A unique identifier for this type of diagnostic
  /// - Returns: A new diagnostic with warning severity
  @inlinable
  public static func warning(
    _ message: String,
    diagnosticID: MessageID
  ) -> Self {
    Self(
      message: message,
      severity: .warning,
      diagnosticID: diagnosticID
    )
  }
  
  /// Creates a note-level diagnostic message.
  ///
  /// - Parameters:
  ///   - message: The diagnostic message text
  ///   - diagnosticID: A unique identifier for this type of diagnostic
  /// - Returns: A new diagnostic with note severity
  @inlinable
  public static func note(
    _ message: String,
    diagnosticID: MessageID
  ) -> Self {
    Self(
      message: message,
      severity: .note,
      diagnosticID: diagnosticID
    )
  }
  
  /// Creates a remark-level diagnostic message.
  ///
  /// - Parameters:
  ///   - message: The diagnostic message text
  ///   - diagnosticID: A unique identifier for this type of diagnostic
  /// - Returns: A new diagnostic with remark severity
  @inlinable
  public static func remark(
    _ message: String,
    diagnosticID: MessageID
  ) -> Self {
    Self(
      message: message,
      severity: .remark,
      diagnosticID: diagnosticID
    )
  }

}
