import SwiftSyntax
import MacroTransflection

extension LabeledExprListSyntax {
  
  @inlinable
  public func transflectElements<each T: TransflectableViaExprSyntax>(
    as types: (repeat (each T).Type)
  ) throws -> (repeat each T) {
    var transflectedTupleSize: Int = 0
    for _ in repeat each types {
      transflectedTupleSize += 1
    }
    
    guard transflectedTupleSize == count else {
      fatalError()
    }
    
    var index: Int = 0
    return (
      repeat try transflectElementWithIndexAdvancement(
        asType: each types,
        at: &index
      )
    )
  }
  
}

extension LabeledExprListSyntax {
  
  @inlinable
  internal func transflectElementWithIndexAdvancement<T>(
    asType type: T.Type,
    at index: (inout Int)
  ) throws -> T where T: TransflectableViaExprSyntax {
    defer { index += 1 }
    
    return try transflectElement(
      asType: type,
      at: index
    )
  }
  
  @inlinable
  internal func transflectElement<T>(
    asType type: T.Type,
    at index: Int
  ) throws -> T where T: TransflectableViaExprSyntax {
    try labeledExpression(
      forLinearIndex: index
    ).transflectElement(
      asType: type
    )
  }

  @inlinable
  internal func labeledExpression(
    forLinearIndex linearIndex: Int
  ) throws -> LabeledExprSyntax {
    guard (0..<count).contains(linearIndex) else {
      fatalError()
    }
    
    return self[
      index(
        startIndex,
        offsetBy: linearIndex
      )
    ]
  }

}
