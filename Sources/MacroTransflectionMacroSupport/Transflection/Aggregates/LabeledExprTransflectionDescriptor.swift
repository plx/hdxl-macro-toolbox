import SwiftSyntax
import MacroToolbox

public struct LabeledExprTransflectionDescriptor<T> {
  
  public var transflectedType: T.Type
  public var labelCriterion: LabelCriterion
  
  @inlinable
  public init(
    transflectedType: T.Type,
    labelCriterion: LabelCriterion
  ) {
    self.transflectedType = transflectedType
    self.labelCriterion = labelCriterion
  }
  
}
