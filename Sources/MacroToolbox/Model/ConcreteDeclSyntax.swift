import SwiftSyntax
import SwiftSyntaxMacros

public enum ConcreteDeclSyntax {
  
  case accessor(AccessorDeclSyntax)
  case actor(ActorDeclSyntax)
  case `associatedtype`(AssociatedTypeDeclSyntax)
  case `class`(ClassDeclSyntax)
  case deinitializer(DeinitializerDeclSyntax)
  case editorPlaceholder(EditorPlaceholderDeclSyntax)
  case enumCase(EnumCaseDeclSyntax)
  case `enum`(EnumDeclSyntax)
  case `extension`(ExtensionDeclSyntax)
  case function(FunctionDeclSyntax)
  case ifConfig(IfConfigDeclSyntax)
  case `import`(ImportDeclSyntax)
  case initializer(InitializerDeclSyntax)
  case macro(MacroDeclSyntax)
  case macroExpansion(MacroExpansionDeclSyntax)
  case missing(MissingDeclSyntax)
  case `operator`(OperatorDeclSyntax)
  case poundSourceLocation(PoundSourceLocationSyntax)
  case precedenceGroup(PrecedenceGroupDeclSyntax)
  case `protocol`(ProtocolDeclSyntax)
  case `struct`(StructDeclSyntax)
  case `subscript`(SubscriptDeclSyntax)
  case `typealias`(TypeAliasDeclSyntax)
  case variable(VariableDeclSyntax)

}

extension ConcreteDeclSyntax {
  
  @inlinable
  public init?(decl: some DeclSyntaxProtocol) {
    if let decl = decl.as(AccessorDeclSyntax.self) {
      self = .accessor(decl)
    } else if let decl = decl.as(ActorDeclSyntax.self) {
      self = .actor(decl)
    } else if let decl = decl.as(AssociatedTypeDeclSyntax.self) {
      self = .associatedtype(decl)
    } else if let decl = decl.as(ClassDeclSyntax.self) {
      self = .class(decl)
    } else if let decl = decl.as(DeinitializerDeclSyntax.self) {
      self = .deinitializer(decl)
    } else if let decl = decl.as(EditorPlaceholderDeclSyntax.self) {
      self = .editorPlaceholder(decl)
    } else if let decl = decl.as(EnumCaseDeclSyntax.self) {
      self = .enumCase(decl)
    } else if let decl = decl.as(EnumDeclSyntax.self) {
      self = .enum(decl)
    } else if let decl = decl.as(ExtensionDeclSyntax.self) {
      self = .extension(decl)
    } else if let decl = decl.as(FunctionDeclSyntax.self) {
      self = .function(decl)
    } else if let decl = decl.as(IfConfigDeclSyntax.self) {
      self = .ifConfig(decl)
    } else if let decl = decl.as(ImportDeclSyntax.self) {
      self = .import(decl)
    } else if let decl = decl.as(InitializerDeclSyntax.self) {
      self = .initializer(decl)
    } else if let decl = decl.as(MacroDeclSyntax.self) {
      self = .macro(decl)
    } else if let decl = decl.as(MacroExpansionDeclSyntax.self) {
      self = .macroExpansion(decl)
    } else if let decl = decl.as(MissingDeclSyntax.self) {
      self = .missing(decl)
    } else if let decl = decl.as(OperatorDeclSyntax.self) {
      self = .operator(decl)
    } else if let decl = decl.as(PoundSourceLocationSyntax.self) {
      self = .poundSourceLocation(decl)
    } else if let decl = decl.as(PrecedenceGroupDeclSyntax.self) {
      self = .precedenceGroup(decl)
    } else if let decl = decl.as(ProtocolDeclSyntax.self) {
      self = .protocol(decl)
    } else if let decl = decl.as(StructDeclSyntax.self) {
      self = .struct(decl)
    } else if let decl = decl.as(SubscriptDeclSyntax.self) {
      self = .subscript(decl)
    } else if let decl = decl.as(TypeAliasDeclSyntax.self) {
      self = .typealias(decl)
    } else if let decl = decl.as(VariableDeclSyntax.self) {
      self = .variable(decl)
    } else {
      return nil
    }
  }
  
}

extension ConcreteDeclSyntax {
  
  @inlinable
  public var modifiers: DeclModifierListSyntax? {
    switch self {
    case .accessor:
      nil
    case .actor(let decl):
      decl.modifiers
    case .associatedtype(let decl):
      decl.modifiers
    case .class(let decl):
      decl.modifiers
    case .deinitializer(let decl):
      decl.modifiers
    case .editorPlaceholder(let decl):
      decl.modifiers
    case .enumCase(let decl):
      decl.modifiers
    case .enum(let decl):
      decl.modifiers
    case .extension(let decl):
      decl.modifiers
    case .function(let decl):
      decl.modifiers
    case .ifConfig:
      nil
    case .import(let decl):
      decl.modifiers
    case .initializer(let decl):
      decl.modifiers
    case .macro(let decl):
      decl.modifiers
    case .macroExpansion(let decl):
      decl.modifiers
    case .missing(let decl):
      decl.modifiers
    case .operator:
      nil
    case .poundSourceLocation:
      nil
    case .precedenceGroup(let decl):
      decl.modifiers
    case .protocol(let decl):
      decl.modifiers
    case .struct(let decl):
      decl.modifiers
    case .subscript(let decl):
      decl.modifiers
    case .typealias(let decl):
      decl.modifiers
    case .variable(let decl):
      decl.modifiers
    }
  }
  
  @inlinable
  public var visibilityLevel: VisibilityLevel? {
    modifiers?.visibilityLevel
  }
  
  @inlinable
  public var attributes: AttributeListSyntax? {
    switch self {
    case .accessor(let decl):
      decl.attributes
    case .actor(let decl):
      decl.attributes
    case .associatedtype(let decl):
      decl.attributes
    case .class(let decl):
      decl.attributes
    case .deinitializer(let decl):
      decl.attributes
    case .editorPlaceholder(let decl):
      decl.attributes
    case .enumCase(let decl):
      decl.attributes
    case .enum(let decl):
      decl.attributes
    case .extension(let decl):
      decl.attributes
    case .function(let decl):
      decl.attributes
    case .ifConfig:
      nil
    case .import(let decl):
      decl.attributes
    case .initializer(let decl):
      decl.attributes
    case .macro(let decl):
      decl.attributes
    case .macroExpansion(let decl):
      decl.attributes
    case .missing(let decl):
      decl.attributes
    case .operator:
      nil
    case .poundSourceLocation:
      nil
    case .precedenceGroup(let decl):
      decl.attributes
    case .protocol(let decl):
      decl.attributes
    case .struct(let decl):
      decl.attributes
    case .subscript(let decl):
      decl.attributes
    case .typealias(let decl):
      decl.attributes
    case .variable(let decl):
      decl.attributes
    }
  }

}

extension ConcreteDeclSyntax {
  
  @inlinable
  public var isConcreteTypeDeclaration: Bool {
    switch self {
    case .actor, .class, .enum, .struct:
      true
    default:
      false
    }
  }
 
  @inlinable
  public var concreteTypeDeclaration: ConcreteTypeDeclaration? {
    switch self {
    case .actor(let decl):
      .actor(decl)
    case .class(let decl):
      .class(decl)
    case .enum(let decl):
      .enum(decl)
    case .struct(let decl):
      .struct(decl)
    default:
      nil
    }
  }
}
