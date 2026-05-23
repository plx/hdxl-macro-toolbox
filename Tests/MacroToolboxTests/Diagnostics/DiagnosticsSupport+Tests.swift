import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros
import Testing
@testable import MacroToolbox

@Test("HDXL macro diagnostics preserve message identity and severity")
func testHDXLMacroDiagnosticsPreserveMessageIdentityAndSeverity() {
  // Hand-written examples: each factory should keep the supplied message ID and
  // assign exactly the requested diagnostic severity.
  let messageID = MessageID(domain: "ExampleDomain", id: "example")
  let diagnostics = [
    HDXLMacroDiagnostic.error("error message", diagnosticID: messageID),
    HDXLMacroDiagnostic.warning("warning message", diagnosticID: messageID),
    HDXLMacroDiagnostic.note("note message", diagnosticID: messageID),
    HDXLMacroDiagnostic.remark("remark message", diagnosticID: messageID)
  ]
  
  #expect(diagnostics.map(\.severity) == [.error, .warning, .note, .remark])
  #expect(diagnostics.allSatisfy { $0.diagnosticID == messageID })
  #expect(diagnostics[0].message == "error message")
  #expect(diagnostics[0].description.contains("error"))
  #expect(diagnostics[0].debugDescription.contains("HDXLMacroDiagnostic"))
}

@Test("HDXL macro diagnostic factories match direct construction")
func testHDXLMacroDiagnosticFactoriesMatchDirectConstruction() {
  // Property-style test: for every supported severity, the factory output should
  // be equal to a directly constructed diagnostic with the same fields.
  let messageID = MessageID(domain: "ExampleDomain", id: "factory")
  let factories: [(DiagnosticSeverity, HDXLMacroDiagnostic)] = [
    (.error, .error("message", diagnosticID: messageID)),
    (.warning, .warning("message", diagnosticID: messageID)),
    (.note, .note("message", diagnosticID: messageID)),
    (.remark, .remark("message", diagnosticID: messageID))
  ]
  
  for (severity, diagnostic) in factories {
    #expect(
      diagnostic
      ==
      HDXLMacroDiagnostic(
        message: "message",
        severity: severity,
        diagnosticID: messageID
      )
    )
  }
}

@Test("Macro diagnostic domains create diagnostics with the expected identity")
func testMacroDiagnosticDomainsCreateDiagnosticsWithExpectedIdentity() throws {
  // Hand-written examples: domain helpers should derive `MessageID` values from
  // the domain type, and the diagnostic builder should preserve message, severity,
  // highlights, notes, and fix-its on the resulting SwiftDiagnostics value.
  let node = try StructDeclSyntax.onlyParsed(from: "struct Box {}")
  let customID = ExampleDiagnosticDomain.messageID(id: "custom")
  let defaultID = DefaultDiagnosticDomain.messageID(id: "default")
  let diagnostic = ExampleDiagnosticDomain.diagnostic(
    for: node,
    explanation: "expected diagnostic",
    severity: .warning,
    messageID: "custom",
    highlights: [Syntax(node)]
  )
  let thrownError = ExampleDiagnosticDomain.diagnosticError(
    for: node,
    explanation: "thrown diagnostic",
    messageID: "thrown"
  )
  let publicSeverityDiagnostics = [
    ExampleDiagnosticDomain.diagnosticWarning(
      for: node,
      explanation: "public warning",
      messageID: "warning"
    ),
    ExampleDiagnosticDomain.diagnosticNote(
      for: node,
      explanation: "public note",
      messageID: "note"
    ),
    ExampleDiagnosticDomain.diagnosticRemark(
      for: node,
      explanation: "public remark",
      messageID: "remark"
    )
  ]
  
  #expect(ExampleDiagnosticDomain.diagnosticDomainIdentifier == "ExampleDiagnosticDomain")
  #expect(customID == MessageID(domain: "ExampleDiagnosticDomain", id: "custom"))
  #expect(DefaultDiagnosticDomain.diagnosticDomainIdentifier.contains("DefaultDiagnosticDomain"))
  #expect(
    defaultID
    ==
    MessageID(
      domain: DefaultDiagnosticDomain.diagnosticDomainIdentifier,
      id: "default"
    )
  )
  #expect(String.standardMessageID == "diagnostic")
  #expect(diagnostic.message == "expected diagnostic")
  #expect(diagnostic.diagMessage.severity == .warning)
  #expect(diagnostic.diagnosticID == customID)
  #expect(diagnostic.highlights == [Syntax(node)])
  #expect(thrownError.diagnostics.count == 1)
  #expect(thrownError.diagnostics[0].diagMessage.severity == .error)
  #expect(thrownError.diagnostics[0].diagnosticID == MessageID(domain: "ExampleDiagnosticDomain", id: "thrown"))
  #expect(publicSeverityDiagnostics.map(\.diagMessage.severity) == [.warning, .note, .remark])
  #expect(publicSeverityDiagnostics.map(\.diagnosticID) == [
    MessageID(domain: "ExampleDiagnosticDomain", id: "warning"),
    MessageID(domain: "ExampleDiagnosticDomain", id: "note"),
    MessageID(domain: "ExampleDiagnosticDomain", id: "remark")
  ])
}

@Test("Macro diagnostic domain severity builders agree with generic builder")
func testMacroDiagnosticDomainSeverityBuildersAgreeWithGenericBuilder() throws {
  // Property-style test: each package-level severity helper should be a thin
  // wrapper over the generic diagnostic builder with the same node and message ID.
  let node = try StructDeclSyntax.onlyParsed(from: "struct Box {}")
  let builders: [(DiagnosticSeverity, Diagnostic)] = [
    (
      .error,
      ExampleDiagnosticDomain._diagnosticError(
        for: node,
        explanation: "message",
        messageID: "id"
      )
    ),
    (
      .warning,
      ExampleDiagnosticDomain._diagnosticWarning(
        for: node,
        explanation: "message",
        messageID: "id"
      )
    ),
    (
      .note,
      ExampleDiagnosticDomain._diagnosticNote(
        for: node,
        explanation: "message",
        messageID: "id"
      )
    ),
    (
      .remark,
      ExampleDiagnosticDomain._diagnosticRemark(
        for: node,
        explanation: "message",
        messageID: "id"
      )
    )
  ]
  
  for (severity, diagnostic) in builders {
    let generic = ExampleDiagnosticDomain.diagnostic(
      for: node,
      explanation: "message",
      severity: severity,
      messageID: "id"
    )
    
    #expect(diagnostic.message == generic.message)
    #expect(diagnostic.diagMessage.severity == severity)
    #expect(diagnostic.diagnosticID == generic.diagnosticID)
    #expect(diagnostic.node == generic.node)
  }
}

@Test("Macro expansion failures preserve nested error context")
func testMacroExpansionFailuresPreserveNestedErrorContext() {
  // Hand-written examples: failures should retain explicit source coordinates,
  // provide readable string/debug forms, and pretty-print both nested macro
  // failures and ordinary errors.
  let underlying = ExampleError(label: "underlying")
  let base = MacroExpansionFailure(
    explanation: "base failure",
    suberrors: [underlying],
    function: "expand()",
    fileID: "Tests/Diagnostics.swift",
    line: 12,
    column: 3
  )
  let nested = base.encapsulated(
    with: "outer failure",
    function: "outer()",
    fileID: "Tests/Outer.swift",
    line: 20,
    column: 5
  )
  let prettyPrinted = nested.prettyPrinted(indentation: "--", depth: 1)
  
  #expect(base.description.contains("base failure @ 12"))
  #expect(base.debugDescription.contains("MacroExpansionFailure"))
  #expect(nested.explanation == "outer failure")
  #expect(nested.suberrors.count == 2)
  #expect(prettyPrinted.contains("outer failure"))
  #expect(prettyPrinted.contains("base failure"))
  #expect(prettyPrinted.contains("ExampleError"))
  #expect(prettyPrinted.contains("underlying"))
}

@Test("Macro expansion failure automatic encapsulation handles success and errors")
func testMacroExpansionFailureAutomaticEncapsulationHandlesSuccessAndErrors() throws {
  // Property-style test: automatic encapsulation should return successful results,
  // rethrow macro expansion failures unchanged, and wrap other errors once.
  let value = try MacroExpansionFailure.withAutomaticEncapsulation(explanation: "unused") {
    "success"
  }
  let existing = MacroExpansionFailure(explanation: "existing")
  
  #expect(value == "success")
  
  do {
    _ = try MacroExpansionFailure.withAutomaticEncapsulation(explanation: "wrapper") {
      throw existing
    }
    Issue.record("Expected existing MacroExpansionFailure to be rethrown")
  } catch let failure as MacroExpansionFailure {
    #expect(failure.explanation == "existing")
    #expect(failure.suberrors.isEmpty)
  }
  
  do {
    _ = try MacroExpansionFailure.withAutomaticEncapsulation(explanation: "wrapper") {
      throw ExampleError(label: "plain")
    }
    Issue.record("Expected plain error to be wrapped")
  } catch let failure as MacroExpansionFailure {
    #expect(failure.explanation == "wrapper")
    #expect(failure.suberrors.count == 1)
  }
}

@Test("Diagnostic string interpolation reindents multiline text")
func testDiagnosticStringInterpolationReindentsMultilineText() {
  // Hand-written examples: empty indentation should leave input unchanged, while
  // explicit indentation and depth-based indentation should prefix every line.
  #expect("\(reindenting: "first\nsecond", with: "")" == "first\nsecond")
  #expect("\(reindenting: "first\nsecond", with: "  ")" == "  first\n  second")
  #expect("\(reindenting: "first\nsecond", indentation: ">", depth: 2)" == ">>first\n>>second")
}

@Test("Macro expansion context diagnostic conveniences record expected diagnostics")
func testMacroExpansionContextDiagnosticConveniencesRecordExpectedDiagnostics() throws {
  // Hand-written examples: optional and sequence diagnostics should only record
  // concrete diagnostics, and `recordDiagnostic` should build an HDXL diagnostic
  // anchored to the subject node when one is supplied.
  let node = try StructDeclSyntax.onlyParsed(from: "struct Box { var value: Int }")
  let subjectNode = try #require(node.memberBlock.firstSyntaxElement(ofType: VariableDeclSyntax.self))
  let context = RecordingMacroExpansionContext()
  let diagnostic = ExampleDiagnosticDomain.diagnostic(
    for: node,
    explanation: "first",
    severity: .warning,
    messageID: "first"
  )
  
  context.diagnose(possibleDiagnostic: nil)
  context.diagnose(possibleDiagnostic: diagnostic)
  context.diagnose(diagnostics: [diagnostic, diagnostic])
  context.diagnose(possibleDiagnostics: Optional([diagnostic]))
  
  let noDiagnostics: [Diagnostic]? = nil
  context.diagnose(possibleDiagnostics: noDiagnostics)
  context.recordDiagnostic(
    attributionNode: node,
    subjectNode: subjectNode,
    severity: .error,
    domainID: "RecordedDomain",
    messageID: "recorded",
    explanation: "recorded message",
    highlights: [Syntax(subjectNode)]
  )
  
  #expect(context.diagnostics.count == 5)
  #expect(context.diagnostics.last?.message == "recorded message")
  #expect(context.diagnostics.last?.diagMessage.severity == .error)
  #expect(context.diagnostics.last?.diagnosticID == MessageID(domain: "RecordedDomain", id: "recorded"))
  #expect(context.diagnostics.last?.position == subjectNode.positionAfterSkippingLeadingTrivia)
  #expect(context.diagnostics.last?.highlights == [Syntax(subjectNode)])
}

@Test("Macro expansion context source-location strategy uses explicit or automatic locations")
func testMacroExpansionContextSourceLocationStrategyUsesExplicitOrAutomaticLocations() throws {
  // Property-style test: explicit source-location strategies should return the
  // supplied location directly, while automatic strategies should delegate to the
  // macro expansion context with the strategy's requested position and file mode.
  let node = try StructDeclSyntax.onlyParsed(from: "struct Box {}")
  let context = RecordingMacroExpansionContext()
  let explicitLocation = AbstractSourceLocation(
    SourceLocation(line: 2, column: 3, offset: 1, file: "explicit.swift")
  )
  let explicitResult = context.abstractSourceLocation(
    attributionNode: node,
    position: .explicit(explicitLocation)
  )
  let automaticResult = context.abstractSourceLocation(
    attributionNode: node,
    position: .standard
  )
  let customResult = context.abstractSourceLocation(
    attributionNode: node,
    position: .automatic(
      AbstractSourceLocationStrategy(
        positionInSyntaxNode: .afterTrailingTrivia,
        filePathMode: .fileID
      )
    )
  )
  
  #expect(explicitResult?.file.description.contains("explicit.swift") == true)
  #expect(automaticResult?.file.description.contains("automatic.swift") == true)
  #expect(customResult?.line.description == "9")
  #expect(context.locationRequests.map(\.position) == [.afterLeadingTrivia, .afterTrailingTrivia])
  #expect(context.locationRequests.map(\.filePathMode) == [.filePath, .fileID])
}

private enum ExampleDiagnosticDomain: MacroDiagnosticDomain {
  static let diagnosticDomainIdentifier = "ExampleDiagnosticDomain"
}

private enum DefaultDiagnosticDomain: MacroDiagnosticDomain {}

private struct ExampleError: Error, CustomDebugStringConvertible {
  var label: String
  
  var debugDescription: String {
    "ExampleError(\(label))"
  }
}

private final class RecordingMacroExpansionContext: MacroExpansionContext {
  var diagnostics: [Diagnostic] = []
  var locationRequests: [(position: PositionInSyntaxNode, filePathMode: SourceLocationFilePathMode)] = []
  var lexicalContext: [Syntax] = []
  
  func makeUniqueName(_ name: String) -> TokenSyntax {
    .identifier("__\(name)")
  }
  
  func diagnose(_ diagnostic: Diagnostic) {
    diagnostics.append(diagnostic)
  }
  
  func location(
    of node: some SyntaxProtocol,
    at position: PositionInSyntaxNode,
    filePathMode: SourceLocationFilePathMode
  ) -> AbstractSourceLocation? {
    locationRequests.append((position, filePathMode))
    
    return AbstractSourceLocation(
      SourceLocation(
        line: locationRequests.count == 1 ? 7 : 9,
        column: locationRequests.count == 1 ? 8 : 10,
        offset: locationRequests.count,
        file: "automatic.swift"
      )
    )
  }
}
