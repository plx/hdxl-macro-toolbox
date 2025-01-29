import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros


// -------------------------------------------------------------------------- //
// MARK: - Value Requirements
// -------------------------------------------------------------------------- //

extension MacroContextProtocol {
  
  @inlinable
  public func requireTransflection<R>(
    argument argumentPositionDescriptor: ArgumentPositionDescriptor,
    as valueType: R.Type,
    messageIdentifier: @autoclosure () -> String = .unableToPerformRequiredTransflection,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> R where R: TransflectableViaExprSyntax {
    try withAutomaticRecordingForRequiredOperation(
      messageIdentifier: messageIdentifier(),
      explanation: "Unable to transflect argument \(argumentPositionDescriptor) as `\(valueType)` from `\(macroInvocationNode)`!",
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts()
    ) {
      try MacroExpansionFailure.withAutomaticEncapsulation(
        explanation: "Unable to transflect argument \(argumentPositionDescriptor) as `\(valueType)` from `\(macroInvocationNode)`!",
        function: function,
        fileID: fileID,
        line: line,
        column: column
      ) {
        guard
          let invocationArgumentsAsLabeledExpressionList
        else {
          throw MacroExpansionFailure(
            explanation: "Couldn't obtain `invocationArgumentsAsLabeledExpressionList` from \(self)",
            function: function,
            fileID: fileID,
            line: line,
            column: column
          )
        }
        
        guard
          let transflectionTarget = invocationArgumentsAsLabeledExpressionList.firstElement(
            compatibleWith: argumentPositionDescriptor
          )
        else {
          throw MacroExpansionFailure(
            explanation: "Couldn't find an argument compatible-with \(argumentPositionDescriptor) in `invocationArgumentsAsLabeledExpressionList` (`\(invocationArgumentsAsLabeledExpressionList)`)!",
            function: function,
            fileID: fileID,
            line: line,
            column: column
          )
        }
        
        return try valueType.init(
          transflectingExprSyntax: transflectionTarget.expression
        )
      }
    }
  }
  
  @inlinable
  public func requireTransflection<R>(
    of expression: ExprSyntax,
    as valueType: R.Type,
    messageIdentifier: @autoclosure () -> String = .unableToPerformRequiredTransflection,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> R where R: TransflectableViaExprSyntax {
    try withAutomaticRecordingForRequiredOperation(
      messageIdentifier: messageIdentifier(),
      explanation: "Unable to transflect expression `\(expression)` as `\(valueType)`!",
      attributionNode: attributionNode(),
      subjectNode: subjectNode(),
      highlights: highlights(),
      notes: notes(),
      fixIts: fixIts()
    ) {
      try MacroExpansionFailure.withAutomaticEncapsulation(
        explanation: "Unable to transflect expression `\(expression)` as `\(valueType)`!",
        function: function,
        fileID: fileID,
        line: line,
        column: column
      ) {
        try valueType.init(
          transflectingExprSyntax: expression
        )
      }
    }
  }
  
  @inlinable
  public func requireSynthesizableConformances(
    argument argumentPositionDescriptor: ArgumentPositionDescriptor,
    messageIdentifier: @autoclosure () -> String = .unableToPerformRequiredTransflection,
    attributionNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    subjectNode: @autoclosure () -> (any SyntaxProtocol)? = nil,
    highlights: @autoclosure () -> [Syntax]? = nil,
    notes: @autoclosure () -> [Note] = [],
    fixIts: @autoclosure () -> [FixIt] = [],
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> [SynthesizableProtocol] {
    try requireTransflection(
      argument: argumentPositionDescriptor,
      as: [SynthesizableProtocol].self,
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
    )
  }

}
