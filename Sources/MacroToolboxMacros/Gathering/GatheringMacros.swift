
// MARK: Gathering (non-throwing)

/// Calls each `function` in `functions` on the  provided`arguments`, gathering the results into a single list.
@freestanding(expression)
public macro gatherEvaluations<R, each T>(
  yielding type: R.Type,
  arguments: (repeat each T),
  functions: [
    (repeat each T) -> R
  ]
) -> [R] = #externalMacro(
  module: "MacroToolboxMacrosPlugin",
  type: "GatherEvaluationsMacro"
)

/// Calls each `function` in `functions` on the  provided`arguments`, gathering the results into a single list.
@freestanding(expression)
public macro gatherEvaluationsWithFlattening<R, K: Sequence<R>, each T>(
  yielding type: R.Type,
  arguments: (repeat each T),
  functions: [
    (repeat each T) -> K
  ]
) -> [R] = #externalMacro(
  module: "MacroToolboxMacrosPlugin",
  type: "GatherEvaluationsWithFlatteningMacro"
)

// MARK: Gathering (throwing)

/// Calls each `function` in `functions` on the  provided`arguments`, gathering the results into a single list.
@freestanding(expression)
public macro gatherThrowingEvaluations<R, each T>(
  yielding type: R.Type,
  arguments: (repeat each T),
  functions: [
    (repeat each T) throws -> R
  ]
) -> [R] = #externalMacro(
  module: "MacroToolboxMacrosPlugin",
  type: "GatherThrowingEvaluationsMacro"
)

/// Calls each `function` in `functions` on the  provided`arguments`, gathering the results into a single list.
@freestanding(expression)
public macro gatherThrowingEvaluationsWithFlattening<R, K: Sequence<R>, each T>(
  yielding type: R.Type,
  arguments: (repeat each T),
  functions: [
    (repeat each T) throws -> K
  ]
) -> [R] = #externalMacro(
  module: "MacroToolboxMacrosPlugin",
  type: "GatherThrowingEvaluationsWithFlatteningMacro"
)
