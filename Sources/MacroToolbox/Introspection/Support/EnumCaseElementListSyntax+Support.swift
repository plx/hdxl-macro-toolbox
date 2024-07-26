import SwiftSyntax

extension EnumCaseElementListSyntax {
  
  /// `true` iff this element-list is for a single-element declaration, sans payload.
  @inlinable
  public var isSimpleCaseWithoutPayload: Bool {
    count == 1
    &&
    (first?.isSimpleCaseWithoutPayload ?? false)
  }
  
  /// Returns the enumeration case's name, *provided that* we're a single-case declaration.
  @inlinable
  public var primarySourceCodeIdentifier: TokenSyntax? {
    guard
      count == 1,
      let caseElement = first
    else {
      return nil
    }
    
    return caseElement.name.trimmed
  }

}
