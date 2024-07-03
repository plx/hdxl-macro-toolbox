import SwiftSyntax

extension VisibilityLevel {

  /// Prepares the equivalent `TokenSyntax`, with customizable `leadingTrivia` and `trailingTriva`.
  @inlinable
  public func tokenRepresentation(
    leadingTrivia: Trivia = [],
    trailingTrivia: Trivia = []
  ) -> TokenSyntax {
    TokenSyntax.keyword(
      keywordRepresentation,
      leadingTrivia: leadingTrivia,
      trailingTrivia: trailingTrivia
    )
  }
  
  /// Provides the equivalent `Keyword`.
  @inlinable
  public var keywordRepresentation: Keyword {
    switch self {
    case .private:
      .private
    case .fileprivate:
      .fileprivate
    case .internal:
      .internal
    case .package:
      .package
    case .public:
      .public
    case .open:
      .open
    }
  }
  
  /// Provides equivalent `TokenKind` representation.
  @inlinable
  public var tokenKindRepresentation: TokenKind {
    .keyword(keywordRepresentation)
  }
  
}

extension Keyword {
  
  /// Constructs a `Keyword` from `visibilityLevel`.
  ///
  /// - seealso: ``VisibilityLevel``
  /// - seealso: ``VisibilityLevel.keywordRepresentation``
  ///
  @inlinable
  public init(visibilityLevel: VisibilityLevel) {
    self = visibilityLevel.keywordRepresentation
  }
  
}

extension TokenKind {
  
  /// Constructs a `Token` from `visibilityLevel`.
  ///
  /// - seealso: ``VisibilityLevel``
  /// - seealso: ``VisibilityLevel.toenKindRepresentation``
  ///
  @inlinable
  public init(visibilityLevel: VisibilityLevel) {
    self = visibilityLevel.tokenKindRepresentation
  }
  
}

extension TokenSyntax {
  
  /// Constructs `TokenSyntax` from `visibilityLevel`, with customizable `leadingTrivia` and `trailingTriva`.
  ///
  /// - seealso: ``VisibilityLevel``
  /// - seealso: ``VisibilityLevel.tokenRepresentation(leadingTrivia:trailingTrivia:)``
  ///
  @inlinable
  public init(
    leadingTrivia: Trivia = [],
    visibilityLevel: VisibilityLevel,
    trailingTrivia: Trivia = []
  ) {
    self = visibilityLevel.tokenRepresentation(
      leadingTrivia: leadingTrivia,
      trailingTrivia: trailingTrivia
    )
  }
  
}
