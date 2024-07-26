import SwiftSyntax


extension InitializerDeclSyntax {
  
  /// `true` iff this initializer has been explicitly tagged as the preferred memberwise intializer.
  @inlinable
  public var isPreferredMemberwiseInitializer: Bool {
    attributes.anySatisfy(\.isPreferredMemberwiseInitializer)
  }
  
  /// `true` iff this initializer could be a memberwise initializer (vis-a-vis the supplied `storedProperties`).
  ///
  /// - note:
  ///
  /// This exists to help try-and-detect memberwise initializers following the most-obvious-and-trivial pattern:
  ///
  /// ```swift
  /// struct Foo {
  ///   var x: X
  ///   var y: Y
  ///
  ///   init(x: X, y: Y) {
  ///     self.x = x
  ///     self.y = y
  ///   }
  /// }
  /// ```
  ///
  /// ...including cases where the parameters are unlabeled.
  ///
  ///
  /// It's not meant to be a definitive memberwise-initializer and, in particular, may be fooled whenever the arguments aren't
  /// 1:1 with the stored properties from `storedProperties`.
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
