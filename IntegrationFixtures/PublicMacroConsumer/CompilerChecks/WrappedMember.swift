import FixtureOptionsModels
import FixtureMacros

@propertyWrapper
struct FixtureWrapper { var wrappedValue: Int }

@FixtureMembers(options: FixtureOptions(visibility: .public, items: [.first]))
public struct WrappedMember {
  @FixtureWrapper var seed: Int = 1
}
