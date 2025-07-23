import SwiftSyntax


@resultBuilder
public struct DataTypeBodyBuilder {
  
  public typealias Element = any DeclSyntaxDeclaration
  public typealias Component = [Element]
  public typealias FinalResult = [DeclSyntax]
  
  @inlinable
  public static func buildBlock(_ components: Component...) -> Component {
    components.flatMap { $0 }
  }
  
  @inlinable
  public static func buildExpression(
    _ expression: StoredProperty
  ) -> Component {
    [expression]
  }
  
  @inlinable
  public static func buildExpression<Item,Source>(
    _ expression: ForEach<Item, Source, DeclSyntax>
  ) -> Component {
    expression.evaluate()
  }
  
}

extension DeclSyntaxProtocol where Self: DeclSyntaxDeclaration {
  
  @inlinable
  public func makeDeclSyntax() throws -> DeclSyntax {
    try eraseToValidatedDeclSyntax()
  }
  
}

extension DeclSyntax : DeclSyntaxDeclaration {
  
  @inlinable
  public func makeDeclSyntax() throws -> DeclSyntax {
    self
  }
  
}

extension AccessorDeclSyntax: DeclSyntaxDeclaration { }
extension ActorDeclSyntax: DeclSyntaxDeclaration { }
extension AssociatedTypeDeclSyntax: DeclSyntaxDeclaration { }
extension ClassDeclSyntax: DeclSyntaxDeclaration { }
extension DeinitializerDeclSyntax: DeclSyntaxDeclaration { }
extension EditorPlaceholderDeclSyntax: DeclSyntaxDeclaration { }
extension EnumCaseDeclSyntax: DeclSyntaxDeclaration { }
extension EnumDeclSyntax: DeclSyntaxDeclaration { }
extension ExtensionDeclSyntax: DeclSyntaxDeclaration { }
extension FunctionDeclSyntax: DeclSyntaxDeclaration { }
extension IfConfigDeclSyntax: DeclSyntaxDeclaration { }
extension ImportDeclSyntax: DeclSyntaxDeclaration { }
extension InitializerDeclSyntax: DeclSyntaxDeclaration { }
extension MacroDeclSyntax: DeclSyntaxDeclaration { }
extension MacroExpansionDeclSyntax: DeclSyntaxDeclaration { }
extension MissingDeclSyntax: DeclSyntaxDeclaration { }
extension OperatorDeclSyntax: DeclSyntaxDeclaration { }
extension PoundSourceLocationSyntax: DeclSyntaxDeclaration { }
extension PrecedenceGroupDeclSyntax: DeclSyntaxDeclaration { }
extension ProtocolDeclSyntax: DeclSyntaxDeclaration { }
extension StructDeclSyntax: DeclSyntaxDeclaration { }
extension SubscriptDeclSyntax: DeclSyntaxDeclaration { }
extension TypeAliasDeclSyntax: DeclSyntaxDeclaration { }
extension VariableDeclSyntax: DeclSyntaxDeclaration { }

