import SwiftDiagnostics

public struct HDXLMacroDiagnostic : DiagnosticMessage {
  
  public let message: String
  public let severity: DiagnosticSeverity
  public let diagnosticID: MessageID
  
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
