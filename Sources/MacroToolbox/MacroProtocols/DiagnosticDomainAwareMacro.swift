import SwiftSyntaxMacros
import SwiftDiagnostics

/// ``DiagnosticDomainAwareMacro`` indicates that a macro has an associated "diagnostic domain identifier" (e.g. as used with `SwiftDiagnostics`).
///
/// - note: Within `MacroToolbox` the default model is a 1:1 pairing between macros and diagnostic domains, which is implemented by default.
public protocol DiagnosticDomainAwareMacro {
  
  /// This macro's diagnostic-domain identifier. Defaults-to the name of the type implementing the macro.
  static var diagnosticDomainIdentifier: String { get }
  
}

extension DiagnosticDomainAwareMacro {
  
  @inlinable
  public static var diagnosticDomainIdentifier: String { String(reflecting: self) }
  
}
