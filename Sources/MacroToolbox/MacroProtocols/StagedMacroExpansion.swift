/// Explicit, independently testable stages over caller-owned types. A plan may be a pure domain
/// value or a host rendering value. No option decoding, attachment policy, or role-shared cache
/// is implicit in this helper. Callers keep plans immutable and instantiate state per invocation.
public struct StagedMacroExpansion<Input, Validated, Plan, Output> {
  private let validate: (Input) throws -> Validated
  private let makePlan: (Validated) throws -> Plan
  private let renderPlan: (Plan) throws -> Output

  public init(
    validate: @escaping (Input) throws -> Validated,
    plan: @escaping (Validated) throws -> Plan,
    render: @escaping (Plan) throws -> Output
  ) {
    self.validate = validate; makePlan = plan; renderPlan = render
  }

  /// Validate/decode once, then prepare the caller's plan, without invoking rendering.
  public func prepare(_ input: Input) throws -> Plan { try makePlan(validate(input)) }

  /// The renderer receives only the completed plan, never the original input implicitly.
  public func render(_ plan: Plan) throws -> Output { try renderPlan(plan) }

  public func expand(_ input: Input) throws -> Output { try render(prepare(input)) }
}
