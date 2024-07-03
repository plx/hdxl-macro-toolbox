import Foundation

public enum URLLiteralTransflectionError: Sendable, Error, LocalizedError {
  
  case literalDidNotRepresentAValidURL(String)
  
}

extension URL: TransflectableViaStringLiteralValue {
  
  @inlinable
  public init(transflectingStringLiteralValue stringLiteralValue: String) throws {
    switch URL(string: stringLiteralValue) {
    case .some(let url):
      self = url
    case .none:
      throw URLLiteralTransflectionError.literalDidNotRepresentAValidURL(
        """
        Unable to convert literal `\(stringLiteralValue)` into a valid `URL`!
        """
      )
    }
  }
  
}
