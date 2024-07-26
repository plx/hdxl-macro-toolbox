import SwiftSyntax

extension PositionedLabeledExpression {
  
  @inlinable
  public func isCompatible(with locationDescriptor: ArgumentLocationDescriptor) -> Bool {
    isCompatible(with: locationDescriptor.storage)
  }
  
}
