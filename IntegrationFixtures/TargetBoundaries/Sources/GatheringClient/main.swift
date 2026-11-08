import MacroToolboxMacros

let add: (Int, Int) -> Int = { $0 + $1 }
let subtract: (Int, Int) -> Int = { $0 - $1 }
let pair: (Int, Int) -> [Int] = { [$0, $1] }
let scalar = #gatherEvaluations(yielding: Int.self, arguments: (2, 3), functions: [add, subtract])
precondition(scalar == [5, -1])
let flat = #gatherEvaluationsWithFlattening(yielding: Int.self, arguments: (2, 3), functions: [pair])
precondition(flat == [2, 3])
let throwing: (Int, Int) throws -> Int = { $0 + $1 }
let throwingPair: (Int, Int) throws -> [Int] = { [$0, $1] }
let thrownScalar = #gatherThrowingEvaluations(yielding: Int.self, arguments: (2, 3), functions: [throwing])
precondition(thrownScalar == [5])
let thrownFlat = #gatherThrowingEvaluationsWithFlattening(yielding: Int.self, arguments: (2, 3), functions: [throwingPair])
precondition(thrownFlat == [2, 3])
enum ExpectedFailure: Error { case example }
let failing: (Int, Int) throws -> Int = { _, _ in throw ExpectedFailure.example }
let failingPair: (Int, Int) throws -> [Int] = { _, _ in throw ExpectedFailure.example }
do {
  _ = #gatherThrowingEvaluations(yielding: Int.self, arguments: (2, 3), functions: [failing])
  preconditionFailure("Throwing gathering must propagate the function error")
} catch ExpectedFailure.example { }
do {
  _ = #gatherThrowingEvaluationsWithFlattening(yielding: Int.self, arguments: (2, 3), functions: [failingPair])
  preconditionFailure("Throwing flattening must propagate the function error")
} catch ExpectedFailure.example { }
print("All four gathering macros passed")
