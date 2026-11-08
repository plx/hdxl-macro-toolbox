import MacroToolboxModels
import MacroToolboxSyntax
import MacroToolboxTransflection
import SwiftSyntax

let source = try SyntaxSourceFragment.parse("MacroToolboxModels.VisibilityLevel.public", as: ExprSyntax.self)
let value = try TransflectionMacroBridge.decode(source, as: VisibilityLevel.self)
precondition(value == .public)
print("BridgeOnly passed")
