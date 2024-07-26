import SwiftSyntax

extension Keyword {
  
  /// The ``VisibilityLevel`` represented-by `self`, if any.
  @inlinable
  public var visibilityLevel: VisibilityLevel? {
    switch self {
    case .private:
      .private
    case .fileprivate:
      .fileprivate
    case .internal:
      .internal
    case .package:
      .package
    case .public:
      .public
    case .open:
      .open
    default:
      nil
    }
  }
  
}
