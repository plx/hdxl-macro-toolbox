import SwiftSyntax
import MacroToolbox
import MacroTransflection

public struct MacroTransflectionAggregate<each T: TransflectableViaExprSyntax> {
  
  public let components: (repeat each T)
  
  @inlinable
  internal init(components: (repeat each T)) {
    self.components = components
  }
  
  public static var componentCount: Int {
    var count = 0
    for _ in repeat (each T).self {
      count += 1
    }
    return count
  }
  
}

extension MacroTransflectionAggregate: TransflectableViaExprSyntax {
  
  @inlinable
  public init(transflectingLabeledExprListSyntax labeledExprListSyntax: LabeledExprListSyntax) throws {
    guard labeledExprListSyntax.count == Self.componentCount else {
      fatalError()
    }
    var index: Int = 0
    self.init(
      components: (
        repeat try labeledExprListSyntax.transflectElementWithIndexAdvancement(
          asType: (each T).self,
          at: &index
        )
      )
    )
  }
  
  @inlinable
  public init(transflectingArgumentsOf attributeSyntax: AttributeSyntax) throws {
    guard let argumentList = attributeSyntax.argumentListAsLabeledExprList else {
      fatalError()
    }
    
    try self.init(transflectingLabeledExprListSyntax: argumentList)
  }

  @inlinable
  public init(transflectingArgumentsOf freestandingMacroExpansionSyntax: some FreestandingMacroExpansionSyntax) throws {
    try self.init(transflectingLabeledExprListSyntax: freestandingMacroExpansionSyntax.arguments)
  }

  @inlinable
  public init(transflectingExprSyntax exprSyntax: ExprSyntax) throws {
    guard
      let tupleLiteral = exprSyntax.as(TupleExprSyntax.self) 
    else {
      fatalError()
    }
    try self.init(transflectingLabeledExprListSyntax: tupleLiteral.elements)
  }
}

extension LabeledExprSyntax {
  
  @inlinable
  internal func transflectElement<T>(
    asType type: T.Type
  ) throws -> T where T: TransflectableViaExprSyntax {
    try T(transflectingExprSyntax: expression)
  }
}
