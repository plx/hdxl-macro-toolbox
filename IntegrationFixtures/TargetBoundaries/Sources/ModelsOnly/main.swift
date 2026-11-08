import MacroToolboxModels

struct SharedOptions {
  var visibility: VisibilityLevel
  var locations: [ArgumentLocationDescriptor]
}
let options = SharedOptions(visibility: .public, locations: [.first, .labeled("options")])
precondition(options.visibility > .internal)
precondition(options.visibility.sourceCodeStringRepresentation == "public")
precondition(options.locations[1] == .labeled("options"))
precondition(InlinabilityDisposition.inlinable.sourceCodeStringRepresentation == "@inlinable")
print("ModelsOnly passed")
