import Foundation

extension String {

  @inlinable
  package init<each T>(
    forCaption caption: String,
    describingTuple values: (repeat each T)
  ) {
    var components: [String] = []
    for value in repeat each values {
      components.append(String(describing: value))
    }
    self = "(\(caption): \(components.joined(separator: ", ")))"
  }

  @inlinable
  package init<each T>(describingTuple values: (repeat each T)) {
    var components: [String] = []
    for value in repeat each values {
      components.append(String(describing: value))
    }
    self = "(\(components.joined(separator: ", ")))"
  }

  @inlinable
  package init<each T>(
    describingLabeledTuple labeledValues: (repeat (String, each T))
  ) {
    var components: [String] = []
    for labeledValue in repeat each labeledValues {
      components.append("\(labeledValue.0): \(String(describing: labeledValue.1))")
    }
    self = "(\(components.joined(separator: ", ")))"
  }

  @inlinable
  package init<each T>(
    reflectingLabeledTuple labeledValues: (repeat (String, each T))
  ) {
    var components: [String] = []
    for labeledValue in repeat each labeledValues {
      components.append("\(labeledValue.0): \(String(reflecting: labeledValue.1))")
    }
    self = "(\(components.joined(separator: ", ")))"
  }

  /// Prepares a constructor-like string with a mix of labeled and unlabeled arguments (e.g. `Modulator(target, using: modulator)`).
  ///
  /// - Parameters:
  ///   - type: The type for-which we're preparing this string (e.g.
  ///   - labeledArguments: <#labeledArguments description#>
  @inlinable
  package init<Parent, each T>(
    forConstructorOf type: Parent.Type,
    arguments labeledArguments: (repeat (String?, each T))
  ) {
    var components: [String] = []
    for labeledArgument in repeat each labeledArguments {
      components.append("\(labeledArgument.0.argumentLabelRepresentation)\(String(reflecting: labeledArgument.1))")
    }
    self = "\(String(reflecting: type))(\(components.joined(separator: ", ")))"
  }

  /// Constructs a constructor-like string w/completely-unlabeled arguments (e.g. `Foo(x,y,z)`).
  @inlinable
  package init<Parent, each T>(
    forConstructorOf type: Parent.Type,
    unlabeledArguments: (repeat each T)
  ) {
    var components: [String] = []
    for value in repeat each unlabeledArguments {
      components.append(String(reflecting: value))
    }
    self = "\(String(reflecting: type))(\(components.joined(separator: ", ")))"
  }

}

extension String {

  @usableFromInline
  package static func tupleComponents(
    describing value: Any
  ) -> [String] {
    Mirror(reflecting: value).children.map { child in
      String(describing: child.value)
    }
  }

  @usableFromInline
  package static func tupleComponents(
    reflecting value: Any
  ) -> [String] {
    Mirror(reflecting: value).children.map { child in
      String(reflecting: child.value)
    }
  }

  @usableFromInline
  package static func labeledTupleComponents(
    describing value: Any
  ) -> [String] {
    tuplePairComponents(from: value) { pair in
      "\(pair.label): \(String(describing: pair.value))"
    }
  }

  @usableFromInline
  package static func labeledTupleComponents(
    reflecting value: Any
  ) -> [String] {
    tuplePairComponents(from: value) { pair in
      "\(pair.label): \(String(reflecting: pair.value))"
    }
  }

  @usableFromInline
  package static func constructorArgumentComponents(
    reflecting value: Any
  ) -> [String] {
    Mirror(reflecting: value).children.map { child in
      let pairChildren = Array(Mirror(reflecting: child.value).children)
      guard
        pairChildren.count == 2,
        let label = parsedConstructorArgumentLabel(
          from: pairChildren[0].value
        )
      else {
        return String(describing: child.value)
      }

      return "\(label.argumentLabelRepresentation)\(String(reflecting: pairChildren[1].value))"
    }
  }

  @usableFromInline
  package static func parsedConstructorArgumentLabel(from value: Any) -> String?? {
    if let label = value as? String {
      return Optional.some(Optional.some(label))
    }

    if let optionalLabel = value as? String? {
      return Optional.some(optionalLabel)
    }

    return nil
  }

  @usableFromInline
  package static func tuplePairComponents(
    from value: Any,
    transform: ((label: String, value: Any)) -> String
  ) -> [String] {
    Mirror(reflecting: value).children.map { child in
      let pairChildren = Array(Mirror(reflecting: child.value).children)
      guard
        pairChildren.count == 2,
        let label = pairChildren[0].value as? String
      else {
        return String(describing: child.value)
      }

      return transform(
        (
          label: label,
          value: pairChildren[1].value
        )
      )
    }
  }

}

extension Optional<String> {

  @inlinable
  package var argumentLabelRepresentation: String {
    guard
      case .some(let label) = self,
      !label.isEmpty
    else {
      return ""
    }

    return "\(label): "
  }

}
