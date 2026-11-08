import FixtureOptionsModels
import FixtureMacros

@FixtureMembers(options: FixtureOptions(visibility: .public, items: [.first, .second]))
public struct PublicExample { public let seed: Int }

@FixtureMembers(options: FixtureOptions(visibility: .public, items: []))
public struct EmptyExample { public let seed: Swift.Int }
