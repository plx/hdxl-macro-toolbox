import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct FixturePlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [FixtureMembersMacro.self]
}
