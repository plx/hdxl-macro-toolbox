import SwiftSyntax

extension EnumCaseElementSyntax {
  
  @inlinable
  public var isSimpleCaseWithoutPayload: Bool {
    parameterClause == nil
  }
  
}
