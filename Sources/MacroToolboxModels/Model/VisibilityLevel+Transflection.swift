import ValueTransflection

/// Handwritten foundational witness: the caller and plugin use this same model type and normal
/// value protocol. Availability never depends on importing the host bridge or a code generator.
extension VisibilityLevel: TransflectableFromTransflectionExpression {
  public init(transflecting expression: TransflectionExpression) throws {
    let value = try TransflectionEnumCase(extracting: expression)
    try value.requireCompatibleBaseType(within: ["VisibilityLevel", "MacroToolboxModels.VisibilityLevel"])
    guard value.arguments == nil else {
      throw EnumCaseTransflectionError.payloadShapeMismatch(typeName: "VisibilityLevel", caseName: value.caseName, detail: "Visibility cases do not carry arguments.")
    }
    switch value.caseName {
    case "private": self = .private
    case "fileprivate": self = .fileprivate
    case "internal": self = .internal
    case "package": self = .package
    case "public": self = .public
    case "open": self = .open
    default: throw EnumCaseTransflectionError.unrecognizedCase(typeName: "VisibilityLevel", caseName: value.caseName)
    }
  }
}
