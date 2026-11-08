import MacroToolboxModels
import ValueTransflection

public enum FixtureItem: String, Sendable, Equatable, TransflectableFromTransflectionExpression {
  case first, second
  public init(transflecting expression: TransflectionExpression) throws {
    let value = try TransflectionEnumCase(extracting: expression)
    try value.requireCompatibleBaseType(within: ["FixtureItem", "FixtureOptionsModels.FixtureItem"])
    guard value.arguments == nil else {
      throw EnumCaseTransflectionError.payloadShapeMismatch(typeName: "FixtureItem", caseName: value.caseName, detail: "Dummy items take no payload.")
    }
    switch value.caseName {
    case "first": self = .first
    case "second": self = .second
    default: throw EnumCaseTransflectionError.unrecognizedCase(typeName: "FixtureItem", caseName: value.caseName)
    }
  }
}

public struct FixtureOptions: Sendable, Equatable, TransflectableFromInitializerExpression {
  public let visibility: VisibilityLevel
  public let items: [FixtureItem]
  public init(visibility: VisibilityLevel, items: [FixtureItem]) {
    self.visibility = visibility; self.items = items
  }
  public init(transflectingInitializer initializer: TransflectionInitializerExpression) throws {
    let arguments = try initializer.bindArguments(to: [
      .init(index: 0, label: "visibility"), .init(index: 1, label: "items")
    ], acceptingTypeNames: Self.transflectionInitializerTypeNames)
    self.init(visibility: try arguments.transflectArgument(at: 0, as: VisibilityLevel.self),
      items: try arguments.transflectArgument(at: 1, as: [FixtureItem].self))
  }
}

/// Caller-owned semantic decisions. No syntax, source locations, or expansion context is stored.
public struct FixturePlan: Sendable, Equatable {
  public let storageName: String
  public let projectionName: String
  public let seedName: String
  public let memberAccess: VisibilityLevel
  public let storageAccess: VisibilityLevel
  public let items: [FixtureItem]
  public init(memberAccess: VisibilityLevel, items: [FixtureItem]) {
    storageName = "_fixtureItems"; projectionName = "fixtureItems"; seedName = "seed"
    storageAccess = .private; self.memberAccess = memberAccess; self.items = items
  }
}
