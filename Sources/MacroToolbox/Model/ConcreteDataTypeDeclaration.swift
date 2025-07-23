import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

public enum ConcreteDataTypeDeclaration {
  
  case actor(ActorDeclSyntax)
  case `class`(ClassDeclSyntax)
  case `struct`(StructDeclSyntax)
  
}

extension ConcreteDataTypeDeclaration: Sendable { }
extension ConcreteDataTypeDeclaration: Equatable { }
extension ConcreteDataTypeDeclaration: Hashable { }

extension ConcreteDataTypeDeclaration {
  
  @inlinable
  public init?(decl: some DeclSyntaxProtocol) {
    if let actorDecl = decl.as(ActorDeclSyntax.self) {
      self = .actor(actorDecl)
    } else if let classDecl = decl.as(ClassDeclSyntax.self) {
      self = .class(classDecl)
    } else if let structDecl = decl.as(StructDeclSyntax.self) {
      self = .struct(structDecl)
    } else {
      return nil
    }
  }
  
}

extension ConcreteDataTypeDeclaration {
  
  @inlinable
  public var modifiers: DeclModifierListSyntax {
    switch self {
    case .actor(let decl):
      decl.modifiers
    case .class(let decl):
      decl.modifiers
    case .struct(let decl):
      decl.modifiers
    }
  }
  
  @inlinable
  public var attributes: AttributeListSyntax {
    switch self {
    case .actor(let decl):
      decl.attributes
    case .class(let decl):
      decl.attributes
    case .struct(let decl):
      decl.attributes
    }
  }
  
  @inlinable
  public var nameSyntax: TokenSyntax {
    switch self {
    case .actor(let decl):
      decl.name
    case .class(let decl):
      decl.name
    case .struct(let decl):
      decl.name
    }
  }

  @inlinable
  public var name: String {
    nameSyntax.text
  }

  @inlinable
  public var inheritanceClause: InheritanceClauseSyntax? {
    switch self {
    case .actor(let decl):
      decl.inheritanceClause
    case .class(let decl):
      decl.inheritanceClause
    case .struct(let decl):
      decl.inheritanceClause
    }
  }

  @inlinable
  public var genericParameterClause: GenericParameterClauseSyntax? {
    switch self {
    case .actor(let decl):
      decl.genericParameterClause
    case .class(let decl):
      decl.genericParameterClause
    case .struct(let decl):
      decl.genericParameterClause
    }
  }

  @inlinable
  public var genericWhereClause: GenericWhereClauseSyntax? {
    switch self {
    case .actor(let decl):
      decl.genericWhereClause
    case .class(let decl):
      decl.genericWhereClause
    case .struct(let decl):
      decl.genericWhereClause
    }
  }

  @inlinable
  public var explicitVisibilityLevel: VisibilityLevel? {
    modifiers.visibilityLevel
  }
  
  @inlinable
  public var inlinabilityDisposition: InlinabilityDisposition? {
    attributes.inlinabilityDisposition
  }
  
}

extension ConcreteDataTypeDeclaration {
  
  @inlinable
  public var concreteDeclSyntax: ConcreteDeclSyntax {
    switch self {
    case .actor(let decl):
      .actor(decl)
    case .class(let decl):
      .class(decl)
    case .struct(let decl):
      .struct(decl)
    }
  }
  
}

extension ConcreteDataTypeDeclaration {
  
  @inlinable
  public var storedPropertyDescriptors: [StoredPropertyDescriptor] {
    switch self {
    case .actor(let decl):
      decl.storedPropertyDescriptors
    case .class(let decl):
      decl.storedPropertyDescriptors
    case .struct(let decl):
      decl.storedPropertyDescriptors
    }
  }
  
}
