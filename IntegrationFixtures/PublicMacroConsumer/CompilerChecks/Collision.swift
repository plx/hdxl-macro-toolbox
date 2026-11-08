import FixtureOptionsModels
import FixtureMacros

@FixtureMembers(options: FixtureOptions(visibility: .public, items: [.first]))
public struct Collision {
  let seed: Int
  var fixtureItems: Int = 0
}
