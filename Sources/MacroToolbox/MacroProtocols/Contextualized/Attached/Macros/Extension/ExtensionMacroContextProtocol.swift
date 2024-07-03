import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


/// ``ExtensionMacroContextProtocol`` refines``AttachedMacroContextProtocol`` and specializes it for extension macros.
public protocol ExtensionMacroContextProtocol<Declaration, ExpansionContext, ExtendedType> : AttachedMacroContextProtocol
where Declaration: DeclGroupSyntax {
  
  /// The concrete syntax-type of the type-declaration  to-which this macro was attached.
  associatedtype ExtendedType: TypeSyntaxProtocol
  
  var extendedType: ExtendedType { get }
  var conformedProtocols: [TypeSyntax] { get }
}

