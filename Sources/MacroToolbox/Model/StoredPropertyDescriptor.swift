import SwiftSyntax
import os

public struct StoredPropertyDescriptor {
  
  @usableFromInline
  internal typealias Storage = StoredPropertyDescriptorStorage
  
  @usableFromInline
  internal var storage: Storage
  
  @inlinable
  internal init(storage: Storage) {
    self.storage = storage
  }
  
  @inlinable
  internal init?(possibleStorage: Storage?) {
    guard let storage = possibleStorage else {
      return nil
    }
    
    self.init(storage: storage)
  }
    
  @inlinable
  public init?(decl: some DeclSyntaxProtocol) {
    self.init(
      possibleStorage: Storage(
        decl: decl
      )
    )
  }
  
  @inlinable
  public init?(variableDeclaration: VariableDeclSyntax) {
    self.init(
      possibleStorage: Storage(
        variableDeclaration: variableDeclaration
      )
    )
  }
    
}

extension StoredPropertyDescriptor: Equatable { }
extension StoredPropertyDescriptor: Hashable { }


@usableFromInline
internal final class StoredPropertyDescriptorStorage {

  @usableFromInline
  internal let variableName: String
  
  @usableFromInline
  internal let primaryBinding: PatternBindingSyntax
  
  @usableFromInline
  internal let variableDeclaration: VariableDeclSyntax
    
  @inlinable
  internal init(
    variableName: String,
    primaryBinding: PatternBindingSyntax,
    variableDeclaration: VariableDeclSyntax
  ) {
    assert(variableDeclaration.isStoredProperty)
    assert(variableName == variableDeclaration.variableNameIfStoredProperty)
    self.variableName = variableName
    self.primaryBinding = primaryBinding
    self.variableDeclaration = variableDeclaration
  }

  @inlinable
  internal convenience init?(decl: some DeclSyntaxProtocol) {
    guard
      let variableDeclaration = decl.as(VariableDeclSyntax.self)
    else {
      return nil
    }
    
    self.init(variableDeclaration: variableDeclaration)
  }

  @inlinable
  internal convenience init?(variableDeclaration: VariableDeclSyntax) {
    guard
      variableDeclaration.isStoredProperty,
      let variableName = variableDeclaration.variableNameIfStoredProperty,
      let primaryBinding = variableDeclaration.bindings.first
    else {
      return nil
    }
    
    self.init(
      variableName: variableName,
      primaryBinding: primaryBinding,
      variableDeclaration: variableDeclaration
    )
  }

  @inlinable
  internal var modifierList: DeclModifierListSyntax {
    variableDeclaration.modifiers
  }

  @inlinable
  internal var attributeList: AttributeListSyntax {
    variableDeclaration.attributes
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
  

}

extension StoredPropertyDescriptorStorage: Equatable {
  
  @inlinable
  internal static func == (
    lhs: StoredPropertyDescriptorStorage,
    rhs: StoredPropertyDescriptorStorage
  ) -> Bool {
    guard lhs !== rhs else {
      return false
    }
    
    guard
      lhs.variableName == rhs.variableName,
      lhs.primaryBinding == rhs.primaryBinding,
      lhs.variableDeclaration == rhs.variableDeclaration
    else {
      return false
    }
    return true
  }
  
}

extension StoredPropertyDescriptorStorage: Hashable {
  
  @inlinable
  internal func hash(into hasher: inout Hasher) {
    variableDeclaration.hash(into: &hasher)
  }
  
}

