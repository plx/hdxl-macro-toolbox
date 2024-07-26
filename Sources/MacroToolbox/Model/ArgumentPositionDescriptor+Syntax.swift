import SwiftSyntax

extension PositionedLabeledExpression {
  
  @inlinable
  public func isCompatible(with positionDescriptor: ArgumentPositionDescriptor) -> Bool {
    switch positionDescriptor {
    case .solitary:
      positionIndex == 0 && peerCount == 1
    case .relativeToFirst(let offsetFromFirst):
      positionIndex == offsetFromFirst && offsetFromFirst < peerCount
    case .relativeToLast(let offsetFromLast):
      positionIndex == peerCount - (offsetFromLast + 1)
    }
  }
  
}

extension LabeledExprListSyntax {
  
  @inlinable
  public var positionedLabeledExpressions: some Sequence<PositionedLabeledExpression> {
    let peerCount = self.count
    
    return enumerated()
      .lazy
      .map { (positionIndex, labeledExpression) in
        PositionedLabeledExpression(
          positionIndex: positionIndex,
          peerCount: peerCount,
          labeledExpression: labeledExpression
        )
      }
  }
  
  @inlinable
  public func firstElement(
    compatibleWith positionDescriptor: ArgumentPositionDescriptor
  ) -> LabeledExprSyntax? {
    positionedLabeledExpressions.first {
      $0.isCompatible(with: positionDescriptor )
    }?.labeledExpression
  }

  @inlinable
  public func countOfElements(
    compatibleWith positionDescriptor: ArgumentPositionDescriptor
  ) -> Int {
    var count: Int = 0
    for positionedLabeledExpression in positionedLabeledExpressions where positionedLabeledExpression.isCompatible(with: positionDescriptor) {
      count += 1
    }
    
    return count
  }

}
