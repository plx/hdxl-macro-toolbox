import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

/// ``AccessorMacroContextProtocol`` refines``AttachedMacroContextProtocol`` and specializes it for accessor macros.
public protocol AccessorMacroContextProtocol<Declaration, ExpansionContext> : AttachedMacroContextProtocol { }
