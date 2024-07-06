import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct MacroToolboxMacrosPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    GatherEvaluationsMacro.self,
    GatherEvaluationsWithFlattening.self,
    
    GatherThrowingEvaluationsMacro.self,
    GatherThrowingEvaluationsWithFlatteningMacro.self
  ]
}

