import SwiftSyntax

extension SyntaxCollection where Element: WithTrailingCommaSyntax {
  
  @inlinable
  public init(withTrailingCommasInsertedBetween children: some Collection<Element>) {
    let finalElementIndex = children.count - 1
    self.init(
      children.enumerated().map { (index, element) in
        var result = element
        switch index >= finalElementIndex {
        case true:
          result.trailingComma = nil
        case false:
          result.trailingComma = TokenSyntax.commaToken()
        }
        
        return result
      }
    )
  }
  
}
