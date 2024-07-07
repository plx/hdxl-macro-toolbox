import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct MacroTransflectionMacrosPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    // transflection management:
    ExcludeFromTransflectionMacro.self,
    
    // source-code-identifier transflection:
    AddSourceCodeIdentifierTransflectionMacro.self
  ]
}

