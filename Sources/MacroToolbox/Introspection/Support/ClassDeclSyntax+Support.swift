import SwiftSyntax


extension ClassDeclSyntax {
  
  @inlinable
  public var simpleGenericParameterNames: [String]? {
    genericParameterClause?.simpleGenericParameterNames
  }
  
  @inlinable
  public var preferredDesignatedInitializerDeclarationIfAvailable: InitializerDeclSyntax? {
    guard let initializerDeclarations = memberBlock
      .members
      .compactMap({ (member) in
        member
          .decl
          .as(InitializerDeclSyntax.self)
      }).unlessEmpty
    else {
      return nil
    }
    
    let candidates = initializerDeclarations.filter { initializer in
      let isRequired = initializer.modifiers.anySatisfy { modifier in
        modifier.name.text == "required"
      }
      
      let isConvenience = initializer.modifiers.anySatisfy { modifier in
        modifier.name.text == "convenience"
      }
      
      return isRequired || !isConvenience
    }
    
    
    return candidates.first
  }
  
}

