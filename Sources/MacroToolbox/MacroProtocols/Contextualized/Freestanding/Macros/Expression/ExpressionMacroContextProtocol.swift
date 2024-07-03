import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


/// ``ExpressionMacroContextProtocol`` refines ``FreestandingMacroContextProtocol`` and specializes it for use with expression macros.
public protocol ExpressionMacroContextProtocol<ExpansionContext> : FreestandingMacroContextProtocol { }
