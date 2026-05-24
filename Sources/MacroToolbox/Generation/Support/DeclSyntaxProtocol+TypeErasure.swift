import SwiftSyntax
import SwiftSyntaxBuilder

extension SyntaxProtocol {

  @inlinable
  public func eraseToSyntax() -> Syntax {
    Syntax(self)
  }

  @inlinable
  public func eraseToValidatedSyntax() throws -> Syntax {
    try Syntax(validating: eraseToSyntax())
  }

}

extension DeclSyntaxProtocol {

  @inlinable
  public func eraseToDeclSyntax() -> DeclSyntax {
    DeclSyntax(self)
  }

  @inlinable
  public func eraseToValidatedDeclSyntax() throws -> DeclSyntax {
    try DeclSyntax(validating: eraseToDeclSyntax())
  }

}

extension ExprSyntaxProtocol {

  @inlinable
  public func eraseToExprSyntax() -> ExprSyntax {
    ExprSyntax(self)
  }

  @inlinable
  public func eraseToValidatedExprSyntax() throws -> ExprSyntax {
    try ExprSyntax(validating: eraseToExprSyntax())
  }

}

extension PatternSyntaxProtocol {

  @inlinable
  public func eraseToPatternSyntax() -> PatternSyntax {
    PatternSyntax(self)
  }

  @inlinable
  public func eraseToValidatedPatternSyntax() throws -> PatternSyntax {
    try PatternSyntax(validating: eraseToPatternSyntax())
  }

}

extension StmtSyntaxProtocol {

  @inlinable
  public func eraseToStmtSyntax() -> StmtSyntax {
    StmtSyntax(self)
  }

  @inlinable
  public func eraseToValidatedStmtSyntax() throws -> StmtSyntax {
    try StmtSyntax(validating: eraseToStmtSyntax())
  }

}

extension TypeSyntaxProtocol {

  @inlinable
  public func eraseToTypeSyntax() -> TypeSyntax {
    TypeSyntax(self)
  }

  @inlinable
  public func eraseToValidatedTypeSyntax() throws -> TypeSyntax {
    try TypeSyntax(validating: eraseToTypeSyntax())
  }

}
