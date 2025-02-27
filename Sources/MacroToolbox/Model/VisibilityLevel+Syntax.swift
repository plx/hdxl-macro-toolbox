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
  
  /// Constructs from the corresponding keyword.
  @inlinable
  public init?(keywordRepresentation: Keyword) {
    switch keywordRepresentation {
    case .private:
      self = .private
    case .fileprivate:
      self = .fileprivate
    case .internal:
      self = .internal
    case .package:
      self = .package
    case .public:
      self = .public
    case .open:
      self = .open
    default:
      return nil
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
  /// - seealso: ``VisibilityLevel.tokenKindRepresentation``
  ///
  @inlinable
  public init(visibilityLevel: VisibilityLevel) {
    self = visibilityLevel.tokenKindRepresentation
  }
  
  @inlinable
  public var visibilityLevel: VisibilityLevel? {
    guard case .keyword(let keyword) = self else {
      return nil
    }
    
    return keyword.visibilityLevel
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

extension VisibilityLevel {
  
  /// Obtain the text uses to represent this visibility level within source code (e.g. `"private"` for `.private`).
  @inlinable
  public var sourceCodeStringRepresentation: String {
    switch self {
    case .private:
      "private"
    case .fileprivate:
      "fileprivate"
    case .internal:
      "internal"
    case .package:
      "package"
    case .public:
      "public"
    case .open:
      "open"
    }
  }
  
}
