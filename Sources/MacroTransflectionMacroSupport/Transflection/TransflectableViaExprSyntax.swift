import SwiftSyntax
import MacroTransflection

/// Types conforrming to ``TransflectableViaExprSyntax`` can be transflected into concrete values *from* their source-code representations.
///
/// For a simple example, consider `Bool`: given an expression contain a boolean literal like `true`, we can "transflect" that back into the boolean value `true`.
public protocol TransflectableViaExprSyntax {

  /// Constructs the value represented-by `exprSyntax`, or throws a suitable error.
  ///
  /// - Parameters:
  ///   - exprSyntax: the expression for-which we'll be attempting transflection
  /// - Returns: a concrete value corresponding-to the contents of `exprSyntax`
  /// - Throws: an error explaining why transflection failed
  ///
  /// - Note:
  ///
  /// An earlier design included a strongly-typed refinement (e.g. `associatedtype Expression: ExprSyntaxProtocol` w/corresponding strongly-typed`init`).
  ///
  /// This proved to be a mistake, b/c most concrete types can be represented by multiple distinct types of expression.
  /// For example, the numeric types required handling *at least* their value-literal expression, a member-access expression,
  /// and an infix-operator expression; optionals required handling function-call expressions, nil-literal expressions, and so on.
  ///
  /// You get the idea.
  ///
  /// As such, this protocol will stick to using the type-erased lowest-common-denominator, and there are no current plans to
  /// reintroduce any kind of more-strongly-typed refinement of this concept.
  init(transflectingExprSyntax exprSyntax: ExprSyntax) throws
  
}
