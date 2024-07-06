import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import MacroToolbox

public struct GatherEvaluationsMacro : DiagnosticDomainAwareMacro { }

extension GatherEvaluationsMacro: AbstractGatherEvaluationsMacro {
  
  public static let macroExpansionConfiguration = GatherEvaluationsMacroConfiguration(
    hasThrowingSemantics: false,
    isFlatteningFunctionOutputs: false
  )
  
}
