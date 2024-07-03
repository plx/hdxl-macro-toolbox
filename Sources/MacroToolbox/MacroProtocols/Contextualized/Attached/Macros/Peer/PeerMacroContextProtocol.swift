import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

/// ``PeerMacroContextProtocol`` refines``AttachedMacroContextProtocol`` and specializes it for peer macros.
public protocol PeerMacroContextProtocol<Declaration, ExpansionContext> : AttachedMacroContextProtocol { }
