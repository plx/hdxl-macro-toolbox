import SwiftSyntax

extension EnumCaseDeclSyntax {
  
  /// `true` if this case is a payload-less case (e.g. `.foo`).
  @inlinable
  public var isSimpleCaseWithoutPayload: Bool {
    elements.isSimpleCaseWithoutPayload
  }
  
  /// `true` if this case has been annotated with the attribute named `attributeName`.
  @inlinable
  public func hasAttribute(named attributeName: String) -> Bool {
    attributes.containsAttribute(named: attributeName)
  }
    
  /// Returns the name of this enumeration case, *assuming* that it's a single-case declaration.
  ///
  /// - note:
  ///
  /// Swift supports declaring multiple cases in a single case declaration, e.g. like this:
  ///
  /// ```swift
  /// private enum Example {
  ///   case foo, bar, baz
  /// }
  /// ```
  ///
  /// I make no attempt to handle this construct at this time, and thus this method will return
  /// `nil` in such cases.
  @inlinable
  public var primarySourceCodeIdentifier: TokenSyntax? {
    elements.primarySourceCodeIdentifier
  }
  
  #if ACTUALLY_COMPILE_SYNTAX_EXAMPLES
  private enum Example {
    case foo, bar, baz
  }
  #endif
  
}
