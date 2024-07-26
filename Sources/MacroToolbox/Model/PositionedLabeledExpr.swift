import SwiftSyntax


public struct PositionedLabeledExpression {
  
  public var positionIndex: Int
  public var peerCount: Int
  public var labeledExpression: LabeledExprSyntax
  
  @inlinable
  public init(
    positionIndex: Int,
    peerCount: Int,
    labeledExpression: LabeledExprSyntax
  ) {
    self.positionIndex = positionIndex
    self.peerCount = peerCount
    self.labeledExpression = labeledExpression
  }
  
}


