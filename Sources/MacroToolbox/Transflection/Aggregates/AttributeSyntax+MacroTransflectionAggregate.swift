import SwiftSyntax
import MacroTransflection

public enum AttributeTransflectionError: Error {
  case notAnArgumentList(String)
  case outOfRangeIndex(String)
}

extension AttributeSyntax {
  
  @inlinable
  public func transflectArguments<each T: TransflectableViaExprSyntax>(
    as types: (repeat (each T).Type)
  ) throws -> (repeat each T) {
    var index: Int = 0
    
    return (
      repeat try transflectArgumentWithIndexAdvancement(
        at: &index,
        as: (each T).self
      )
    )
  }
  
}

extension AttributeSyntax {
  
  @inlinable
  public func transflectArgument<T>(
    at index: Int,
    as type: T.Type
  ) throws -> T where T: TransflectableViaExprSyntax {
    guard let argumentList = argumentListAsLabeledExprList else {
      throw AttributeTransflectionError.notAnArgumentList(
        """
        Unable to find an argument-list on \(self)!
        """
      )
    }
    guard (0..<argumentList.count).contains(index) else {
      throw AttributeTransflectionError.outOfRangeIndex(
        """
        Index \(index) is out-of-bounds for argument-count \(argumentList.count)
        """
      )
    }
    
    return try T.init(
      transflectingExprSyntax: argumentList[
        argumentList.index(
          argumentList.startIndex,
          offsetBy: index
        )
      ].expression
    )
  }

  @inlinable
  internal func transflectArgumentWithIndexAdvancement<T>(
    at index: inout Int,
    as type: T.Type
  ) throws -> T where T: TransflectableViaExprSyntax {
    defer { index += 1 }
    return try transflectArgument(
      at: index,
      as: type
    )
  }

}

