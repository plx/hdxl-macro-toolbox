import MacroToolboxModels
import MacroToolboxSyntax
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import MacroToolbox

public struct GatherEvaluationsWithFlatteningMacro : DiagnosticDomainAwareMacro { }

extension GatherEvaluationsWithFlatteningMacro: AbstractGatherEvaluationsMacro {
  
  public static let macroExpansionConfiguration = GatherEvaluationsMacroConfiguration(
    hasThrowingSemantics: false,
    isFlatteningFunctionOutputs: true
  )
  
}
