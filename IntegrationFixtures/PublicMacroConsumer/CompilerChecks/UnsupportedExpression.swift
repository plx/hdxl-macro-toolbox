import FixtureOptionsModels
import FixtureMacros

let runtimeItem = FixtureItem.second

@FixtureMembers(options: FixtureOptions(
  visibility: .public,
  items: [.first, runtimeItem]
))
public struct UnsupportedExpression { let seed: Int }
