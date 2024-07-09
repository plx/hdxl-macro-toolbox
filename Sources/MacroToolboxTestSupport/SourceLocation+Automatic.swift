import Testing

extension SourceLocation {
  
  /// Temporary fix for `SourceLocation` losing its `SourceLocation()` init variant.
  package static func automatic(
    fileID: String = #fileID,
    filePath: String = #filePath,
    line: Int = #line,
    column: Int = #column
  ) -> Self {
    Self(
      fileID: fileID,
      filePath: filePath,
      line: line,
      column: column
    )
  }
  
}
