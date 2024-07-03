import SwiftSyntax
import SwiftSyntaxMacros

extension DeclSyntaxProtocol {
  
  @inlinable
  public func applyConcreteTypeMapping<R, each T: DeclSyntaxProtocol>(
    associations: (repeat (R, (each T).Type))
  ) -> R? {
    for (value, concreteType) in repeat each associations {
      if self.is(concreteType) {
        return value
      }
    }
    
    return nil
  }
  
  @inlinable
  public func extractHomogeneousValues<R, each T: DeclSyntaxProtocol>(
    using associations: (repeat (KeyPath<each T,R>, (each T).Type))
  ) -> R? {
    for (keyPath, concreteType) in repeat each associations {
      if let concreteValue = self.as(concreteType) {
        return concreteValue[keyPath: keyPath]
      }
    }
    
    return nil
  }

  @inlinable
  public func extractHomogeneousValues<R, each T: DeclSyntaxProtocol>(
    using associations: (repeat (KeyPath<each T,R?>, (each T).Type))
  ) -> R? {
    for (keyPath, concreteType) in repeat each associations {
      if let concreteValue = self.as(concreteType) {
        return concreteValue[keyPath: keyPath]
      }
    }
    
    return nil
  }

  @inlinable
  public var typeDeclarationArchetype: TypeDeclarationArchetype? {
    applyConcreteTypeMapping(
      associations: (
        (.actor, ActorDeclSyntax.self),
        (.class, ClassDeclSyntax.self),
        (.enum, EnumDeclSyntax.self),
        (.struct, StructDeclSyntax.self),
        (.protocol, ProtocolDeclSyntax.self)
      )
    )
  }
  
  @inlinable
  public var declarationArchetype: DeclarationArchetype? {
    applyConcreteTypeMapping(
      associations: (
        (.accessor, AccessorDeclSyntax.self),
        (.actor, ActorDeclSyntax.self),
        (.associatedtype, AssociatedTypeDeclSyntax.self),
        (.class, ClassDeclSyntax.self),
        (.deinitializer, DeinitializerDeclSyntax.self),
        (.editorPlaceholder, EditorPlaceholderDeclSyntax.self),
        (.enumCase, EnumCaseDeclSyntax.self),
        (.enum, EnumDeclSyntax.self),
        (.extension, ExtensionDeclSyntax.self),
        (.function, FunctionDeclSyntax.self),
        (.ifConfig, IfConfigDeclSyntax.self),
        (.import, ImportDeclSyntax.self),
        (.initializer, InitializerDeclSyntax.self),
        (.macro, MacroDeclSyntax.self),
        (.macroExpansion, MacroExpansionDeclSyntax.self),
        (.missing, MissingDeclSyntax.self),
        (.operator, OperatorDeclSyntax.self),
        (.poundSourceLocation, PoundSourceLocationSyntax.self),
        (.precedenceGroup, PrecedenceGroupDeclSyntax.self),
        (.protocol, ProtocolDeclSyntax.self),
        (.struct, StructDeclSyntax.self),
        (.subscript, SubscriptDeclSyntax.self),
        (.typealias, TypeAliasDeclSyntax.self),
        (.variable, VariableDeclSyntax.self)
      )
    )
  }
  
}

