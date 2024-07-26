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
  
  /// Type-level property listing the set of explicit type names recognized for transflection.
  ///
  /// - note:
  ///
  /// For many types we want to support transflecting at least some predefined set of static properties,
  /// e.g. `.pi` or `.zero` (etc.). The challenge, there, is twofold:
  ///
  /// 1. such properties can be written in multiple ways (`.pi` and `Double.pi`)
  /// 2. some types have syntactic-sugar variants (e.g. `[T]` and `Array<T>`, etc.)
  ///
  /// ...whence the existence of this property: it gives us a way to customize the set of explicit type-name
  /// spellings a particular transflectable type should recognize.
  static var translectionTypeNamesForStaticMemberAccessSyntax: Set<String> { get }
  
}

extension TransflectableViaExprSyntax {

  public static var translectionTypeNamesForStaticMemberAccessSyntax: Set<String> {
    [String(describing: self)]
  }
}