import FixtureOptionsModels
import FixtureMacros

@FixtureMembers(options: FixtureOptions(visibility: .public, items: [.first]))
public struct UnsupportedMember {
  lazy var seed: Int = 1
}
