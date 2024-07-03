import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

extension AttachedMacroContextProtocol {
  
  @inlinable
  public func requireSatisfactoryAttachment(
    attachmentRequirement: MacroAttachmentRequirement<DeclarationArchetype>,
    messageIdentifier: @autoclosure () -> String = .attachedToExcludedArchetype,
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws {
    let declarationArchetype = try requireProperty(
      \.declarationArchetype,
       of: declaration,
       function: function,
       fileID: fileID,
       line: line,
       column: column
    )
    
    try requireThat(
      attachmentRequirement.isCompatible(with: declarationArchetype),
      explanation:
        """
        Our archetype was \(declarationArchetype), which isn't compatible-with \(attachmentRequirement)!
        """,
      function: function,
      fileID: fileID,
      line: line,
      column: column
    )
  }
  
  @inlinable
  public func requireDeclaration<R>(
    as declarationType: R.Type,
    messageIdentifier: @autoclosure () -> String = .declarationOfIncorrectType,
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> R where R: DeclSyntaxProtocol {
    try requireSyntaxProperty(
      \.declaration,
       as: declarationType,
       function: function,
       fileID: fileID,
       line: line,
       column: column
    )
  }
  
}

