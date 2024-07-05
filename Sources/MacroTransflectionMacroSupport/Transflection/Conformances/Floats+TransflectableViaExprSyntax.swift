import SwiftSyntax
import SwiftParser
import MacroToolbox
import MacroTransflection

extension FloatingPoint where Self: TransflectableViaExprSyntax, Self: TransflectableViaFloatLiteralValue {
  
  @inlinable
  package init(transflectingFloatLiteralExprSyntax floatLiteralExprSyntax: FloatLiteralExprSyntax) throws {
    guard let representedFloatLiteralValue = floatLiteralExprSyntax.representedFloatLiteralValue else {
      fatalError() // TODO: real errors!
    }
    
    try self.init(transflectingFloatLiteralValue: representedFloatLiteralValue)
  }
  
  @inlinable
  package init(transflectingMemberAccessExprSyntax memberAccessSyntax: MemberAccessExprSyntax) throws {
    guard memberAccessSyntax.isCompatibleWithTypeLevelPropertyAccess(forBaseType: Self.self) else {
      fatalError()
    }
    
    guard
      memberAccessSyntax.period.tokenKind == .period // have to have a leading period!
    else {
      fatalError()
    }
    
    guard case .identifier(let symbolName) = memberAccessSyntax.declName.baseName.tokenKind else {
      fatalError() // TODO: real errors
    }
    
    switch symbolName {
    case "zero":
      self = .zero
    case "nan":
      self = .nan
    case "signalingNan":
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
      fatalError() //
    }
  }

  @inlinable
  package init(transflectingPrefixOperatorExprSyntax prefixOperatorExprSyntax: PrefixOperatorExprSyntax) throws {
    if prefixOperatorExprSyntax.operator.isPrefixPlusSign {
      try self.init(exprSyntax: prefixOperatorExprSyntax.expression)
    } else if prefixOperatorExprSyntax.operator.isPrefixMinusSign {
      try self.init(exprSyntax: prefixOperatorExprSyntax.expression)
      self = -self
    } else {
      fatalError() // TODO: real errors
    }
  }

  @inlinable
  public init(exprSyntax: ExprSyntax) throws {
    if let floatLiteralSynax = exprSyntax.as(FloatLiteralExprSyntax.self) {
      try self.init(transflectingFloatLiteralExprSyntax: floatLiteralSynax)
    } else if let memberAccessSyntax = exprSyntax.as(MemberAccessExprSyntax.self) {
      try self.init(transflectingMemberAccessExprSyntax: memberAccessSyntax)
    } else if let prefixOperatorSyntax = exprSyntax.as(PrefixOperatorExprSyntax.self) {
      try self.init(transflectingPrefixOperatorExprSyntax: prefixOperatorSyntax)
    } else {
      fatalError() // TODO: real errors
    }
  }

}

extension Float16: TransflectableViaExprSyntax { }
extension Float: TransflectableViaExprSyntax { }
extension Double: TransflectableViaExprSyntax { }

