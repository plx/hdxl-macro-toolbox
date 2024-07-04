
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
  /// This protocol has some subtlety around `.nan` and `.infinity` (etc.) that's a bit
  /// unintuitive and, thus, worth documenting in case it presents some future issue.
  ///
  /// The subtlety arises in two parts.
  ///
  /// The first half is that, per Swift's grammar, a symbol like `.infinity` isn't a float literal:
  ///
  /// ```swift
  /// let foo: Double = 0.124125 // <- float literal
  /// let bar: Double = .infinity // <- "member access" (e.g. of `Double`'s static member `.nan`)
  /// ```
  ///
  /// ...which might make it tempting to conclude that float literalys will only ever be "finite" and "numeric."
  ///
  /// That's tempting, but wrong—let's see why.
  ///
  /// The other half is that in addition to numerical float literals, Swift also allows hexadecimal float literals.
  ///
  /// Allowing hexadecimal literals means that one could, in principle, "spell out" any specific `Double` value,
  /// including e.g. `.nan` or `.infinity` (etc.).
  ///
  /// As such, this protocol requires handling even those non-numeric floating-point literals.
  init(transflectingFloatLiteralValue floatLiteralValue: Double) throws
  
}
