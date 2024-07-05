import Foundation
import SwiftSyntax
import SwiftParser
import MacroToolbox
import MacroTransflection

// MARK: - StringExprTransflectionError

public enum SourceCodeIdentifierExprTransflectionError: Error, LocalizedError {
  case incompatibleBaseType(String)
  case noLeadingPeriod(String)
  case symbolCannotHaveArguments(String)
  case notASimpleIdentifier(String)
  case unsupportedSymbolicConstant(String)
  case unsupportedExprSyntax(String)
}

// MARK: - Conformance Implementation

extension TransflectableViaExprSyntax where Self: TransflectableViaSourceCodeIdentifier  {
  
  @inlinable
  package init(transflectingMemberAccessExprSyntax memberAccessSyntax: MemberAccessExprSyntax) throws {
    guard memberAccessSyntax.isCompatibleWithTypeLevelPropertyAccess(forBaseType: Self.self) else {
      throw SourceCodeIdentifierExprTransflectionError.incompatibleBaseType(
        """
        Found base-type incompatible-with `\(Self.self)` in \(memberAccessSyntax)!
        """
      )
    }
    
    guard
      memberAccessSyntax.period.tokenKind == .period // have to have a leading period!
    else {
      throw SourceCodeIdentifierExprTransflectionError.noLeadingPeriod(
        """
        No leading-period identified in `\(memberAccessSyntax)`!
        """
      )
    }
    
    guard
      memberAccessSyntax.declName.argumentNames == nil
    else {
      throw SourceCodeIdentifierExprTransflectionError.symbolCannotHaveArguments(
        """
        We do not support symbols-with-arguments, but transflection target appeared to have arguments: `\(memberAccessSyntax.declName)`!
        """
      )
    }
    
    guard
      case .identifier(let symbolName) = memberAccessSyntax.declName.baseName.tokenKind
    else {
      throw SourceCodeIdentifierExprTransflectionError.notASimpleIdentifier(
        """
        We only support identifier-type member-access expressions, but this declaration was something else: `\(memberAccessSyntax.declName)`!
        """
      )
    }
    
    // `symbolName` doesn't have the `.` in front, so we (crudely) re-insert it here
    // it's not clear there's a benefit to doing this over just passing in the
    // full `declName`: in theory this is "more controlled" vis-a-vis whitespace, etc.,
    // but at the same time, maybe it's going to let a few "should-be-be-bad values" slip through?
    try self.init(transflectingSourceCodeIdentifier: ".\(symbolName)")
  }

  @inlinable
  public init(exprSyntax: ExprSyntax) throws {
    if let memberAccessExprSyntax = exprSyntax.as(MemberAccessExprSyntax.self) {
      try self.init(transflectingMemberAccessExprSyntax: memberAccessExprSyntax)
    } else {
      throw SourceCodeIdentifierExprTransflectionError.unsupportedExprSyntax(
        """
        Unable to transflect unsupported expr-syntax \(exprSyntax)!
        """
      )
    }
  }
  
}

