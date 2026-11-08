import MacroToolboxModels
import MacroToolboxSyntax
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct MacroToolboxMacrosPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    GatherEvaluationsMacro.self,
    GatherEvaluationsWithFlatteningMacro.self,
    
    GatherThrowingEvaluationsMacro.self,
    GatherThrowingEvaluationsWithFlatteningMacro.self
  ]
}

