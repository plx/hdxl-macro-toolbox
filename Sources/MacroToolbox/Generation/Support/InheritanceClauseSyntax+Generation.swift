import SwiftSyntax

extension InheritanceClauseSyntax {
  
  public static func forInheritedTypeNames(_ inheritedTypeNames: some Sequence<String>)-> Self {
    InheritanceClauseSyntax(
      inheritedTypes: .forTypeNames(inheritedTypeNames)
    )
  }
  
}
