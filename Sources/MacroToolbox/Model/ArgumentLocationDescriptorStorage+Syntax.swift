import SwiftSyntax

extension PositionedLabeledExpression {
  
  @inlinable
  internal func isCompatible(with locationDescriptorStorage: ArgumentLocationDescriptorStorage) -> Bool {
    switch locationDescriptorStorage {
    case .position(let position):
      isCompatible(with: position)
    case .label(let label):
      isCompatible(with: label)
    case .positionAndLabel(let position, let label):
      isCompatible(with: position) && isCompatible(with: label)
    }
  }
  
}
