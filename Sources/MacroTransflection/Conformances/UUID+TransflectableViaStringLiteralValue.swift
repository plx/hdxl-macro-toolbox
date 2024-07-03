import Foundation

public enum UUIDLiteralTransflectionError: Sendable, Error, LocalizedError {
  
  case literalDidNotRepresentAValidUUID(String)
  
}

extension UUID: TransflectableViaStringLiteralValue {
  
  @inlinable
  public init(transflectingStringLiteralValue stringLiteralValue: String) throws {
    switch UUID(uuidString: stringLiteralValue) {
    case .some(let uuid):
      self = uuid
    case .none:
      throw UUIDLiteralTransflectionError.literalDidNotRepresentAValidUUID(
        """
        Unable to convert literal `\(stringLiteralValue)` into a valid `UUID`!
        """
      )
    }
  }
  
}
