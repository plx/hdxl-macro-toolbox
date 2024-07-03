import SwiftSyntax


extension InitializerDeclSyntax {
  
  @inlinable
  public var isPreferredMemberwiseInitializer: Bool {
    attributes.anySatisfy(\.isPreferredMemberwiseInitializer)
  }
  
  @inlinable
  public func isPlausibleMemberwiseInitializer(
    forStoredProperties storedProperties: some Collection<VariableDeclSyntax>
  ) -> Bool {
    guard
      signature
        .parameterClause
        .parameters
        .count == storedProperties.count
    else {
      return false
    }
    
    let initializerArgumentNamesAndTypes: [String:TypeSyntax] = [String:TypeSyntax](
      uniqueKeysWithValues: signature
        .parameterClause
        .parameters
        .map { parameter in
          (
            (parameter.secondName ?? parameter.firstName).trimmed.text,
            parameter.type
          )
        }
    )
    
    return storedProperties.allSatisfy { storedProperty in
      switch storedProperty.variableNameIfStoredProperty {
      case .none:
        false
      case .some(let variableName):
        // TODO: validate the type more-rigorously
        initializerArgumentNamesAndTypes[variableName] != nil
      }
    }
  }
}
