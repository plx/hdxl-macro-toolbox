import SwiftSyntax

extension StructDeclSyntax {
  
  @inlinable
  public var simpleGenericParameterNames: [String]? {
    genericParameterClause?.simpleGenericParameterNames
  }
 
  @inlinable
  public var storedPropertyDescriptors: [StoredPropertyDescriptor] {
    memberBlock.storedPropertyDescriptors
  }
  
  @inlinable
  public func allStoredPropertyDescriptors(
    where predicate: (StoredPropertyDescriptor) throws -> Bool
  ) rethrows -> [StoredPropertyDescriptor] {
    try memberBlock.allStoredPropertyDescriptors(where: predicate)
  }

}

