import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

public enum DiagnosticPositionStrategy : @unchecked Sendable {
  case explicit(AbstractSourceLocation)
  case automatic(AbstractSourceLocationStrategy)
  
  public static let standard = Self.automatic(.standard)
}

