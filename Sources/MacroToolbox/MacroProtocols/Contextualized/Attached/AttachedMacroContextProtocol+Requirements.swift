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

  @inlinable
  public func requireConcreteDeclSyntax(
    messageIdentifier: @autoclosure () -> String = .declarationOfIncorrectType,
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> ConcreteDeclSyntax {
    try requireValue(
      "Need to be attached to a concrete declaration.",
      messageIdentifier: messageIdentifier(),
      function: function,
      fileID: fileID,
      line: line,
      column: column
    ) {
      ConcreteDeclSyntax(decl: declaration)
    }
  }

  @inlinable
  public func requireConcreteTypeDeclaration(
    messageIdentifier: @autoclosure () -> String = .declarationOfIncorrectType,
    function: StaticString = #function,
    fileID: StaticString = #fileID,
    line: UInt = #line,
    column: UInt = #column
  ) throws -> ConcreteTypeDeclaration {
    try requireValue(
      "Need to be attached to a concrete type.",
      messageIdentifier: messageIdentifier(),
      function: function,
      fileID: fileID,
      line: line,
      column: column
    ) {
      ConcreteTypeDeclaration(decl: declaration)
    }
  }

}

