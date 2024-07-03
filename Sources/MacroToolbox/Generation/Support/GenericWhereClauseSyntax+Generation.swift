import SwiftSyntax

extension GenericWhereClauseSyntax {
  
  @inlinable
  public init(requirements: some Collection<GenericRequirementSyntax>) {
    self.init(
      requirements: GenericRequirementListSyntax(
        withTrailingCommasInsertedBetween: requirements
      )
    )
  }

  @inlinable
  public static func withTransformedCartesianProduct<A,B>(
    of factors: (some Collection<A>, some Collection<B>),
    transformation: (A, B) throws -> GenericRequirementSyntax
  ) rethrows -> Self {
    var requirements: [GenericRequirementSyntax] = []
    requirements.reserveCapacity(factors.0.count * factors.1.count)
    for aFactor in factors.0 {
      for bFactor in factors.1 {
        requirements.append(
          try transformation(aFactor, bFactor)
        )
      }
    }
    
    return Self(requirements: requirements)
  }

  @inlinable
  public static func withFailablyTransformedCartesianProduct<A,B>(
    of factors: (some Collection<A>, some Collection<B>),
    transformation: (A, B) throws -> GenericRequirementSyntax?
  ) rethrows -> Self {
    var requirements: [GenericRequirementSyntax] = []
    requirements.reserveCapacity(factors.0.count * factors.1.count)
    for aFactor in factors.0 {
      for bFactor in factors.1 {
        if let requirement = try transformation(aFactor, bFactor) {
          requirements.append(
            requirement
          )
        }
      }
    }
    
    return Self(requirements: requirements)
  }

}
