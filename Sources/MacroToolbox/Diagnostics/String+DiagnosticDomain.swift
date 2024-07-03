import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics

extension String {
  
  @usableFromInline
  package static let diagnosticDomainID: String = "hdxlsimdsupportmacros"
  
  @usableFromInline
  package static let standardMessageID: String = "diagnostic"
  
}
