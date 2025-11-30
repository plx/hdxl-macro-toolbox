
// MARK: PerformanceAnnotationAttachmentSite

/// ``PerformanceAnnotationAttachmentSite`` corresponds to the distinct declaration-types to-which the "performance annotations" could be attached.
///
/// - note: These contexts are an ad-hoc characterization and, as such, may need additional refinement over time.
public enum PerformanceAnnotationAttachmentSite {
  
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

// MARK: - Synthesized Conformances

extension PerformanceAnnotationAttachmentSite: Sendable {}
extension PerformanceAnnotationAttachmentSite: Equatable {}
extension PerformanceAnnotationAttachmentSite: Hashable {}
extension PerformanceAnnotationAttachmentSite: CaseIterable {}
extension PerformanceAnnotationAttachmentSite: Codable {}
extension PerformanceAnnotationAttachmentSite: CustomStringConvertible { }
extension PerformanceAnnotationAttachmentSite: CustomDebugStringConvertible { }

// MARK: - MacroToolboxCaseNameAwareEnumeration

extension PerformanceAnnotationAttachmentSite: MacroToolboxCaseNameAwareEnumeration {
  
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
