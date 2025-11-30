
// MARK: PerformanceAnnotationDisposition

public struct PerformanceAnnotationDisposition {
  
  public var inlinabilityDisposition: InlinabilityDisposition?
  public var explicitInlineDisposition: ExplicitInlineDisposition?
  
  public init(
    inlinabilityDisposition: InlinabilityDisposition?,
    explicitInlineDisposition: ExplicitInlineDisposition?
  ) {
    self.inlinabilityDisposition = inlinabilityDisposition
    self.explicitInlineDisposition = explicitInlineDisposition
  }
}

// MARK: - Synthesized Conformances

extension PerformanceAnnotationDisposition: Sendable { }
extension PerformanceAnnotationDisposition: Equatable { }
extension PerformanceAnnotationDisposition: Hashable { }
extension PerformanceAnnotationDisposition: Codable { }

// MARK: - CaseIterable

extension PerformanceAnnotationDisposition: CaseIterable {
  
  public static let allCases: [PerformanceAnnotationDisposition] = {
    let inlinabilityDispositions: [InlinabilityDisposition?] = [.none] + InlinabilityDisposition.allCases.map { $0}
    let explicitInlineDisposition: [ExplicitInlineDisposition?] = [.none] + ExplicitInlineDisposition.allCases.map { $0 }
    var result: [Self] = []
    
    result.reserveCapacity(
      inlinabilityDispositions.count
      *
      explicitInlineDisposition.count
    )
    
    for inlinabilityDisposition in inlinabilityDispositions {
      for explicitInlineDisposition in explicitInlineDisposition {
        result.append(
          Self(
            inlinabilityDisposition: inlinabilityDisposition,
            explicitInlineDisposition: explicitInlineDisposition
          )
        )
      }
    }
    
    return result
  }()
}

// MARK: - API

extension PerformanceAnnotationDisposition {

  @inlinable
  public func performanceAnnotationSourceCodeRepresentation(
    visibilityLevel: VisibilityLevel,
    attachmentSite: PerformanceAnnotationAttachmentSite,
    includeTrailingNewlineWhenNecessary: Bool = true,
    separatorBetweenAnnotations: String = " "
  ) -> String? {
    var chunks: [String] = []
    if let inlinabilityDisposition = InlinabilityDisposition.strongestAvailableDisposition(
      attachmentSite: attachmentSite,
      declarationVisibility: visibilityLevel,
      dispositionHint: inlinabilityDisposition
    ) {
      chunks.append(inlinabilityDisposition.sourceCodeStringRepresentation)
    }
    
    if let explicitInlineDisposition = explicitInlineDisposition?.appropriateDisposition(forAttachmentSite: attachmentSite) {
      chunks.append(explicitInlineDisposition.sourceCodeStringRepresentation)
    }
    
    guard !chunks.isEmpty else {
      return nil
    }
    
    let rawDeclaration = chunks.joined(separator: separatorBetweenAnnotations)
     
    switch includeTrailingNewlineWhenNecessary {
    case true:
      return rawDeclaration + "\n"
    case false:
      return rawDeclaration
    }
  }
  
}
