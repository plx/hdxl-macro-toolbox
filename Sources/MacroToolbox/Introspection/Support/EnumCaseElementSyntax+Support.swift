import SwiftSyntax

extension EnumCaseElementSyntax {
  
  /// `true` if we're a "simple" case without any payload.
  @inlinable
  public var isSimpleCaseWithoutPayload: Bool {
    parameterClause == nil
  }
  
}
