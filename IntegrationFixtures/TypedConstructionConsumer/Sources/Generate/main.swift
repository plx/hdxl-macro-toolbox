import MacroToolboxModels
import MacroToolboxSyntax
import SwiftParser
import SwiftSyntax

typealias Build = SyntaxConstruction
func type(_ source: String) throws -> TypeSyntax { try SyntaxSourceFragment.parse(source, as: TypeSyntax.self) }
func expr(_ source: String) throws -> ExprSyntax { try SyntaxSourceFragment.parse(source, as: ExprSyntax.self) }
func body(_ source: String) throws -> [CodeBlockItemSyntax] {
  Array(try SyntaxSourceFragment.parse("{\(source)}", as: CodeBlockSyntax.self).statements)
}
func structure(_ name: String, members: [DeclSyntax]) throws -> StructDeclSyntax {
  try StructDeclSyntax(modifiers: [DeclModifierSyntax(name: .keyword(.public))], name: Build.identifier(name), memberBlock: MemberBlockSyntax(declarations: members)).autoFormattedForHDXLProject()
}
func emit(_ declaration: some DeclSyntaxProtocol) throws {
  let output = try declaration.autoFormattedForHDXLProject().description
  _ = try SyntaxSourceFragment.parse(output, as: DeclSyntax.self)
  print(output)
}

let storage = try Build.storedProperty(name: .identifier("storedValue"), type: type("String"), readAccess: .private)
let initializer = try Build.initializer(parameters: [Build.parameter(localName: .identifier("value"), type: type("String"))], body: body("self.storedValue = value"), access: .public)
let projection = try Build.readOnlyProperty(name: .identifier("rawValue"), type: type("String"), body: body("storedValue"), readAccess: .public)
let forwardingCall = try Build.call(callee: expr("storedValue.hasPrefix"), arguments: [Build.argument(expression: expr("prefix"))])
let forwarder = try Build.function(name: .identifier("hasPrefix"), parameters: [Build.parameter(localName: .identifier("prefix"), type: type("String"))], returnType: type("Bool"), body: [CodeBlockItemSyntax(item: .expr(ExprSyntax(forwardingCall)))], access: .public)
try emit(structure("Example", members: [DeclSyntax(storage), DeclSyntax(initializer), DeclSyntax(projection), DeclSyntax(forwarder)]))
let witness = try Build.readOnlyProperty(name: .identifier("description"), type: type("String"), body: body("storedValue"), readAccess: CommandLine.arguments.contains("--insufficient-witness") ? .internal : .public)
try emit(Build.conformanceExtension(extending: type("Example"), conformances: [type("CustomStringConvertible")], members: [DeclSyntax(witness)]))

let attribute = try SyntaxSourceFragment.parse("@available(*, deprecated, message: \"fixture\")", as: AttributeSyntax.self)
let nested = try Build.storedProperty(name: .identifier("nested"), type: type("Dictionary<String, Array<Int?>>"), initializer: expr("[: ]"), readAccess: .public, setterAccess: .private, attributes: [.attribute(attribute)])
let keyword = try Build.storedProperty(name: .keyword(.class), type: type("String?"), bindingSpecifier: .keyword(.let), initializer: expr("nil"), readAccess: .public)
var shapeMembers = [DeclSyntax(nested), DeclSyntax(keyword), DeclSyntax(try Build.initializer(parameters: [], body: [], access: .public))]
for count in 0...3 {
  let parameters = try (0..<count).map { try Build.parameter(localName: .identifier("p\($0)"), type: type("Int")) }
  let sum = count == 0 ? "0" : (0..<count).map { "p\($0)" }.joined(separator: " + ")
  let function = try Build.function(name: Build.identifier("method\(count)"), parameters: parameters, returnType: type("Int"), body: body(sum), access: .public)
  let call = try Build.call(callee: expr("method\(count)"), arguments: (0..<count).map { try Build.argument(expression: expr("\($0 + 1)")) })
  let forwarding = try Build.function(name: Build.identifier("forward\(count)"), parameters: [], returnType: type("Int"), body: [CodeBlockItemSyntax(item: .expr(ExprSyntax(call)))], access: .public)
  shapeMembers += [DeclSyntax(function), DeclSyntax(forwarding)]
}
shapeMembers.append(DeclSyntax(try Build.function(name: .keyword(.repeat), parameters: [], returnType: type("Int"), body: body("7"), access: .public)))
try emit(structure("Shapes", members: shapeMembers))
// Empty, singleton, and multiple member blocks are all emitted and compiled.
try emit(structure("Empty", members: []))
try emit(structure("Singleton", members: [DeclSyntax(try Build.storedProperty(name: .identifier("value"), type: type("Int"), initializer: expr("0")))]))
try emit(SyntaxSourceFragment.parse("public struct Bag<T> {}", as: DeclSyntax.self))
try emit(Build.conformanceExtension(extending: type("Bag")))
try emit(Build.conformanceExtension(extending: type("Bag"), requirements: [Build.conformanceRequirement(type("T"), to: type("Equatable"))]))
let joined = try Build.function(name: .identifier("joined"), parameters: [Build.parameter(localName: .identifier("values"), type: type("T"))], returnType: type("String"), body: body("values.joined()"), access: .public)
try emit(Build.conformanceExtension(extending: type("Bag"), requirements: [Build.conformanceRequirement(type("T"), to: type("Sequence")), Build.sameTypeRequirement(type("T.Element"), as: type("String"))], members: [DeclSyntax(joined)]))

// The call must invoke the selected closure, not bind only to the fallback operand.
let selectedCall = try Build.call(callee: expr("primary ?? fallback"), arguments: [])
let selectionBody = try body("let primary: (() -> Int)? = nil\nlet fallback: () -> Int = { 42 }")
  + [CodeBlockItemSyntax(item: .stmt(StmtSyntax(ReturnStmtSyntax(expression: selectedCall))))]
try emit(Build.function(name: .identifier("selectedValue"), parameters: [], returnType: type("Int"), body: selectionBody, access: .public))

print("""
let example = Example("abcdef")
precondition(example.rawValue == "abcdef" && example.hasPrefix("abc"))
precondition(String(describing: example) == "abcdef")
let shapes = Shapes()
precondition(shapes.class == nil && shapes.repeat() == 7)
precondition(shapes.forward0() == 0 && shapes.forward1() == 1)
precondition(shapes.forward2() == 3 && shapes.forward3() == 6)
precondition(Bag<[String]>().joined(["a", "b"]) == "ab")
precondition(selectedValue() == 42)
print("Generated construction fixture passed")
""")
