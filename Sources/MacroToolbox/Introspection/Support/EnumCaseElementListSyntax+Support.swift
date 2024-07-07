import SwiftSyntax

extension EnumCaseElementListSyntax {
  
  @inlinable
  public var isSimpleCaseWithoutPayload: Bool {
    count == 1
    &&
    (first?.isSimpleCaseWithoutPayload ?? false)
  }
  
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
