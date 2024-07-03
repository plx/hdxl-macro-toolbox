import SwiftSyntax
import MacroTransflection

public protocol TransflectableViaExprSyntax {
  
  init(exprSyntax: ExprSyntax) throws
  
}
