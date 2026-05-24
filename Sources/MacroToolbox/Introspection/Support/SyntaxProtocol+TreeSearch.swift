import SwiftSyntax

extension SyntaxProtocol {
  
  /// Returns the first syntax element of `type` in the tree rooted at `self`.
  ///
  /// The search includes `self`, then proceeds depth-first through children.
  @inlinable
  public func firstSyntaxElement<T>(
    ofType type: T.Type = T.self,
    viewMode: SyntaxTreeViewMode = .sourceAccurate
  ) -> T? where T: SyntaxProtocol {
    if let match = self.as(type) {
      return match
    }
    
    for child in children(viewMode: viewMode) {
      if let match = child.firstSyntaxElement(
        ofType: type,
        viewMode: viewMode
      ) {
        return match
      }
    }
    
    return nil
  }
  
  /// Returns all syntax elements of `type` in the tree rooted at `self`.
  ///
  /// The search includes `self`, then proceeds depth-first through children.
  @inlinable
  public func allSyntaxElements<T>(
    ofType type: T.Type = T.self,
    viewMode: SyntaxTreeViewMode = .sourceAccurate
  ) -> [T] where T: SyntaxProtocol {
    var result: [T] = []
    
    if let match = self.as(type) {
      result.append(match)
    }
    
    for child in children(viewMode: viewMode) {
      result.append(
        contentsOf: child.allSyntaxElements(
          ofType: type,
          viewMode: viewMode
        )
      )
    }
    
    return result
  }
  
}
