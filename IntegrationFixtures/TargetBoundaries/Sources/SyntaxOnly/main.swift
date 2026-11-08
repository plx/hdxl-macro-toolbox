import MacroToolboxModels
import MacroToolboxSyntax
import SwiftSyntax

let declaration = try StructDeclSyntax.onlyParsed(from: "public struct Example { var value: Int }")
precondition(declaration.modifiers.visibilityLevel == .public)
precondition(declaration.memberBlock.members.count == 1)
let property = try StoredProperty(name: "count", typeName: "Int", visibility: .public, initialValueExpression: "0").makeSyntaxRepresentation()
precondition(property.trimmedDescription.contains("var count: Int = 0"))
_ = try property.validated()
let arguments = try FunctionCallExprSyntax.onlyParsed(from: "configure(options: true)").arguments
let positioned = PositionedLabeledExpression(positionIndex: 0, peerCount: 1, labeledExpression: arguments.first!)
precondition(positioned.isCompatible(with: ArgumentLocationDescriptor.labeled("options")))
let malformed = try VariableDeclSyntax.onlyParsed(from: "var value: ")
do {
  // SwiftSyntaxBuilder validation expects the fragment to be its own tree root.
  _ = try malformed.detached.validated()
  preconditionFailure("Malformed syntax must retain validation failure behavior")
} catch {
  precondition(!String(describing: error).isEmpty)
}
print("SyntaxOnly passed")
