import SwiftSyntax

extension GenericParameterListSyntax {
  @inlinable
  public var simpleGenericParameterNames: [String]? {
    let possibleNames = compactMap(\.simpleGenericParameterName)
    guard
      !possibleNames.isEmpty,
      possibleNames.count == count
    else {
      return nil
    }
    
    return possibleNames
  }
}

