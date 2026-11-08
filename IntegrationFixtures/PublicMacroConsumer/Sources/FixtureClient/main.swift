import FixtureOptionsModels
import FixtureMacros
import FixtureExamples

let options = FixtureOptions(visibility: .public, items: [.first, .second])
let value = PublicExample(seed: 7)
precondition(value.seed == 7 && value.fixtureItems == options.items)
let empty = EmptyExample(seed: 9)
precondition(empty.seed == 9 && empty.fixtureItems.isEmpty)
print("Public macro consumer passed.")
