import SwiftSyntax

public struct ForEach<
  Element,
  Source,
  Output
> where Source: Collection<Element> {
  
  @usableFromInline
  internal let source: Source

  @usableFromInline
  internal let transformation: (Element) -> [Output]
    
  @inlinable
  init(
    source: Source,
    function: StaticString = #function,
    file: StaticString = #file,
    line: UInt = #line,
    transformation: @escaping (Element) -> [Output]
  ) {
    self.source = source
    self.transformation = transformation
  }
  
  @inlinable
  internal func evaluate() -> [Output] {
    source.flatMap(transformation)
  }
  
}
