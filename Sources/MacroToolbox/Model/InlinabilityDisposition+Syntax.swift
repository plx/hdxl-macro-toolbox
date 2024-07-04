import SwiftSyntax

extension InlinabilityDisposition {

  /// Obtains the disposition's textual representation (e.g. suitable for `"\(raw: )"` interpolation).
  @inlinable
  public var sourceCodeStringRepresentation: String {
    switch self {
    case .usableFromInline:
      "@usableFromInline"
    case .inlinable:
      "@inlinable"
    }
  }
  
}

extension InlinabilityDisposition {
  
  @inlinable
  public init?(tokenSyntax: TokenSyntax) {
    switch tokenSyntax.text {
    case "usableFromInline":
      self = .usableFromInline
    case "inlinable":
      self = .inlinable
    default:
      return nil
    }
  }
  
}

