import MacroToolboxSyntax
import SwiftSyntax

let type = TypeSyntax(IdentifierTypeSyntax(name: .identifier("Int")))
_ = try SyntaxConstruction.storedProperty(name: .identifier("value"), type: type)
