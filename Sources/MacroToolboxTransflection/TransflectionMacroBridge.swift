import MacroToolbox
import MacroToolboxSyntax
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros
import ValueTransflection
import ExpansionTimeTransflection

/// An input failure retaining the core reason/path/cause and the original host syntax sidecar.
/// No diagnostic is emitted by decoding. This is not another expression or failure-path format.
public struct TransflectionDecodingFailure: DeferredMacroError, TransflectionFailureProviding {
  public let sourceRoot: Syntax
  public let locatedFailure: SourceLocatedTransflectionFailure
  public var transflectionFailure: TransflectionFailure { locatedFailure.failure }

  public init(error: any Error, sourceRoot: some SyntaxProtocol) {
    self.sourceRoot = Syntax(sourceRoot)
    locatedFailure = TransflectionSourceMap(root: sourceRoot).failure(for: error)
  }
}

/// Optional host conveniences over the core's normal decoder and source cursor. These helpers
/// never select an initializer, bind a schema, interpret defaults, or retry an asymmetric decoder.
public enum TransflectionMacroBridge {
  public static func decode<Value: TransflectableFromTransflectionExpression>(
    _ expression: ExprSyntax, as type: Value.Type
  ) throws -> Value {
    do { return try expression.transflectValue(as: type) }
    catch { throw contextualized(error, at: expression) }
  }

  public static func decodeArgument<Value: TransflectableFromTransflectionExpression>(
    at index: Int, in attribute: AttributeSyntax, as type: Value.Type
  ) throws -> Value {
    do { return try attribute.transflectValueArgument(at: index, as: type) }
    catch { throw contextualized(error, at: attribute) }
  }

  public static func decodeArgument<Value: TransflectableFromTransflectionExpression>(
    at index: Int, in invocation: some FreestandingMacroExpansionSyntax, as type: Value.Type
  ) throws -> Value {
    do { return try invocation.transflectValueArgument(at: index, as: type) }
    catch { throw contextualized(error, at: invocation) }
  }

  /// An explicit caller-selected syntax decoder. Its failure has the same source/diagnostic
  /// contract as ordinary decoding; this method is never a fallback from `decode`.
  public static func decodeAsymmetrically<Source: SyntaxProtocol, Value>(
    _ source: Source, using decoder: (Source) throws -> Value
  ) throws -> Value {
    do { return try decoder(source) }
    catch { throw contextualized(error, at: source) }
  }

  /// Construct a diagnostic without emission. Explicit presentation details are retained.
  public static func diagnostic(
    for failure: TransflectionDecodingFailure, details: MacroDiagnosticDetails
  ) -> Diagnostic {
    let report = failure.locatedFailure
    let anchor = report.source.anchor ?? failure.sourceRoot
    var notes: [Note] = []
    if !report.failure.path.isEmpty {
      notes.append(Note(node: failure.sourceRoot, message: BridgeNote(
        message: "Decoding path: " + report.failure.path.map(pathDescription).joined(separator: " → "), id: "decoding-path"
      )))
    }
    if !report.source.isExact {
      notes.append(Note(node: anchor, message: BridgeNote(
        message: "No source child exists at this path; the diagnostic uses the enclosing expression.", id: "enclosing-source"
      )))
    }
    return details.diagnostic(at: anchor, additionalNotes: notes)
  }

  /// Terminal emission owner with an explicit caller-chosen replacement. It consumes failures
  /// instead of rethrowing after emission. This also supports warning/note severities without
  /// Swift's throwing-macro machinery adding an unrelated generic error. Member/extension
  /// macros normally pass an empty array; expression macros must choose their own valid fallback.
  public static func withDiagnostics<Output>(
    in context: some MacroExpansionContext, at invocation: some SyntaxProtocol,
    details: MacroDiagnosticDetails, failureValue: @autoclosure () -> Output,
    debugUnexpectedError: ((any Error) -> Void)? = nil,
    _ operation: () throws -> Output
  ) -> Output {
    do { return try operation() }
    catch {
      if let failure = decodingFailure(in: error) {
        context.diagnose(diagnostic(for: failure, details: details))
      } else if let diagnostics = deferredMacroDiagnostics(in: error) {
        for diagnostic in diagnostics { context.diagnose(diagnostic) }
      } else if error is any TransflectionFailureProviding {
        context.diagnose(diagnostic(for: .init(error: error, sourceRoot: invocation), details: details))
      } else {
        // Unexpected implementation errors keep their original debug object and a distinct ID;
        // implementation filenames/lines are not exposed in the normal user-facing diagnostic.
        debugUnexpectedError?(error)
        context.diagnose(MacroDiagnosticDetails(
          message: "Macro expansion failed unexpectedly.", domain: "MacroToolboxTransflection",
          messageID: "unexpected-implementation-error"
        ).diagnostic(at: invocation))
      }
      return failureValue()
    }
  }

  private static func decodingFailure(in error: any Error) -> TransflectionDecodingFailure? {
    if let failure = error as? TransflectionDecodingFailure { return failure }
    if let failure = error as? MacroExpansionFailure {
      for cause in failure.suberrors {
        if let nested = decodingFailure(in: cause) { return nested }
      }
    }
    return nil
  }

  fileprivate static func contextualized(_ error: any Error, at source: some SyntaxProtocol) -> any Error {
    if let deferred = deferredMacroError(in: error) { return deferred }
    if let diagnostics = deferredMacroDiagnostics(in: error) { return DiagnosticsError(diagnostics: diagnostics) }
    return TransflectionDecodingFailure(error: error, sourceRoot: source)
  }
}

extension MacroContextProtocol {
  /// Contextualized adapter to the same ordinary value route. It neither emits nor caches.
  public func decodeValueArgument<Value: TransflectableFromTransflectionExpression>(
    at index: Int, as type: Value.Type
  ) throws -> Value {
    do {
      guard let arguments = invocationArgumentsAsLabeledExpressionList else {
        throw ValueArgumentTransflectionError.notAnArgumentList
      }
      return try arguments.transflectValueArgument(at: index, as: type)
    } catch { throw TransflectionMacroBridge.contextualized(error, at: macroInvocationNode) }
  }

  public func withTransflectionDiagnostics<Output>(
    details: MacroDiagnosticDetails, failureValue: @autoclosure () -> Output,
    debugUnexpectedError: ((any Error) -> Void)? = nil,
    _ operation: () throws -> Output
  ) -> Output {
    TransflectionMacroBridge.withDiagnostics(
      in: expansionContext, at: macroInvocationNode, details: details, failureValue: failureValue(),
      debugUnexpectedError: debugUnexpectedError, operation
    )
  }
}

private struct BridgeNote: NoteMessage {
  let message: String
  let id: String
  var noteID: MessageID { .init(domain: "MacroToolboxTransflection", id: id) }
}

/// Human-readable presentation of existing core path components, not a second path model.
private func pathDescription(_ component: TransflectionPathComponent) -> String {
  func parameter(_ parameter: TransflectionParameter?, sourceIndex: Int?) -> String {
    let declared = parameter.map { "parameter \($0.index) (\($0.label ?? "unlabeled"))" } ?? "argument"
    return declared + (sourceIndex.map { ", source argument \($0)" } ?? ", omitted")
  }
  switch component {
  case .constructorArgument(let name, let declared, let source): return name + " " + parameter(declared, sourceIndex: source)
  case .enumPayload(let name, let member, let declared, let source): return name + "." + member + " " + parameter(declared, sourceIndex: source)
  case .macroArgument(let index, let label): return "macro argument \(index) (\(label ?? "unlabeled"))"
  case .callArgument(let index, let label): return "call argument \(index) (\(label ?? "unlabeled"))"
  case .arrayElement(let index): return "array element \(index)"
  case .setElement(let index): return "set element \(index)"
  case .dictionaryKey(let index): return "dictionary key \(index)"
  case .dictionaryValue(let index): return "dictionary value \(index)"
  case .optionalWrapped: return "optional value"
  case .label: return "label"
  case .callee: return "callee"
  case .memberBase: return "member base"
  case .memberName: return "member name"
  case .arguments: return "arguments"
  case .signedOperand: return "signed operand"
  case .trailingClosure(let index): return "trailing closure \(index)"
  }
}
