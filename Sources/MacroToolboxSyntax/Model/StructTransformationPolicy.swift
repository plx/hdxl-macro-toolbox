import MacroToolboxModels
import SwiftSyntax

/// Shapes a particular transformation explicitly supports. These are not newtype/accumulator
/// rules: callers still decide emptiness, generated names, access, and attachment restrictions.
public struct StructTransformationPolicy: Sendable {
  public var supportedAccessorShapes: Set<PropertyAccessorShape>
  public var allowedOtherDeclarations: Set<DeclarationArchetype>
  public var requiresWrittenTypes: Bool
  /// Opting in acknowledges that the caller handles the preserved attribute semantics itself.
  public var supportsAttributedBindings: Bool
  public var supportsLazyBindings: Bool

  public init(
    supportedAccessorShapes: Set<PropertyAccessorShape> = [.stored],
    allowedOtherDeclarations: Set<DeclarationArchetype> = [],
    requiresWrittenTypes: Bool = true,
    supportsAttributedBindings: Bool = false,
    supportsLazyBindings: Bool = false
  ) {
    self.supportedAccessorShapes = supportedAccessorShapes
    self.allowedOtherDeclarations = allowedOtherDeclarations
    self.requiresWrittenTypes = requiresWrittenTypes
    self.supportsAttributedBindings = supportsAttributedBindings
    self.supportsLazyBindings = supportsLazyBindings
  }
}

/// Validation failed as a whole. Every rejection is available; no partial validated field list
/// is returned. The original analysis remains available to the caller for diagnostics.
public struct StructAnalysisRejection: Error, Sendable {
  public let findings: [StructAnalysisFinding]
}

/// Constructed only by successful validation. It retains all original members and bindings,
/// including limitations the caller deliberately supports, rather than filtering a field list.
public struct ValidatedStructMembers: Sendable {
  public let analysis: StructMemberAnalysis
  public var members: [StructMemberDescriptor] { analysis.members }
  public var bindings: [StructBindingDescriptor] { analysis.bindings }
  fileprivate init(analysis: StructMemberAnalysis) { self.analysis = analysis }
}

extension StructMemberAnalysis {
  public func validated(using policy: StructTransformationPolicy = .init()) throws -> ValidatedStructMembers {
    var rejections = findings.filter { finding in
      switch finding.reason {
      case .missingTypeAnnotation: return policy.requiresWrittenTypes
      case .attributedBinding: return !policy.supportsAttributedBindings
      case .lazyBinding: return !policy.supportsLazyBindings
      default: return true
      }
    }
    for member in members {
      if member.bindings.isEmpty, member.kind != .variable,
         !member.findings.contains(where: { $0.reason == .conditionalMember || $0.reason == .expandedMember || $0.reason == .unsupportedMember(nil) }),
         member.kind.map({ !policy.allowedOtherDeclarations.contains($0) }) ?? true {
        rejections.append(.init(reason: .unsupportedMember(member.kind), anchor: Syntax(member.declaration), memberIndex: member.index, bindingIndex: nil))
      }
      for binding in member.bindings where binding.accessorShape != .unfamiliar && !policy.supportedAccessorShapes.contains(binding.accessorShape) {
        rejections.append(.init(reason: .unsupportedAccessorShape(binding.accessorShape), anchor: binding.accessorBlock.map(Syntax.init) ?? Syntax(binding.binding), memberIndex: binding.memberIndex, bindingIndex: binding.bindingIndex))
      }
    }
    guard rejections.isEmpty else {
      throw StructAnalysisRejection(findings: rejections.sorted {
        $0.anchor.positionAfterSkippingLeadingTrivia < $1.anchor.positionAfterSkippingLeadingTrivia
      })
    }
    return .init(analysis: self)
  }
}
