import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


// MARK: - Value Requirements

extension MacroContextProtocol {
  
  @inlinable
  public func requireValue<R>(
    _ explanation: @autoclosure () -> String,
    messageIdentifier: @autoclosure () -> String = .unableToObtainRequiredValue,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column,
    _ requirement: () throws -> R
  ) throws -> R {
    try withAutomaticRecordingForRequiredOperation(
      messageIdentifier: messageIdentifier(),
      explanation: explanation(),
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts()
    ) {
      try MacroExpansionFailure.withAutomaticEncapsulation(
        explanation: explanation(),
        function: function,
        fileID: fileID,
        line: line,
        column: column
      ) {
        try requirement()
      }
    }
  }
  
  @inlinable
  public func requireValue<R>(
    _ explanation: @autoclosure () -> String,
    messageIdentifier: @autoclosure () -> String = .unableToObtainRequiredValue,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column,
    _ requirement: () throws -> R?
  ) throws -> R {
    try withAutomaticRecordingForRequiredOperation(
      messageIdentifier: messageIdentifier(),
      explanation: explanation(),
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts()
    ) {
      let possibleValue = try MacroExpansionFailure.withAutomaticEncapsulation(
        explanation: explanation(),
        function: function,
        fileID: fileID,
        line: line,
        column: column
      ) {
        try requirement()
      }
      
      guard case .some(let value) = possibleValue else {
        throw MacroExpansionFailure(
          explanation: explanation(),
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      
      return value
    }
  }
  
}

// MARK: - Property Requirements

extension MacroContextProtocol {

  @inlinable
  public func requireProperty<V>(
    _ property: KeyPath<Self,V?>,
    messageIdentifier: @autoclosure () -> String = .requiredPropertyWasNil,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> V {
    try requireValue(
      "Getting \(property) from \(self)",
      messageIdentifier: messageIdentifier(),
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts(),
      function: function,
      fileID: fileID,
      line: line,
      column: column
    ) {
      guard let value = self[keyPath: property] else {
        throw MacroExpansionFailure(
          explanation: "Property \(property) was `nil` on \(self)!",
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      
      return value
    }
  }

  @inlinable
  public func requireProperty<T,V>(
    _ property: KeyPath<T,V?>,
    of source: T,
    messageIdentifier: @autoclosure () -> String = .requiredPropertyWasNil,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> V {
    try requireValue(
      "Getting \(property) from \(source)",
      messageIdentifier: messageIdentifier(),
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts(),
      function: function,
      fileID: fileID,
      line: line,
      column: column
    ) {
      guard let value = source[keyPath: property] else {
        throw MacroExpansionFailure(
          explanation: "Property \(property) was `nil` on \(source)!",
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      
      return value
    }
  }

  @inlinable
  public func requireNonEmptyProperty<T,V>(
    _ property: KeyPath<T,V?>,
    of source: T,
    messageIdentifier: @autoclosure () -> String = .requiredPropertyWasNil,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> V where V: Collection {
    try requireValue(
      "Getting \(property) from \(source)",
      messageIdentifier: messageIdentifier(),
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts(),
      function: function,
      fileID: fileID,
      line: line,
      column: column
    ) {
      guard let value = source[keyPath: property] else {
        throw MacroExpansionFailure(
          explanation: "Property \(property) was `nil` on \(source)!",
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      
      guard !value.isEmpty else {
        throw MacroExpansionFailure(
          explanation: "Property \(property) was non-`nil` but empty on \(source)!",
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      
      return value
    }
  }

  @inlinable
  public func requireNonEmptyProperty<T,V>(
    _ property: KeyPath<T,V>,
    of source: T,
    messageIdentifier: @autoclosure () -> String = .requiredPropertyWasNil,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> V where V: Collection {
    try requireValue(
      "Getting \(property) from \(source)",
      messageIdentifier: messageIdentifier(),
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts(),
      function: function,
      fileID: fileID,
      line: line,
      column: column
    ) {
      let value = source[keyPath: property]
      
      guard !value.isEmpty else {
        throw MacroExpansionFailure(
          explanation: "Property \(property) was non-`nil` but empty on \(source)!",
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      
      return value
    }
  }

  @inlinable
  public func requireSyntaxProperty<T,V,R>(
    _ property: KeyPath<T,V?>,
    of source: T,
    as syntaxType: R.Type,
    messageIdentifier: @autoclosure () -> String = .requiredPropertyWasNil,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> R where V: SyntaxProtocol, R: SyntaxProtocol {
    try requireValue(
      "Getting \(property) from \(source)",
      messageIdentifier: messageIdentifier(),
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts(),
      function: function,
      fileID: fileID,
      line: line,
      column: column
    ) {
      guard let underlyingValue = source[keyPath: property] else {
        throw MacroExpansionFailure(
          explanation: "Property \(property) was `nil` on \(source)!",
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      
      guard let reinterpretedValue = underlyingValue.as(syntaxType) else {
        throw MacroExpansionFailure(
          explanation: "Couldn't convert \(underlyingValue) to \(syntaxType) (for: \(property) from \(source)!)",
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      return reinterpretedValue
    }
  }

  @inlinable
  public func requireSyntaxProperty<T,V,R>(
    _ property: KeyPath<T,V>,
    of source: T,
    as syntaxType: R.Type,
    messageIdentifier: @autoclosure () -> String = .requiredPropertyWasNil,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> R where V: SyntaxProtocol, R: SyntaxProtocol {
    try requireValue(
      "Getting \(property) from \(source)",
      messageIdentifier: messageIdentifier(),
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts(),
      function: function,
      fileID: fileID,
      line: line,
      column: column
    ) {
      let underlyingValue = source[keyPath: property]
      
      guard let reinterpretedValue = underlyingValue.as(syntaxType) else {
        throw MacroExpansionFailure(
          explanation: "Couldn't convert \(underlyingValue) to \(syntaxType) (for: \(property) from \(source)!)",
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      return reinterpretedValue
    }
  }
  

  @inlinable
  public func requireSyntaxProperty<V,R>(
    _ property: KeyPath<Self,V>,
    as syntaxType: R.Type,
    messageIdentifier: @autoclosure () -> String = .requiredPropertyWasNil,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> R where V: SyntaxProtocol, R: SyntaxProtocol {
    try requireValue(
      "Getting \(property) from \(self)",
      messageIdentifier: messageIdentifier(),
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts(),
      function: function,
      fileID: fileID,
      line: line,
      column: column
    ) {
      let underlyingValue = self[keyPath: property]
      
      guard let reinterpretedValue = underlyingValue.as(syntaxType) else {
        throw MacroExpansionFailure(
          explanation: "Couldn't convert \(underlyingValue) to \(syntaxType) (for: \(property) from \(self)!)",
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      return reinterpretedValue
    }
  }

  @inlinable
  public func requireSyntaxProperty<V,R>(
    _ property: KeyPath<Self,V?>,
    as syntaxType: R.Type,
    messageIdentifier: @autoclosure () -> String = .requiredPropertyWasNil,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> R where V: SyntaxProtocol, R: SyntaxProtocol {
    try requireValue(
      "Getting \(property) from \(self)",
      messageIdentifier: messageIdentifier(),
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts(),
      function: function,
      fileID: fileID,
      line: line,
      column: column
    ) {
      guard let underlyingValue = self[keyPath: property] else {
        throw MacroExpansionFailure(
          explanation: "Property \(property) was `nil` on \(self)!",
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      
      guard let reinterpretedValue = underlyingValue.as(syntaxType) else {
        throw MacroExpansionFailure(
          explanation: "Couldn't convert \(underlyingValue) to \(syntaxType) (for: \(property) from \(self)!)",
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      return reinterpretedValue
    }
  }

  @inlinable
  public func requireProperty<T,V,R>(
    _ property: KeyPath<T,V?>,
    of source: T,
    as expectedType: R.Type,
    messageIdentifier: @autoclosure () -> String = .requiredPropertyWasNil,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> R {
    try requireValue(
      "Getting \(property) from \(source)",
      messageIdentifier: messageIdentifier(),
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts(),
      function: function,
      fileID: fileID,
      line: line,
      column: column
    ) {
      guard let underlyingValue = source[keyPath: property] else {
        throw MacroExpansionFailure(
          explanation: "Property \(property) was `nil` on \(source)!",
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      
      guard let reinterpretedValue = underlyingValue as? R else {
        throw MacroExpansionFailure(
          explanation: "Couldn't convert \(underlyingValue) to \(expectedType) (for: \(property) from \(source)!)",
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      return reinterpretedValue
    }
  }

}

// MARK: - Condition Requirements

extension MacroContextProtocol {
  
  @inlinable
  public func requireCondition(
    _ explanation: @autoclosure () -> String,
    messageIdentifier: @autoclosure () -> String = .necessaryConditionWasFalse,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column,
    _ condition: () throws -> Bool
  ) throws {
    try withAutomaticRecordingForRequiredOperation(
      messageIdentifier: messageIdentifier(),
      explanation: explanation(),
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts()
    ) {
      let evaluationResult = try MacroExpansionFailure.withAutomaticEncapsulation(
        explanation: explanation(),
        function: function,
        fileID: fileID,
        line: line,
        column: column
      ) {
        try condition()
      }
      
      guard evaluationResult else {
        throw MacroExpansionFailure(
          explanation: explanation(),
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
    }
  }

  @inlinable
  public func requireThat(
    _ condition: @autoclosure () -> Bool,
    explanation: @autoclosure () -> String = "We need this condition to be true!",
    messageIdentifier: @autoclosure () -> String = .necessaryConditionWasFalse,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws {
    try withAutomaticRecordingForRequiredOperation(
      messageIdentifier: messageIdentifier(),
      explanation: explanation(),
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts()
    ) {
      guard condition() else {
        throw MacroExpansionFailure(
          explanation: explanation(),
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
    }
  }

}

// MARK: - External-Value Validation

extension MacroContextProtocol {
  
  @inlinable
  public func requireNonEmptyValues<T>(
    _ values: T,
    messageIdentifier: @autoclosure () -> String = .mustNotBeEmpty,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> T where T: Collection {
    try withAutomaticRecordingForRequiredOperation(
      messageIdentifier: messageIdentifier(),
      explanation: "We require that `\(values)` must not be empty!",
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts()
    ) {
      guard !values.isEmpty else {
        throw MacroExpansionFailure(
          explanation: "We require that `\(values)` must not be empty!",
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      
      return values
    }
  }
  
  @inlinable
  public func requireNonNull<T>(
    _ possibleValue: T?,
    messageIdentifier: @autoclosure () -> String = .mustNotBeEmpty,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> T {
    try withAutomaticRecordingForRequiredOperation(
      messageIdentifier: messageIdentifier(),
      explanation: "We require that `\(String(reflecting: possibleValue))` must be non-nil!",
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts()
    ) {
      guard case .some(let value) = possibleValue else {
        throw MacroExpansionFailure(
          explanation: "We require that `\(String(reflecting: possibleValue))` must be non-nil!",
          function: function,
          fileID: fileID,
          line: line,
          column: column
        )
      }
      
      return value
    }
  }
  
}
