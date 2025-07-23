import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

/// ``BodyMacroContextProtocol`` refines``AttachedMacroContextProtocol`` and specializes it for body macros.
public protocol BodyMacroContextProtocol<Declaration, ExpansionContext> : AttachedMacroContextProtocol where Declaration: WithOptionalCodeBlockSyntax { }
