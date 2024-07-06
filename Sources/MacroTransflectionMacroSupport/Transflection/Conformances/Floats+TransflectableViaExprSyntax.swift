import Foundation
import SwiftSyntax
import SwiftParser
import MacroToolbox
import MacroTransflection

// MARK: Conformances

extension Float16: TransflectableViaExprSyntax { }
extension Float: TransflectableViaExprSyntax { }
extension Double: TransflectableViaExprSyntax { }

// MARK: - FloatExprTransflectionError

public enum FloatExprTransflectionError: Error, LocalizedError {
  case noIdentifiableFloatLiteral(String)
  case noIdentifiableIntegerLiteral(String)
  case unrepresentableIntegerLiteral(String)
  case incompatibleBaseType(String)
  case noLeadingPeriod(String)
  case symbolCannotHaveArguments(String)
  case notASimpleIdentifier(String)
  case unsupportedSymbolicConstant(String)
  case unsupportedPrefixOperatorExpression(String)
  case unsupportedExprSyntax(String)
}

// MARK: - Conformance Implementation

extension FloatingPoint where Self: TransflectableViaExprSyntax, Self: TransflectableViaFloatLiteralValue {
  
  @inlinable
  package init(transflectingFloatLiteralExprSyntax floatLiteralExprSyntax: FloatLiteralExprSyntax) throws {
    guard 
      let representedFloatLiteralValue = floatLiteralExprSyntax.representedFloatLiteralValue
    else {
      throw FloatExprTransflectionError.noIdentifiableFloatLiteral(
        """
        No identifiable float-literal-value identified within `\(floatLiteralExprSyntax)`!
        """
      )
    }
    
    try self.init(transflectingFloatLiteralValue: representedFloatLiteralValue)
  }

  @inlinable
  package init(transflectingIntegerLiteralExprSyntax integerLiteralExprSyntax: IntegerLiteralExprSyntax) throws {
    guard 
      let representedIntegerLiteralValue = integerLiteralExprSyntax.representedIntegerLiteralValue
    else {
      throw FloatExprTransflectionError.noIdentifiableIntegerLiteral(
        """
        No identifiable integer-literal-value identified within `\(integerLiteralExprSyntax)`!
        """
      )
    }
    
    guard
      let floatLiteralValue = Double(exactly: representedIntegerLiteralValue)
    else {
      throw FloatExprTransflectionError.unrepresentableIntegerLiteral(
        """
        The integer-literal-value \(representedIntegerLiteralValue) could not be converted into a `Double`!
        """
      )
    }
    
    try self.init(transflectingFloatLiteralValue: floatLiteralValue)
  }

  @inlinable
  package init(transflectingMemberAccessExprSyntax memberAccessSyntax: MemberAccessExprSyntax) throws {
    guard 
      memberAccessSyntax.isCompatibleWithTypeLevelPropertyAccess(forBaseType: Self.self)
    else {
      throw FloatExprTransflectionError.incompatibleBaseType(
        """
        Found base-type incompatible-with `\(Self.self)` in \(memberAccessSyntax)!
        """
      )
    }
    
    guard
      memberAccessSyntax.period.tokenKind == .period // have to have a leading period!
    else {
      throw FloatExprTransflectionError.noLeadingPeriod(
        """
        No leading-period identified in `\(memberAccessSyntax)`!
        """
      )
    }
    
    guard
      memberAccessSyntax.declName.argumentNames == nil
    else {
      throw FloatExprTransflectionError.symbolCannotHaveArguments(
        """
        We do not support symbols-with-arguments, but transflection target appeared to have arguments: `\(memberAccessSyntax.declName)`!
        """
      )
    }
    
    guard
      case .identifier(let symbolName) = memberAccessSyntax.declName.baseName.tokenKind
    else {
      throw FloatExprTransflectionError.notASimpleIdentifier(
        """
        We only support identifier-type member-access expressions, but this declaration was something else: `\(memberAccessSyntax.declName)`!
        """
      )
    }
    
    switch symbolName {
    case "zero":
      self = .zero
    case "nan":
      self = .nan
    case "signalingNaN":
      self = .signalingNaN
    case "infinity":
      self = .infinity
    case "leastNormalMagnitude":
      self = .leastNormalMagnitude
    case "greatestFiniteMagnitude":
      self = .greatestFiniteMagnitude
    case "leastNonzeroMagnitude":
      self = .leastNonzeroMagnitude
    case "ulpOfOne":
      self = .ulpOfOne
    case "pi":
      self = .pi
    default:
      throw FloatExprTransflectionError.unsupportedSymbolicConstant(
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
      "nan",
      "signalingNaN",
      "infinity",
      "leastNormalMagnitude",
      "leastNonzeroMagnitude",
      "greatestFiniteMagnitude",
      "ulpOfOne",
      "pi"
    ]
  }

  @inlinable
  package init(transflectingPrefixOperatorExprSyntax prefixOperatorExprSyntax: PrefixOperatorExprSyntax) throws {
    if prefixOperatorExprSyntax.operator.isPrefixPlusSign {
      try self.init(transflectingExprSyntax: prefixOperatorExprSyntax.expression)
    } else if prefixOperatorExprSyntax.operator.isPrefixMinusSign {
      try self.init(transflectingExprSyntax: prefixOperatorExprSyntax.expression)
      self = -self
    } else {
      throw FloatExprTransflectionError.unsupportedPrefixOperatorExpression(
        """
        Unable to transflect unsupported prefix-operator-expression \(prefixOperatorExprSyntax)!
        """
      )
    }
  }

  @inlinable
  public init(transflectingExprSyntax exprSyntax: ExprSyntax) throws {
    if let floatLiteralSynax = exprSyntax.as(FloatLiteralExprSyntax.self) {
      try self.init(transflectingFloatLiteralExprSyntax: floatLiteralSynax)
    } else if let integerLiteralSyntax = exprSyntax.as(IntegerLiteralExprSyntax.self) {
      try self.init(transflectingIntegerLiteralExprSyntax: integerLiteralSyntax)
    } else if let memberAccessSyntax = exprSyntax.as(MemberAccessExprSyntax.self) {
      try self.init(transflectingMemberAccessExprSyntax: memberAccessSyntax)
    } else if let prefixOperatorSyntax = exprSyntax.as(PrefixOperatorExprSyntax.self) {
      try self.init(transflectingPrefixOperatorExprSyntax: prefixOperatorSyntax)
    } else {
      throw FloatExprTransflectionError.unsupportedExprSyntax(
        """
        Unable to transflect unsupported expr-syntax \(exprSyntax)!
        """
      )
    }
  }

}

