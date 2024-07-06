import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import MacroToolbox

public struct GatherThrowingEvaluationsWithFlatteningMacro : DiagnosticDomainAwareMacro { }

extension GatherThrowingEvaluationsWithFlatteningMacro: AbstractGatherEvaluationsMacro {
  
  public static let macroExpansionConfiguration = GatherEvaluationsMacroConfiguration(
    hasThrowingSemantics: true,
    isFlatteningFunctionOutputs: true
  )
  
}
