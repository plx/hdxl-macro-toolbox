import MacroToolboxModels
import SwiftSyntax

extension SyntaxCollection where Element: WithTrailingCommaSyntax {
  
  /// Constructs a `SyntaxCollection` from `children`, taking care to insert a `,` between adjacent children.
  ///
  /// - note:
  ///
  /// This exists b/c if you use "raw" `SwiftSyntax`, you can have code like this:
  ///
  /// ```swift
  /// let syntaxCollection = FooListSyntax(
  ///   items.map(FooListItemSyntax(item:))
  /// )
  /// ```
  ///
  /// ...only to wind up producing invalid syntax b/c:
  ///
  /// - `FooListItemSyntax` has responsibility for both the individual items *and* their attachments like trailing commas, etc.
  /// - `FooListItemSyntax(item:)` constructs item-level syntax, but (reasonably) doesn't deal with commas (etc.) (b/c those are container-level issues)
  /// - `FooListSyntax` (reasonably) uses its arguments exactly as supplied, and thus doesn't e.g. insert commas on its own
  ///
  /// As such, it makes sense to place the comma-insertion logic here, rather than, say, having it creep into item-level constructors
  /// like `FooListItemSyntax`; this allows for cleaner code at the use-site *and* avoids redundant reimplementations of this
  /// very basic comma-insertion-logic.
  /// Inserts a comma with one trailing space when absent, retains existing comma trivia,
  /// and removes the final comma while moving its trivia onto the final element.
  /// Input nodes are values and remain unchanged. This low-level helper does not validate
  /// recovery syntax; throwing construction entry points validate before normalization.
  @inlinable
  public init(withTrailingCommasInsertedBetween children: some Collection<Element>) {
    let finalElementIndex = children.count - 1
    self.init(
      children.enumerated().map { (index, element) in
        var result = element
        switch index >= finalElementIndex {
        case true:
          let commaTrivia = result.trailingComma.map { $0.leadingTrivia + $0.trailingTrivia } ?? Trivia()
          result.trailingComma = nil
          result.trailingTrivia += commaTrivia
        case false:
          if result.trailingComma == nil {
            result.trailingComma = TokenSyntax.commaToken(trailingTrivia: .space)
          }
        }
        
        return result
      }
    )
  }
  
}
