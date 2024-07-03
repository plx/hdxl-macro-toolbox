import Foundation

extension String {

  @inlinable
  package init<each T>(
    forCaption caption: String,
    describingTuple values: (repeat each T)
  ) {
    var contents: String = "\(caption): "
    var iterationIndex: Int = 0
    for value in repeat each values {
      switch iterationIndex > 0 {
      case true:
        contents += ", \(String(describing: value))"
      case false:
        contents += String(describing: value)
      }
      
      iterationIndex += 1
    }
    
    self = "(\(contents))"
  }

  @inlinable
  package init<each T>(describingTuple values: (repeat each T)) {
    var contents: String = ""
    var iterationIndex: Int = 0
    for value in repeat each values {
      switch iterationIndex > 0 {
      case true:
        contents += ", \(String(describing: value))"
      case false:
        contents += String(describing: value)
      }
      
      iterationIndex += 1
    }
    
    self = "(\(contents))"
  }
  
  @inlinable
  package init<each T>(
    describingLabeledTuple labeledValues: (repeat (String, each T))
  ) {
    var contents: String = ""
    var iterationIndex: Int = 0
    for labeledValue in repeat each labeledValues {
      switch iterationIndex > 0 {
      case true:
        contents += ", \(labeledValue.0): \(String(describing: labeledValue.1))"
      case false:
        contents += "\(labeledValue.0): \(String(describing: labeledValue.1))"
      }
      
      iterationIndex += 1
    }
    
    self = "(\(contents))"
  }

  @inlinable
  package init<each T>(
    reflectingLabeledTuple labeledValues: (repeat (String, each T))
  ) {
    var contents: String = ""
    var iterationIndex: Int = 0
    for labeledValue in repeat each labeledValues {
      switch iterationIndex > 0 {
      case true:
        contents += ", \(labeledValue.0): \(String(reflecting: labeledValue.1))"
      case false:
        contents += "\(labeledValue.0): \(String(reflecting: labeledValue.1))"
      }
      
      iterationIndex += 1
    }
    
    self = "(\(contents))"
  }

  @inlinable
  package init<Parent, each T>(
    forConstructorOf type: Parent.Type,
    arguments labeledArguments: (repeat (String?, each T))
  ) {
    var contents: String = ""
    var iterationIndex: Int = 0
    for labeledValue in repeat each labeledArguments {
      switch iterationIndex > 0 {
      case true:
        contents += ", \(labeledValue.0.argumentLabelRepresentation)\(String(reflecting: labeledValue.1))"
      case false:
        contents += "\(labeledValue.0.argumentLabelRepresentation)\(String(reflecting: labeledValue.1))"
      }
      
      iterationIndex += 1
    }
    
    self = "\(String(reflecting: type))(\(contents))"
  }

  @inlinable
  package init<Parent, each T>(
    forConstructorOf type: Parent.Type,
    unlabeledArguments: (repeat each T)
  ) {
    var contents: String = ""
    var iterationIndex: Int = 0
    for unlabeledArgument in repeat each unlabeledArguments {
      switch iterationIndex > 0 {
      case true:
        contents += ", \(String(reflecting: unlabeledArgument))"
      case false:
        contents += "\(String(reflecting: unlabeledArgument))"
      }
      
      iterationIndex += 1
    }
    
    self = "\(String(reflecting: type))(\(contents))"
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
