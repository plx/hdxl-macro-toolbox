import SwiftSyntax
import SwiftParser

extension SimpleStringLiteralExprSyntax {
  
  /// Obtains the represented string as a `String`.
  @inlinable
  public var representedStringLiteralValue: String? {
    var result: String = ""
    for segment in segments {
      result.append(
        segment.content.text
      )
    }
    
    return result
  }
  
}
