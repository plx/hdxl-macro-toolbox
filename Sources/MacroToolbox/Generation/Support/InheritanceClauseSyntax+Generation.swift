import SwiftSyntax

extension InheritanceClauseSyntax {
  
  /// Emits an inheritance clause for a type inheriting-from the names in `inheritedTypeNames`.
  ///
  /// In other words:
  ///
  /// - input: `["BaseClass", "Equatable", "Sendable"]`
  /// - output: `BaseClass, Equatable, Sendable` (except as an `InheritanceClauseSyntax`).
  ///
  @inlinable
  public static func forInheritedTypeNames(_ inheritedTypeNames: some Sequence<String>)-> Self {
    InheritanceClauseSyntax(
      inheritedTypes: .forTypeNames(inheritedTypeNames)
    )
  }
  
}
