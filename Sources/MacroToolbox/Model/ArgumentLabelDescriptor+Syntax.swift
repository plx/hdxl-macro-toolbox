import SwiftSyntax

extension PositionedLabeledExpression {
  
  /// Returns `true` iff this ``PositionedLabeledExpression`` is compatible-with `argumentLabelDescriptor`.
  ///
  /// Recall that ``PositionedLabeledExpression`` is a `LabeledExprSyntax` along with information
  /// about the argument position. What this method is checking is whether-or-not that `LabeledExprSyntax`
  /// is compatible with `argumentLabelDescriptor`:
  ///
  /// - `x` and `.unlabeled` would be compatible
  /// - `foo: bar` and `.labeled("foo")` would be compatible
  /// - `x` and `.labeled("foo")` would *not* be compatible
  ///
  @inlinable
  public func isCompatible(with argumentLabelDescriptor: ArgumentLabelDescriptor) -> Bool {
    switch argumentLabelDescriptor {
    case .unlabeled:
      return labeledExpression.label == nil
    case .labeled(let labelText):
      guard let label = labeledExpression.label else {
        return false
      }
      
      return label.text == labelText
    }
  }
  
}
