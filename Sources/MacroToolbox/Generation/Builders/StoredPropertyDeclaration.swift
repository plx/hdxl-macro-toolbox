import SwiftSyntax
import SwiftSyntaxBuilder

public enum Isolation {
  case isolated
  case `nonisolated`
}

public struct StoredProperty {
  
  public var name: String
  public var typeName: String
  public var visibility: VisibilityLevel?
  public var setterVisibility: VisibilityLevel?
  public var isolation: Isolation
  public var attributes: [String]
  public var initialValueExpression: String?
  
  public init(
    name: String,
    typeName: String,
    visibility: VisibilityLevel? = nil,
    setterVisibility: VisibilityLevel? = nil,
    isolation: Isolation = .isolated,
    attributes: [String] = [],
    initialValueExpression: String? = nil
  ) {
    self.name = name
    self.typeName = typeName
    self.visibility = visibility
    self.setterVisibility = setterVisibility
    self.isolation = isolation
    self.attributes = attributes
    self.initialValueExpression = initialValueExpression
  }
  
}

extension StoredProperty: ConcreteDeclSyntaxDeclaration, DeclSyntaxDeclaration {
  public typealias DeclSyntaxType = VariableDeclSyntax
  
  internal var visibilityDeclaration: String? {
    visibility?.sourceCodeStringRepresentation
  }
  
  internal var setterVisibilityDeclaration: String? {
    visibility.map {
      "\($0.sourceCodeStringRepresentation)(set)"
    }
  }
  
  internal var isolationDeclaration: String? {
    switch isolation {
    case .isolated:
      nil
    case .nonisolated:
      "nonisolated"
    }
  }
  
  internal var modifierDeclaration: String {
    var components: [String] = []
    components.append(ifNonNull: isolationDeclaration)
    components.append(ifNonNull: visibilityDeclaration)
    components.append(ifNonNull: setterVisibilityDeclaration)
    
    return components.joined(separator: " ")
  }
  
  internal var attributeDeclaration: String {
    attributes.joined(separator: "\n")
  }
  
  public func makeSyntaxRepresentation() throws -> VariableDeclSyntax {
    let initialValueExpression = initialValueExpression.map { " = \($0)" } ?? ""
    
    return try VariableDeclSyntax(
      """
      \(raw: attributeDeclaration)
      \(raw: modifierDeclaration) var \(raw: name): \(raw: typeName)\(raw: initialValueExpression)
      """
    )
  }
  
}

extension RangeReplaceableCollection {
  
  mutating func append(ifNonNull value: Element?) {
    guard let value else { return }
    append(value)
  }
  
}

public protocol ConcreteDeclSyntaxDeclaration<DeclSyntaxType> {
  associatedtype DeclSyntaxType: DeclSyntaxProtocol
  
  func makeSyntaxRepresentation() throws -> DeclSyntaxType
}

extension ConcreteDeclSyntaxDeclaration where Self: DeclSyntaxDeclaration {
  
  @inlinable
  public func makeDeclSyntax() throws -> DeclSyntax {
    try makeSyntaxRepresentation().eraseToValidatedDeclSyntax()
  }

}

public protocol DeclSyntaxDeclaration {
  
  func makeDeclSyntax() throws -> DeclSyntax
  
}

