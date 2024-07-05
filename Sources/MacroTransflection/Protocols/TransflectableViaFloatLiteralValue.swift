
/// Protocol for types that can be transflected via float literal values.
public protocol TransflectableViaFloatLiteralValue {
  
  /// Constructs a transflected value via literal-value representation.
  ///
  /// - Parameters:
  ///   - floatLiteralValue: The value represented by some float-literal.
  ///
  /// - warning: `floatLiteralValue` may be finite, infinite, or even non-numeric.
  ///
  /// - note:
  ///
  /// For this type, we're using "literal value" in a sense that's at odds with that of Swift's formal grammar,
  /// but IMHO also correct-and-intuitive for our intended use case.
  ///
  /// When writing Swift code, both of these look like literal floating point values:
  ///
  /// ```
  /// let foo: Double = 0.124125
  /// let bar: Double = .nan
  /// ```
  ///
  /// ...but that's actually incorrect.
  ///
  /// The truth is, although `foo` is a floating-point literal, `bar` is what's called a member-access expression,
  /// the same as e.g. `object.description` or `Enum.case` (etc.); what makes `.nan` special here is
  /// just that it's such a well-known value that it "feels" like a literal.
  ///
  /// If we were strictly aligning ourselves with Swift's formal grammar, the sensible thing here would be to stipulate
  /// that `literalValue` would always be finite and numeric.
  ///
  /// Since we're trying to "transflect" values source annotations into the macro-expansion environment, however,
  /// IMHO it makes sense to try to handle those special values like `.nan` (etc.)...and that's why, tl;dr, you are
  /// expected to handle `.nan` and `.infinity` here, too.
  init(transflectingFloatLiteralValue floatLiteralValue: Double) throws
  
}
