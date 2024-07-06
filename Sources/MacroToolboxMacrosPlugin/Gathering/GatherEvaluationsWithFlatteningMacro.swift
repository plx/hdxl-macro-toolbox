import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import MacroToolbox

public struct GatherEvaluationsWithFlattening : DiagnosticDomainAwareMacro { }

extension GatherEvaluationsWithFlattening: AbstractGatherEvaluationsMacro {
  
  public static let macroExpansionConfiguration = GatherEvaluationsMacroConfiguration(
    hasThrowingSemantics: false,
    isFlatteningFunctionOutputs: true
  )
  
}
