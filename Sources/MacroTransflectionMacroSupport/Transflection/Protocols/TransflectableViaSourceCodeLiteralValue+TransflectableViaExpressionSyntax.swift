import Foundation
import SwiftSyntax
import SwiftParser
import MacroToolbox
import MacroTransflection

extension TransflectableViaExpressionSyntax<MemberAccessExprSyntax> where Self: TransflectableViaSourceCodeIdentifier {
  
  @inlinable
  public init(expressionSyntax: MemberAccessExprSyntax) throws {
    try self.init(transflectingSourceCodeIdentifier: ".\(expressionSyntax.declName.trimmed)")
  }
  
}
