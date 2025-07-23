import SwiftSyntax

public struct DataTypeFieldStructureDescriptor {
  
  @usableFromInline
  internal typealias Storage = DataTypeFieldStructureDescriptorStorage
  
  @usableFromInline
  internal var storage: Storage
  
  @inlinable
  internal init(
    storage: Storage
  ) {
    self.storage = storage
  }
  
  @inlinable
  public init?(decl: some DeclSyntaxProtocol) {
    guard
      let storage = Storage(decl: decl)
    else {
      return nil
    }
    
    self.init(
      storage: storage
    )
  }
  
}

extension DataTypeFieldStructureDescriptor: Equatable { }
extension DataTypeFieldStructureDescriptor: Hashable { }

extension DataTypeFieldStructureDescriptor {
  
  @inlinable
  public var dataTypeDeclaration: ConcreteDataTypeDeclaration {
    storage.dataTypeDeclaration
  }
  
  @inlinable
  public var name: String {
    storage.name
  }
  
  @inlinable
  public var genericParameterClause: GenericParameterClauseSyntax? {
    storage.genericParameterClause
  }
  
  @inlinable
  public var inheritanceClause: InheritanceClauseSyntax? {
    storage.inheritanceClause
  }
  
  @inlinable
  internal var genericWhereClause: GenericWhereClauseSyntax? {
    storage.genericWhereClause
  }

  @inlinable
  public var storedPropertyDescriptors: [StoredPropertyDescriptor] {
    storage.storedPropertyDescriptors
  }
  
  @inlinable
  public func makeClone() -> Self {
    Self(
      storage: storage.makeClone()
    )
  }
  
}

extension DataTypeFieldStructureDescriptor {
  
  @inlinable
  public func conditionallyMapFields<R>(
    transformation: (StoredPropertyDescriptor) throws -> R,
    where predicate: (StoredPropertyDescriptor) throws -> Bool
  ) rethrows -> [R] {
    var result: [R] = []
    for storedPropertyDescriptor in storedPropertyDescriptors where try predicate(storedPropertyDescriptor) {
      result.append(
        try transformation(storedPropertyDescriptor)
      )
    }
    
    return result
  }
  
}


@usableFromInline
internal final class DataTypeFieldStructureDescriptorStorage {
  
  @usableFromInline
  internal let dataTypeDeclaration: ConcreteDataTypeDeclaration

  @inlinable
  internal var name: String {
    dataTypeDeclaration.name
  }

  @inlinable
  internal var genericParameterClause: GenericParameterClauseSyntax? {
    dataTypeDeclaration.genericParameterClause
  }

  @inlinable
  internal var inheritanceClause: InheritanceClauseSyntax? {
    dataTypeDeclaration.inheritanceClause
  }

  @inlinable
  internal var genericWhereClause: GenericWhereClauseSyntax? {
    dataTypeDeclaration.genericWhereClause
  }

  @usableFromInline
  internal let storedPropertyDescriptors: [StoredPropertyDescriptor]
  
  @inlinable
  internal init(
    dataTypeDeclaration: ConcreteDataTypeDeclaration,
    storedPropertyDescriptors: [StoredPropertyDescriptor]
  ) {
    self.dataTypeDeclaration = dataTypeDeclaration
    self.storedPropertyDescriptors = storedPropertyDescriptors
  }
  
  @inlinable
  internal convenience init?(decl: some DeclSyntaxProtocol) {
    guard
      let declaration = ConcreteDataTypeDeclaration(decl: decl)
    else {
      return nil
    }
    
    self.init(
      dataTypeDeclaration: declaration,
      storedPropertyDescriptors: declaration.storedPropertyDescriptors
    )
  }
  
  @inlinable
  internal var modifierList: DeclModifierListSyntax {
    dataTypeDeclaration.modifiers
  }
  
  @inlinable
  internal var attributeList: AttributeListSyntax {
    dataTypeDeclaration.attributes
  }
  
  @usableFromInline
  internal var _nonConfigurationAttributes: [AttributeSyntax]? = nil
  
  @inlinable
  internal var nonConfigurationAttributes: [AttributeSyntax] {
    _nonConfigurationAttributes.ensuredValue(
      guaranteedBy: attributeList.nonConfigurationAttributes
    )
  }
  
  @usableFromInline
  internal var _visibilityLevel: VisibilityLevel?? = nil
  
  @usableFromInline
  internal var visibilityLevel: VisibilityLevel? {
    _visibilityLevel.ensuredValue(
      guaranteedBy: modifierList.visibilityLevel
    )
  }
  
  @inlinable
  internal func makeClone() -> Self {
    Self(
      dataTypeDeclaration: dataTypeDeclaration,
      storedPropertyDescriptors: storedPropertyDescriptors
    )
  }
  
}

extension DataTypeFieldStructureDescriptorStorage: Equatable {
  
  @inlinable
  internal static func == (
    lhs: DataTypeFieldStructureDescriptorStorage,
    rhs: DataTypeFieldStructureDescriptorStorage
  ) -> Bool {
    guard lhs !== rhs else {
      return true
    }
    
    guard
      lhs.dataTypeDeclaration == rhs.dataTypeDeclaration,
      lhs.storedPropertyDescriptors == rhs.storedPropertyDescriptors
    else {
      return false
    }
    
    return true
  }
  
}

extension DataTypeFieldStructureDescriptorStorage: Hashable {
  
  @inlinable
  internal func hash(into hasher: inout Hasher) {
    dataTypeDeclaration.hash(into: &hasher)
    storedPropertyDescriptors.hash(into: &hasher)
  }
  
}
