import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import MacroToolbox

public struct GatherThrowingEvaluationsMacro : DiagnosticDomainAwareMacro { }

extension GatherThrowingEvaluationsMacro: AbstractGatherEvaluationsMacro {
  
  public static let macroExpansionConfiguration = GatherEvaluationsMacroConfiguration(
    hasThrowingSemantics: true,
    isFlatteningFunctionOutputs: false
  )
  
}
