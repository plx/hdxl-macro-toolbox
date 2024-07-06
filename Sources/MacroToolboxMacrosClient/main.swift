import MacroToolboxMacros

let foo: (String, Int) -> String = { "foo: " + String(repeating: $0, count: $1) }
let bar: (String, Int) -> String = { "bar: " + String($1) + $0 }
let baz: (String, Int) -> String = { "baz: " + $0 + String($1) }

let gathered = #gatherEvaluations(
  yielding: String.self,
  arguments: ("quux", 7),
  functions: [
    foo,
    bar,
    baz,
    { (string: String, int: Int) -> String in "\(int)\(string)\(int)" }
  ]
)

print("`gathered`: \(gathered)")
