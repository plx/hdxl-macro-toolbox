import MacroToolboxSyntax
import SwiftSyntax

let source: String = "Int"
_ = try SyntaxConstruction.storedProperty(name: .identifier("value"), type: source)
