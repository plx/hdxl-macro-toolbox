import SwiftDiagnostics

/// Types conforming to ``MacroDiagnosticDomain`` gain access to a streamlined API for reporting macro diagnostics.
///
/// Note that in addition to direct adoption by macros, this protocol may also be adopted by subcomponents, e.g. "submacro"-like entities.
public protocol MacroDiagnosticDomain {
  
  static var diagnosticDomainIdentifier: String { get }
  
}

extension MacroDiagnosticDomain {
  
  @inlinable
  public static var diagnosticDomainIdentifier: String { String(reflecting: self) }
  
  @inlinable
  public static func messageID(id identifier: String) -> MessageID {
    MessageID(
      domain: diagnosticDomainIdentifier,
      id: identifier
    )
  }
  
}
