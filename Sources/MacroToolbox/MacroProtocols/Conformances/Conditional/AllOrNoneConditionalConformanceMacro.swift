import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftDiagnostics


/// Base protocol for macros providing simplistic "all-or-none" conditional conformances.
///
/// The motivating use case is to reduce boilerplate like this:
///
/// ```swift
/// // note: no requirements here
/// struct Foo<Bar,Baz,Quux> {
///   var bar: Bar
///   var baz: Baz
///   var quux: Quux
/// }
///
/// // so tons of junk like this:
/// extension Foo: Sendable where Foo: Sendable, Bar: Sendable, Baz: Sendable { }
/// extension Foo: Equatable where Foo: Equatable, Bar: Equatable, Baz: Equatable { }
/// ```
///
/// The example there is this macro's sweet-spot: blindly applying identical conformance tests to each explicit
/// generic parameter.
///
/// I have some provisional support for richer semantics, but tbd if it works well or not.
public protocol AllOrNoneConditionalConformanceMacro: ContextualizedExtensionMacro, ProtocolIncompatibleContextualizedTypeAttachedMacro, DiagnosticDomainAwareMacro {
    
  static var requiredProtocolNames: [String] { get }
  static var conformedProtocolNames: [String] { get }

  static func genericParameterNames(
    in attachmentContext: some ExtensionMacroContextProtocol
  ) throws -> [String]

  static func additionalImplicitGenericParameterNames(
    in attachmentContext: some ExtensionMacroContextProtocol,
    genericParameterNames: [String]
  ) throws -> [String]
 
  static func conditionalConformanceInheritanceClause(
    in attachmentContext: some ExtensionMacroContextProtocol,
    parameters: AllOrNoneConditionalConformanceParameters
  ) throws -> InheritanceClauseSyntax
  
  static func conditionalConformanceRequirementsClause(
    in attachmentContext: some ExtensionMacroContextProtocol,
    parameters: AllOrNoneConditionalConformanceParameters
  ) throws -> GenericWhereClauseSyntax

  static func conditionalConformanceDeclarations(
    in attachmentContext: some ExtensionMacroContextProtocol,
    parameters: AllOrNoneConditionalConformanceParameters
  ) throws -> [DeclSyntax]

  static func conditionalConformanceExtension(
    in attachmentContext: some ExtensionMacroContextProtocol,
    parameters: AllOrNoneConditionalConformanceParameters
  ) throws -> ExtensionDeclSyntax
}

extension AllOrNoneConditionalConformanceMacro {
  
  @inlinable
  public static var additionalImplicitGenericParameterNames: [String] {
    []
  }
  
  @inlinable
  public static var typeAttachmentRequirement: MacroAttachmentRequirement<TypeDeclarationArchetype> {
    .anythingBut([.protocol])
  }
  
}

extension AllOrNoneConditionalConformanceMacro {
  public static func genericParameterNames(
    in attachmentContext: some ExtensionMacroContextProtocol
  ) throws -> [String] {
    try attachmentContext.requireProperty(
      \.simpleGenericParameterNames,
      of: attachmentContext.declaration
    )
  }
  
  public static func additionalImplicitGenericParameterNames(
    in attachmentContext: some ExtensionMacroContextProtocol,
    genericParameterNames: [String]
  ) throws -> [String] {
    // hacky trick, lol
    guard
      genericParameterNames.contains("Base"),
      "\(attachmentContext.extendedType.trimmed)".hasSuffix("Sequence"),
      "\(attachmentContext.macroInvocationNode.trimmed)".hasSuffix("NeedsBaseElement")
    else {
      return []
    }
    
    return ["Base.Element"]
  }
  
  public static func conditionalConformanceInheritanceClause(
    in attachmentContext: some ExtensionMacroContextProtocol,
    parameters: AllOrNoneConditionalConformanceParameters
  ) throws -> InheritanceClauseSyntax {
    InheritanceClauseSyntax.forInheritedTypeNames(conformedProtocolNames)
  }
  
  public static func conditionalConformanceRequirementsClause(
    in attachmentContext: some ExtensionMacroContextProtocol,
    parameters: AllOrNoneConditionalConformanceParameters
  ) throws -> GenericWhereClauseSyntax {
    let allGenericParameterNames = try attachmentContext.requireNonEmptyValues(
      parameters.allGenericParameterNames
    )
    
    let requiredProtocolNames = try attachmentContext.requireNonEmptyValues(
      requiredProtocolNames
    )
    
    return GenericWhereClauseSyntax.withTransformedCartesianProduct(
      of: (allGenericParameterNames, requiredProtocolNames)
    ) { genericParameterName, requiredProtocolName in
      .requirement(
        that: genericParameterName,
        inheritsFrom: requiredProtocolName
      )
    }
  }
  
  public static func conditionalConformanceDeclarations(
    in attachmentContext: some ExtensionMacroContextProtocol,
    parameters: AllOrNoneConditionalConformanceParameters
  ) throws -> [DeclSyntax] {
    []
  }
  
  public static func conditionalConformanceExtension(
    in attachmentContext: some ExtensionMacroContextProtocol,
    parameters: AllOrNoneConditionalConformanceParameters
  ) throws -> ExtensionDeclSyntax {
    ExtensionDeclSyntax(
      extendedType: attachmentContext.extendedType,
      inheritanceClause: try conditionalConformanceInheritanceClause(
        in: attachmentContext,
        parameters: parameters
      ),
      genericWhereClause: try conditionalConformanceRequirementsClause(
        in: attachmentContext,
        parameters: parameters
      ),
      memberBlock: MemberBlockSyntax(
        declarations: try conditionalConformanceDeclarations(
          in: attachmentContext,
          parameters: parameters
        )
      )
    )
  }
}

extension AllOrNoneConditionalConformanceMacro where Self: ContextualizedExtensionMacro {
  
  public static func contextualizedExpansion(
    in attachmentContext: some ExtensionMacroContextProtocol
  ) throws -> [ExtensionDeclSyntax] {
    let genericParameterNames = try genericParameterNames(
      in: attachmentContext
    )
    
    let parameters = AllOrNoneConditionalConformanceParameters(
      genericParameterNames: genericParameterNames,
      additionalImplicitParameterNames: try additionalImplicitGenericParameterNames(
        in: attachmentContext,
        genericParameterNames: genericParameterNames
      ),
      visibilityLevel: attachmentContext.visibilityLevel,
      typeInlinabilityDisposition: InlinabilityDisposition.strongestAvailableTypeDeclarationInlinability(
        declarationVisibility: attachmentContext.visibilityLevel,
        dispositionHint: attachmentContext.inlinabilityDisposition
      ),
      methodInlinabilityDisposition: InlinabilityDisposition.strongestAvailableFunctionOrMethodInlinability(
        declarationVisibility: attachmentContext.visibilityLevel,
        dispositionHint: attachmentContext.inlinabilityDisposition
      )
    )

    return [
      try conditionalConformanceExtension(
        in: attachmentContext,
        parameters: parameters
      )
    ]
  }
      
}
