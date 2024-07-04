
/// ``InlinabilityAnnotableDeclarationType`` corresponds to the distinct declaration-types to-which one of the inlinability attributes may be applied.
///
/// - note: These contexts are an ad-hoc characterization and, as such, may need additional refinement over time.
public enum InlinabilityAnnotableDeclarationType {
  
  /// Corresponds to type-level declarations (including typealiases, too).
  ///
  /// Here are some examples:
  ///
  /// ```swift
  /// @usableFromInline
  /// package protocol X { }
  ///
  /// class Foo {
  ///   @usableFromInline
  ///   internal typealias Bar = Baz
  /// }
  /// ```
  ///
  case typeDeclaration
  
  /// Corresponds specifically to *stored properties*.
  ///
  /// Here is an example:
  ///
  /// ```swift
  /// @usableFromInline
  /// package var foo: Foo
  /// ```
  ///
  case storedPropertyDeclaration
  
  /// Corresponds specifically to functions or methods (including `init`s, too).
  ///
  /// Here is an example:
  ///
  /// ```swift
  /// @inlinable package func foo(_ bar: Bar) { /* */ }
  /// ```
  case functionOrMethodDeclaration
}

extension InlinabilityAnnotableDeclarationType: Sendable {}
extension InlinabilityAnnotableDeclarationType: Equatable {}
extension InlinabilityAnnotableDeclarationType: Hashable {}
extension InlinabilityAnnotableDeclarationType: CaseIterable {}
extension InlinabilityAnnotableDeclarationType: Codable {}
extension InlinabilityAnnotableDeclarationType: CustomStringConvertible { }
extension InlinabilityAnnotableDeclarationType: CustomDebugStringConvertible { }

extension InlinabilityAnnotableDeclarationType: MacroToolboxCaseNameAwareEnumeration {
  
  @inlinable
  public var caseNameWithoutLeadingDot: String {
    switch self {
    case .typeDeclaration:
      "typeDeclaration"
    case .storedPropertyDeclaration:
      "storedPropertyDeclaration"
    case .functionOrMethodDeclaration:
      "functionOrMethodDeclaration"
    }
  }
  
}
