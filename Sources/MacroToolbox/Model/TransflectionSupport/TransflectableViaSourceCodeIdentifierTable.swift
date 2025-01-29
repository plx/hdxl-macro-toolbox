import MacroTransflection

// ------------------------------------------------------------------------- //
// MARK: TransflectableViaSourceCodeIdentifierTable
// ------------------------------------------------------------------------- //

/// ``TransflectableViaSourceCodeIdentifierTable`` is an internal utlity that only exists to simplify conforming to `TransflectableViaSourceCodeIdentifier` within `MacroToolbox`.
///
/// The tl;dr: in general, you should use the `@AddSourceCodeIdentifierTransflection` macro from `MacroTransflectionMacros`
/// to synthesize conformance to `TransflectableViaSourceCodeIdentifier`.
///
/// We can't use that macro within `MacroToolbox` itself, however, b/c `MacroTransflectionMacros` has a dependency on `MacroToolbox`.
///
/// As such, we have this protocol for use *within* `MacroToolbox` itself.
///
/// In practice, it works out like this:
///
/// ```swift
/// // this is all you need to write to get the conformance:
/// extension SomeTransflectableEnum: TransflectableViaSourceCodeIdentifier, TransflectableViaSourceCodeIdentifierTable {
///   @usableFromInline
///   internal static let sourceCodeIdentifierTransflectionTable = _inferred
/// }
/// ```
///
/// ...which works out ok as long as:
///
/// - `SomeTransflectableEnum` is `CaseIterable`
/// - `SomeTransflectableEnum`conforms to `MacroToolboxCaseNameAwareEnumeration`
/// - `SomeTransflectableEnum` has no cases that need exclusion or other "special handling"
///
/// ...which happen to be common with `MacroToolbox` and rare elsewhere.
@usableFromInline
internal protocol TransflectableViaSourceCodeIdentifierTable : TransflectableViaSourceCodeIdentifier {
  
  var sourceCodeIdentifierForTransflection: String { get }
  
  static var sourceCodeIdentifierTransflectionTable: [String: Self] { get }
}

// ------------------------------------------------------------------------- //
// MARK: - TransflectableViaSourceCodeIdentifier Overrides
// ------------------------------------------------------------------------- //

extension TransflectableViaSourceCodeIdentifierTable {
  
  @inlinable
  public init(transflectingSourceCodeIdentifier sourceCodeIdentifier: String) throws {
    switch Self.sourceCodeIdentifierTransflectionTable[sourceCodeIdentifier] {
    case .some(let transflectedValue):
      self = transflectedValue
    case .none:
      throw SourceCodeIdentifierTransflectionError.unrecognizedSourceCodeIdentifier(
        """
        Unable to transflect \(Self.self) from unrecognized source-code identifier `\(sourceCodeIdentifier)`!
        """
      )
    }
  }
  
}

// ------------------------------------------------------------------------- //
// MARK: - Table Inference
// ------------------------------------------------------------------------- //

extension TransflectableViaSourceCodeIdentifierTable where Self: CaseIterable {
  
  @inlinable
  internal static var sourceCodeIdentifierTransflectionTable: [String: Self] { _inferred}
  
  @inlinable
  internal static var _inferred: [String: Self] {
    [String:Self](
      uniqueKeysWithValues: allCases
        .lazy
        .map { value in
          (value.sourceCodeIdentifierForTransflection, value)
        }
    )
  }
  
}

// ------------------------------------------------------------------------- //
// MARK: - Implementation Synthesis
// ------------------------------------------------------------------------- //

extension TransflectableViaSourceCodeIdentifierTable where Self: MacroToolboxCaseNameAwareEnumeration {
  
  @inlinable
  internal var sourceCodeIdentifierForTransflection: String {
    caseNameWithLeadingDot
  }
}
