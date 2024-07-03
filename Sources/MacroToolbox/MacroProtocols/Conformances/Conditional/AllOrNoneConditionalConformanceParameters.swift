

public struct AllOrNoneConditionalConformanceParameters {
  
  public var genericParameterNames: [String]
  public var additionalImplicitParameterNames: [String]
  public var visibilityLevel: VisibilityLevel
  public var typeInlinabilityDisposition: InlinabilityDisposition?
  public var methodInlinabilityDisposition: InlinabilityDisposition?
  
  public init(
    genericParameterNames: [String],
    additionalImplicitParameterNames: [String],
    visibilityLevel: VisibilityLevel,
    typeInlinabilityDisposition: InlinabilityDisposition? = nil,
    methodInlinabilityDisposition: InlinabilityDisposition? = nil
  ) {
    self.genericParameterNames = genericParameterNames
    self.additionalImplicitParameterNames = additionalImplicitParameterNames
    self.visibilityLevel = visibilityLevel
    self.typeInlinabilityDisposition = typeInlinabilityDisposition
    self.methodInlinabilityDisposition = methodInlinabilityDisposition
  }
  
  public var allGenericParameterNames: [String] {
    genericParameterNames + additionalImplicitParameterNames
  }

}

extension AllOrNoneConditionalConformanceParameters: Equatable { }
extension AllOrNoneConditionalConformanceParameters: Hashable { }
extension AllOrNoneConditionalConformanceParameters: Codable { }

extension AllOrNoneConditionalConformanceParameters: CustomStringConvertible {
  
  @inlinable
  public var description: String {
    String(
      forCaption: "all-or-none-conformance",
      describingTuple: (
        ("genericParameterNames", genericParameterNames),
        ("additionalImplicitParameterNames", additionalImplicitParameterNames),
        ("visibilityLevel", visibilityLevel),
        ("typeInlinabilityDisposition", typeInlinabilityDisposition),
        ("methodInlinabilityDisposition", methodInlinabilityDisposition)
      )
    )
  }
}

extension AllOrNoneConditionalConformanceParameters: CustomDebugStringConvertible {
  
  @inlinable
  public var debugDescription: String {
    String(
      forConstructorOf: Self.self,
      arguments: (
        ("genericParameterNames", genericParameterNames),
        ("additionalImplicitParameterNames", additionalImplicitParameterNames),
        ("visibilityLevel", visibilityLevel),
        ("typeInlinabilityDisposition", typeInlinabilityDisposition),
        ("methodInlinabilityDisposition", methodInlinabilityDisposition)
      )
    )
  }
}
