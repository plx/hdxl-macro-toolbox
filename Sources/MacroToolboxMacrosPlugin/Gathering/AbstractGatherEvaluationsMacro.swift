import SwiftSyntax
import MacroToolbox

public struct GatherEvaluationsMacroConfiguration: Sendable, Equatable {
  public var hasThrowingSemantics: Bool
  public var isFlatteningFunctionOutputs: Bool
  
  public init(hasThrowingSemantics: Bool, isFlatteningFunctionOutputs: Bool) {
    self.hasThrowingSemantics = hasThrowingSemantics
    self.isFlatteningFunctionOutputs = isFlatteningFunctionOutputs
  }
}

public final class GatherEvaluationsMacroParameters {
  public let gatheredElementType: String
  public let argumentCaptures: [(TokenSyntax, StmtSyntax)]
  public let functionCaptures: [(TokenSyntax, StmtSyntax)]
  
  public lazy var argumentCaptureRaws: [String] = argumentCaptures
    .map { _, captureStatement in
      "\(captureStatement)"
    }
  
  public lazy var functionCaptureRaws: [String] = functionCaptures
    .map { _, functionStatement in
      "\(functionStatement)"
    }

  public lazy var functionArgumentsRaw: String = argumentCaptures
    .map { uniqueName, _ in
      "\(uniqueName)"
    }.joined(separator: ", ")
  
  public lazy var functionCount: Int = functionCaptures.count
  
  public init(
    gatheredElementType: String,
    argumentCaptures: [(TokenSyntax, StmtSyntax)],
    functionCaptures: [(TokenSyntax, StmtSyntax)]
  ) {
    self.gatheredElementType = gatheredElementType
    self.argumentCaptures = argumentCaptures
    self.functionCaptures = functionCaptures
  }
}

public protocol AbstractGatherEvaluationsMacro: ContextualizedExpressionMacro {

  static var macroExpansionConfiguration: GatherEvaluationsMacroConfiguration { get }
  
  static func extractMacroExpansionParameters(
    from context: some ExpressionMacroContextProtocol
  ) throws -> GatherEvaluationsMacroParameters
  
  static func parameterizedExpansion(
    in context: some ExpressionMacroContextProtocol,
    configuration: GatherEvaluationsMacroConfiguration,
    parameters: GatherEvaluationsMacroParameters
  ) throws -> ExprSyntax
  
}

extension AbstractGatherEvaluationsMacro {
  
  public static func contextualizedExpansion(
    in attachmentContext: some ExpressionMacroContextProtocol
  ) throws -> ExprSyntax {
    try parameterizedExpansion(
      in: attachmentContext,
      configuration: macroExpansionConfiguration,
      parameters: try extractMacroExpansionParameters(
        from: attachmentContext
      )
    )
  }
  
  public static func extractMacroExpansionParameters(
    from attachmentContext: some ExpressionMacroContextProtocol
  ) throws -> GatherEvaluationsMacroParameters {
    let gatheredElementType: String = try attachmentContext.requireValue(
      """
      First argument needs to be an explicit type, but saw this instead:
      
      \(String(reflecting: attachmentContext.macroInvocationNode.arguments.first!))
      """
    ) {
      guard
        let firstArgument = attachmentContext
          .macroInvocationNode
          .arguments
          .first,
        let firstArgumentLabel = firstArgument.label,
        firstArgumentLabel.trimmed.text == "yielding",
        let firstArgumentExpr = firstArgument
          .expression
          .as(MemberAccessExprSyntax.self),
        firstArgumentExpr.period.tokenKind == .period,
        firstArgumentExpr.declName.argumentNames == nil,
        firstArgumentExpr.declName.baseName.tokenKind == .keyword(.self),
        let firstArgumentDecl = firstArgumentExpr
          .base?
          .as(DeclReferenceExprSyntax.self),
        case .identifier(let typeName) = firstArgumentDecl.baseName.tokenKind
      else {
        return nil
      }
      
      return typeName
    }
    
    let functionArguments: [ExprSyntax] = try attachmentContext.requireValue(
      "Second argument needs to be a tuple of arguments to the functions"
    ) {
      let secondArgument = attachmentContext
        .macroInvocationNode
        .arguments[
          attachmentContext
            .macroInvocationNode
            .arguments
            .index(after: attachmentContext
              .macroInvocationNode
              .arguments
              .startIndex
            )
        ]
      
      guard
        let secondArgumentLabel = secondArgument.label,
        secondArgumentLabel.trimmed.text == "arguments",
        let argumentTuple = secondArgument
          .expression
          .as(TupleExprSyntax.self),
        !argumentTuple.elements.isEmpty
      else {
        return nil
      }
      
      return argumentTuple.elements.map(\.expression)
    }
    
    let functionsToApply: [ExprSyntax] = try attachmentContext.requireValue(
      "Third argument needs to be an array-literal of functions to evaluate."
    ) {
      guard
        let thirdArgument = attachmentContext
          .macroInvocationNode
          .arguments
          .last,
        let thirdArgumentLabel = thirdArgument.label,
        thirdArgumentLabel.trimmed.text == "functions",
        let arrayOfFunctionsExpression = thirdArgument
          .expression
          .as(ArrayExprSyntax.self),
        !arrayOfFunctionsExpression.elements.isEmpty
      else {
        return nil
      }
      
      return arrayOfFunctionsExpression
        .elements
        .map(\.expression)
    }
    
    let argumentCaptures: [(TokenSyntax, StmtSyntax)] = functionArguments
      .enumerated()
      .map { (index, argumentExpression) in
        let uniqueName = attachmentContext
          .expansionContext
          .makeUniqueName("argument_\(index)")
        return (
          uniqueName,
          """
          let \(uniqueName) = \(argumentExpression)
          """
        )
      }
    
    let functionCaptures: [(TokenSyntax, StmtSyntax)] = functionsToApply
      .enumerated()
      .map { (index, functionExpression) in
        let uniqueName = attachmentContext
          .expansionContext
          .makeUniqueName("function_\(index)")
        
        return (
          uniqueName,
          """
          let \(uniqueName) = \(functionExpression)
          """
        )
      }
    
    return GatherEvaluationsMacroParameters(
      gatheredElementType: gatheredElementType,
      argumentCaptures: argumentCaptures,
      functionCaptures: functionCaptures
    )
  }

  public static func parameterizedExpansion(
    in context: some ExpressionMacroContextProtocol,
    configuration: GatherEvaluationsMacroConfiguration,
    parameters: GatherEvaluationsMacroParameters
  ) throws -> ExprSyntax {
    
    let throwingSnippet: String = switch configuration.hasThrowingSemantics {
    case true:
      "try "
    case false:
      ""
    }
    
    let functionValueGatheringsRaw: [String] = switch configuration.isFlatteningFunctionOutputs {
    case true:
      parameters.functionCaptures
        .map { uniqueName, _ in
          "result.append(contentsOf: \(throwingSnippet)\(uniqueName)(\(parameters.functionArgumentsRaw)))"
        }
    case false:
      parameters.functionCaptures
        .map { uniqueName, _ in
          "result.append(\(throwingSnippet)\(uniqueName)(\(parameters.functionArgumentsRaw)))"
        }
    }
    
    
    return """
    \(raw: throwingSnippet){
      // evaluate-and-capture the supplied arguments
      \(raw: parameters.argumentCaptureRaws.joined(separator: "\n"))
    
      // evaluate-and-capture the supplied functions
      \(raw: parameters.functionCaptureRaws.joined(separator: "\n"))
      
      // establish the results array
      var result: [\(raw: parameters.gatheredElementType)] = []
      result.reserveCapacity(\(raw: parameters.functionCount))
      
      // one-by-one evaluate-and-append our results:
      \(raw: functionValueGatheringsRaw.joined(separator: "\n"))
      return result
    }()
    """

  }

}
