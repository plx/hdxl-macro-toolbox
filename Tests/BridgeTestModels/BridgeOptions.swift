import MacroToolboxModels
import ValueTransflection

public enum Exposure: Sendable, Equatable, TransflectableFromTransflectionExpression {
  case rawValue, description
  public init(transflecting expression: TransflectionExpression) throws {
    let value = try TransflectionEnumCase(extracting: expression)
    try value.requireCompatibleBaseType(within: ["Exposure", "BridgeTestModels.Exposure"])
    guard value.arguments == nil else {
      throw EnumCaseTransflectionError.payloadShapeMismatch(typeName: "Exposure", caseName: value.caseName, detail: "No payload is supported.")
    }
    switch value.caseName {
    case "rawValue": self = .rawValue
    case "description": self = .description
    default: throw EnumCaseTransflectionError.unrecognizedCase(typeName: "Exposure", caseName: value.caseName)
    }
  }
}

/// The same ordinary value can be constructed in caller code or decoded inside a plugin.
public struct BridgeOptions: Sendable, Equatable, TransflectableFromInitializerExpression {
  public let memberVisibility: VisibilityLevel
  public let exposedAPI: [Exposure]
  public init(memberVisibility: VisibilityLevel, exposedAPI: [Exposure]) {
    self.memberVisibility = memberVisibility; self.exposedAPI = exposedAPI
  }
  public init(transflectingInitializer initializer: TransflectionInitializerExpression) throws {
    let arguments = try initializer.bindArguments(to: [
      .init(index: 0, label: "memberVisibility"), .init(index: 1, label: "exposedAPI")
    ], acceptingTypeNames: Self.transflectionInitializerTypeNames)
    self.init(
      memberVisibility: try arguments.transflectArgument(at: 0, as: VisibilityLevel.self),
      exposedAPI: try arguments.transflectArgument(at: 1, as: [Exposure].self)
    )
  }
}
