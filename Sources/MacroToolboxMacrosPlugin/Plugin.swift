import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct MacroToolboxMacrosPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
  ]
}

