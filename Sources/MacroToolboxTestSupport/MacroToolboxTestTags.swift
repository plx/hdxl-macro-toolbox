import Testing

package extension Tag {
  
  @Tag
  static var declarationArchetype: Self

  @Tag
  static var explicitInlineDisposition: Self
  
  @Tag
  static var inlinabilityDisposition: Self
  
  @Tag
  static var visibilityLevel: Self

  @Tag
  static var typeDeclarationArchetype: Self
    
  @Tag
  static var macroAttachmentRequirement: Self

  @Tag
  static var performanceAnnotationAttachmentSite: Self
  
  @Tag
  static var syntaxInteroperation: Self

}

package extension Tag {
  
  @Tag
  static var attributeSyntax: Self
  
  @Tag
  static var tokenSyntax: Self
  
  @Tag
  static var tokenKind: Self
  
  @Tag
  static var keyword: Self
  
  @Tag
  static var booleanLiteralExprSyntax: Self
  
  @Tag
  static var syntaxIntrospection: Self
}

package extension Tag {
  
  @Tag
  static var testInfrastructure: Self 
}

package extension Tag {
  
  @Tag
  static var positiveExamples: Self

  @Tag
  static var negativeExamples: Self
  
  @Tag
  static var unrepresentableValues: Self

}
