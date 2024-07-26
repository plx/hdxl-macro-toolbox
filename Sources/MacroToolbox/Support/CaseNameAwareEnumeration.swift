import Foundation
import MacroTransflection

// TODO: supply a macro-based implementation of this
public protocol MacroToolboxCaseNameAwareEnumeration {
  var caseNameWithoutLeadingDot: String { get }
}

extension MacroToolboxCaseNameAwareEnumeration {
  @inlinable
  public var caseNameWithLeadingDot: String {
    ".\(caseNameWithoutLeadingDot)"
  }
}

extension MacroToolboxCaseNameAwareEnumeration where Self: RawRepresentable, Self.RawValue == String {
  @inlinable
  public var caseNameWithoutLeadingDot: String {
    rawValue
  }
}

extension MacroToolboxCaseNameAwareEnumeration where Self: CustomStringConvertible {
  @inlinable
  public var description: String {
    return caseNameWithLeadingDot
  }
}

extension MacroToolboxCaseNameAwareEnumeration where Self: CustomDebugStringConvertible {
  @inlinable
  public var debugDescription: String {
    "\(type(of: Self.self))\(caseNameWithLeadingDot)"
  }
}

// need this redundant-looking overload to avoid ambiguity
// when making a `CodingKey` conform to `MacroToolboxCaseNameAwareEnumeration`
extension MacroToolboxCaseNameAwareEnumeration where Self: CodingKey {
  @inlinable
  public var description: String {
    caseNameWithLeadingDot
  }

  @inlinable
  public var debugDescription: String {
    "\(type(of: Self.self))\(caseNameWithLeadingDot)"
  }
}
