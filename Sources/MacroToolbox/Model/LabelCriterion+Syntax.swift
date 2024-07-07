import SwiftSyntax

extension LabeledExprSyntax {
  
  @inlinable
  public func satisfies(
    labelCriterion: LabelCriterion
  ) -> Bool {
    switch labelCriterion {
    case .unspecified:
      return true
    case .mustBeNil:
      return label == nil
    case .exactly(let labelName):
      guard let label else {
        return false
      }
      return label.text == labelName
    }
  }
  
}

extension LabeledExprListSyntax {
  
  @inlinable
  public func satisfies(
    labelCriteria: some Collection<LabelCriterion>
  ) -> Bool {
    guard labelCriteria.count == count else {
      return false
    }
    
    return zip(
      self,
      labelCriteria
    ).allSatisfy { labeledExpr, labelCriterion in
      labeledExpr.satisfies(
        labelCriterion: labelCriterion
      )
    }
  }
  
}
