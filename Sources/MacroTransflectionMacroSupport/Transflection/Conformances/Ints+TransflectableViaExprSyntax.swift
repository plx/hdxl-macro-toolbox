import Foundation
import SwiftSyntax
import SwiftParser
import MacroToolbox
import MacroTransflection

// MARK: Conformances

extension Int: TransflectableViaExprSyntax { }
extension Int8: TransflectableViaExprSyntax { }
extension Int16: TransflectableViaExprSyntax { }
extension Int32: TransflectableViaExprSyntax { }
extension Int64: TransflectableViaExprSyntax { }

extension UInt: TransflectableViaExprSyntax { }
extension UInt8: TransflectableViaExprSyntax { }
extension UInt16: TransflectableViaExprSyntax { }
extension UInt32: TransflectableViaExprSyntax { }
extension UInt64: TransflectableViaExprSyntax { }

// MARK: - IntegerExprTransflectionError

public enum IntegerExprTransflectionError: Error, LocalizedError {
  case noIdentifiableIntLiteral(String)
  case incompatibleBaseType(String)
  case noLeadingPeriod(String)
  case symbolCannotHaveArguments(String)
  case notASimpleIdentifier(String)
  case unsupportedSymbolicConstant(String)
  case unsupportedPrefixOperatorExpression(String)
  case unsupportedNegativeLiteralForUnsignedType(String)
  case unsupportedExprSyntax(String)
}

// MARK: - Conformance Implementation

extension FixedWidthInteger where Self: BinaryInteger, Self: TransflectableViaExprSyntax, Self: TransflectableViaIntegerLiteralValue {
  
  @inlinable
  package init(transflectingIntegerLiteralExprSyntax integerLiteralExprSyntax: IntegerLiteralExprSyntax) throws {
    guard let representedIntegerLiteralValue = integerLiteralExprSyntax.representedIntegerLiteralValue else {
      throw IntegerExprTransflectionError.noIdentifiableIntLiteral(
        """
        No identifiable int-literal-value identified within `\(integerLiteralExprSyntax)`!
        """
      )
    }
    
    try self.init(transflectingIntegerLiteralValue: representedIntegerLiteralValue)
  }
  
  @inlinable
  package init(transflectingMemberAccessExprSyntax memberAccessSyntax: MemberAccessExprSyntax) throws {
    guard memberAccessSyntax.isCompatibleWithTypeLevelPropertyAccess(forBaseType: Self.self) else {
      throw IntegerExprTransflectionError.incompatibleBaseType(
        """
        Found base-type incompatible-with `\(Self.self)` in \(memberAccessSyntax)!
        """
      )
    }
    
    guard
      memberAccessSyntax.period.tokenKind == .period // have to have a leading period!
    else {
      throw IntegerExprTransflectionError.noLeadingPeriod(
        """
        No leading-period identified in `\(memberAccessSyntax)`!
        """
      )
    }
    
    guard
      memberAccessSyntax.declName.argumentNames == nil
    else {
      throw IntegerExprTransflectionError.symbolCannotHaveArguments(
        """
        We do not support symbols-with-arguments, but transflection target appeared to have arguments: `\(memberAccessSyntax.declName)`!
        """
      )
    }
    
    guard
      case .identifier(let symbolName) = memberAccessSyntax.declName.baseName.tokenKind
    else {
      throw IntegerExprTransflectionError.notASimpleIdentifier(
        """
        We only support identifier-type member-access expressions, but this declaration was something else: `\(memberAccessSyntax.declName)`!
        """
      )
    }
    
    switch symbolName {
    case "zero":
      self = .zero
    case "max":
      self = Self.max
    case "min":
      self = Self.min
    default:
      throw IntegerExprTransflectionError.unsupportedSymbolicConstant(
        """
        The symbol `\(memberAccessSyntax.declName.baseName)` was not one of the symbols we support, which are: [ \(Self.supportedSymbolicLiterals.joined(separator: ", ")) ]
        """
      )
    }
  }
  
  @inlinable
  package static var supportedSymbolicLiterals: [String] {
    [
      "zero",
      "max",
      "min"
    ]
  }
  
}

extension FixedWidthInteger where Self: BinaryInteger, Self: SignedInteger, Self: TransflectableViaExprSyntax, Self: TransflectableViaIntegerLiteralValue {

  @inlinable
  package init(transflectingPrefixOperatorExprSyntax prefixOperatorExprSyntax: PrefixOperatorExprSyntax) throws {
    if prefixOperatorExprSyntax.operator.isPrefixPlusSign {
      try self.init(exprSyntax: prefixOperatorExprSyntax.expression)
    } else if prefixOperatorExprSyntax.operator.isPrefixMinusSign {
      try self.init(exprSyntax: prefixOperatorExprSyntax.expression)
      self = -self
    } else {
      throw IntegerExprTransflectionError.unsupportedPrefixOperatorExpression(
        """
        Unable to transflect unsupported prefix-operator-expression \(prefixOperatorExprSyntax)!
        """
      )
    }
  }

  @inlinable
  public init(exprSyntax: ExprSyntax) throws {
    if let integerLiteralSynax = exprSyntax.as(IntegerLiteralExprSyntax.self) {
      try self.init(transflectingIntegerLiteralExprSyntax: integerLiteralSynax)
    } else if let memberAccessSyntax = exprSyntax.as(MemberAccessExprSyntax.self) {
      try self.init(transflectingMemberAccessExprSyntax: memberAccessSyntax)
    } else if let prefixOperatorSyntax = exprSyntax.as(PrefixOperatorExprSyntax.self) {
      try self.init(transflectingPrefixOperatorExprSyntax: prefixOperatorSyntax)
    } else {
      throw IntegerExprTransflectionError.unsupportedExprSyntax(
        """
        Unable to transflect unsupported expr-syntax \(exprSyntax)!
        """
      )
    }
  }

}

extension FixedWidthInteger where Self: BinaryInteger, Self: UnsignedInteger, Self: TransflectableViaExprSyntax, Self: TransflectableViaIntegerLiteralValue {
  
  @inlinable
  package init(transflectingPrefixOperatorExprSyntax prefixOperatorExprSyntax: PrefixOperatorExprSyntax) throws {
    if prefixOperatorExprSyntax.operator.isPrefixPlusSign {
      try self.init(exprSyntax: prefixOperatorExprSyntax.expression)
    } else if prefixOperatorExprSyntax.operator.isPrefixMinusSign {
      throw IntegerExprTransflectionError.unsupportedNegativeLiteralForUnsignedType(
        """
        \(Self.self) cannot represent negative values, but we encountered one during transflection: `\(prefixOperatorExprSyntax)`!
        """
      )
    } else {
      throw IntegerExprTransflectionError.unsupportedPrefixOperatorExpression(
        """
        Unable to transflect unsupported prefix-operator-expression \(prefixOperatorExprSyntax)!
        """
      )
    }
  }
  
  @inlinable
  public init(exprSyntax: ExprSyntax) throws {
    if let integerLiteralSynax = exprSyntax.as(IntegerLiteralExprSyntax.self) {
      try self.init(transflectingIntegerLiteralExprSyntax: integerLiteralSynax)
    } else if let memberAccessSyntax = exprSyntax.as(MemberAccessExprSyntax.self) {
      try self.init(transflectingMemberAccessExprSyntax: memberAccessSyntax)
    } else if let prefixOperatorSyntax = exprSyntax.as(PrefixOperatorExprSyntax.self) {
      try self.init(transflectingPrefixOperatorExprSyntax: prefixOperatorSyntax)
    } else {
      throw IntegerExprTransflectionError.unsupportedExprSyntax(
        """
        Unable to transflect unsupported expr-syntax \(exprSyntax)!
        """
      )
    }
  }
  
}

