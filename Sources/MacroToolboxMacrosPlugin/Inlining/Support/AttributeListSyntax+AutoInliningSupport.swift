import SwiftSyntax
import SwiftSyntaxMacros
import MacroToolbox

extension AttributeListSyntax {
  
  @inlinable
  package var containsDoNotInlineAttribute: Bool {
    containsAttribute(named: "DoNotInline")
  }
  
  
  @inlinable
  package var couldReceiveAutomaticInlinabilityAttributes: Bool {
    inlinabilityDisposition == nil
    &&
    !containsDoNotInlineAttribute
  }
  
}
