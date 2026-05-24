import Testing
import MacroToolboxTestSupport
@testable import MacroToolbox

@Test("Case-name aware enumeration defaults")
func testCaseNameAwareEnumerationDefaults() {
  // Hand-written example: a raw-string enum should derive the bare case name,
  // the dotted case spelling, and the display descriptions from the same case.
  #expect(SupportExampleCase.alpha.caseNameWithoutLeadingDot == "alpha")
  #expect(SupportExampleCase.alpha.caseNameWithLeadingDot == ".alpha")
  #expect(SupportExampleCase.alpha.description == ".alpha")
  #expect(SupportExampleCase.alpha.debugDescription.hasSuffix(".alpha"))
  
  // Hand-written example: CodingKey conformers use the dedicated overloads
  // that avoid ambiguity with CodingKey's own descriptive requirements.
  #expect(SupportExampleCodingKey.beta.description == ".beta")
  #expect(SupportExampleCodingKey.beta.debugDescription.hasSuffix(".beta"))
}

@Test("Case-name aware enumeration defaults derive from raw values")
func testCaseNameAwareEnumerationDefaultsDeriveFromRawValues() {
  // Property-style test: every case's derived spellings must be a mechanical
  // transformation of its raw value, which is the invariant the protocol
  // extension promises for raw-string enumerations.
  for example in SupportExampleCase.allCases {
    #expect(example.caseNameWithoutLeadingDot == example.rawValue)
    #expect(example.caseNameWithLeadingDot == ".\(example.rawValue)")
    #expect(example.description == example.caseNameWithLeadingDot)
    #expect(example.debugDescription.hasSuffix(example.caseNameWithLeadingDot))
  }
  
  for example in SupportExampleCodingKey.allCases {
    #expect(example.caseNameWithoutLeadingDot == example.rawValue)
    #expect(example.description == example.caseNameWithLeadingDot)
    #expect(example.debugDescription.hasSuffix(example.caseNameWithLeadingDot))
  }
}

@Test("Collection unless-empty helper")
func testCollectionUnlessEmptyHelper() {
  // Hand-written example: a non-empty collection survives unchanged, while an
  // empty collection becomes nil so callers can express absence directly.
  #expect([1, 2, 3].unlessEmpty == [1, 2, 3])
  #expect([Int]().unlessEmpty == nil)
}

@Test("Collection unless-empty helper matches emptiness")
func testCollectionUnlessEmptyHelperMatchesEmptiness() {
  // Property-style test: for several collection sizes, the helper's optionality
  // is exactly the collection's `isEmpty` value and the payload is unchanged.
  for values in [[Int](), [1], [1, 2, 3]] {
    let result = values.unlessEmpty
    
    #expect((result == nil) == values.isEmpty)
    #expect(result ?? [] == values)
  }
}

@Test("Optional ensured-value helper")
func testOptionalEnsuredValueHelper() {
  // Hand-written example: an existing value must be returned without invoking
  // the fallback, while nil must store and return the fallback.
  var existing: Int? = 7
  var fallbackWasEvaluated = false
  let existingValue = existing.ensuredValue(
    guaranteedBy: {
      fallbackWasEvaluated = true
      return 9
    }()
  )
  
  var missing: Int? = nil
  let missingValue = missing.ensuredValue(guaranteedBy: 11)
  
  #expect(existingValue == 7)
  #expect(existing == 7)
  #expect(!fallbackWasEvaluated)
  #expect(missingValue == 11)
  #expect(missing == 11)
}

@Test("Automatic source locations preserve explicit coordinates")
func testAutomaticSourceLocationsPreserveExplicitCoordinates() {
  // Hand-written example: the temporary test-support shim should pass through
  // explicit file and coordinate values to Testing's SourceLocation initializer.
  let location = Testing.SourceLocation.automatic(
    fileID: "MacroToolboxTests/CoreSupport",
    filePath: "/tmp/CoreSupport.swift",
    line: 12,
    column: 34
  )
  
  #expect(location.fileID == "MacroToolboxTests/CoreSupport")
  #expect(location.filePath == "/tmp/CoreSupport.swift")
  #expect(location.line == 12)
  #expect(location.column == 34)
}

@Test("Optional ensured-value helper is stable after insertion")
func testOptionalEnsuredValueHelperIsStableAfterInsertion() {
  // Property-style test: after the first fallback insertion, repeated calls
  // must keep returning the stored value rather than replacing it.
  for fallback in [0, 1, 42] {
    var value: Int? = nil
    
    #expect(value.ensuredValue(guaranteedBy: fallback) == fallback)
    #expect(value.ensuredValue(guaranteedBy: fallback + 1) == fallback)
    #expect(value == fallback)
  }
}

@Test("Sequence support helpers")
func testSequenceSupportHelpers() {
  // Hand-written examples: each helper is pinned to the standard-library
  // operation it abbreviates so the intended behavior stays obvious.
  #expect([1, 3, 4].anySatisfy { $0.isMultiple(of: 2) })
  #expect(![1, 3, 5].anySatisfy { $0.isMultiple(of: 2) })
  #expect([1, 2, 3].firstNonNilValue { $0 > 1 ? "\($0)" : nil } == "2")
  #expect([Int?](arrayLiteral: 1, nil, 3).dropNilElements() == [1, 3])
}

@Test("Sequence support helpers match standard-library equivalents")
func testSequenceSupportHelpersMatchStandardLibraryEquivalents() {
  // Property-style test: across several sequences and predicates, these helpers
  // must match the standard-library compositions they are replacing.
  let samples = [
    [Int](),
    [1],
    [1, 2, 3, 4],
    [5, 7, 9]
  ]
  
  for values in samples {
    for divisor in [2, 3, 5] {
      #expect(
        values.anySatisfy { $0.isMultiple(of: divisor) }
        ==
        values.contains { $0.isMultiple(of: divisor) }
      )
    }
    
    #expect(
      values.firstNonNilValue { $0 > 2 ? "\($0)" : nil }
      ==
      values.compactMap { $0 > 2 ? "\($0)" : nil }.first
    )
  }
  
  for values in [
    [Int?](),
    [nil, 1, nil, 2],
    [3, 4, 5]
  ] {
    #expect(values.dropNilElements() == values.compactMap { $0 })
  }
}

@Test("Set set-map helper")
func testSetMapHelper() {
  // Hand-written example: mapping a non-empty set transforms all elements into
  // a set, and mapping an empty set returns an empty set without invoking work.
  #expect(Set([1, 2, 3]).setMap { "\($0)" } == Set(["1", "2", "3"]))
  #expect(Set<Int>().setMap { "\($0)" } == [])
}

@Test("Set set-map helper matches Set over mapped values")
func testSetMapHelperMatchesSetOverMappedValues() {
  // Property-style test: with and without the uniqueness capacity hint, the
  // result must equal constructing a Set from the standard mapped sequence.
  for values in [
    Set<Int>(),
    Set([1]),
    Set([1, 2, 3])
  ] {
    #expect(
      values.setMap(expectUnique: true) { $0 % 2 }
      ==
      Set(values.map { $0 % 2 })
    )
    #expect(
      values.setMap(expectUnique: false) { $0 % 2 }
      ==
      Set(values.map { $0 % 2 })
    )
  }
}

@Test("String first-character lowercasing")
func testStringFirstCharacterLowercasing() {
  // Hand-written examples: the helper should leave empty strings empty and only
  // lowercase the first character of both String and Substring inputs.
  #expect(String(lowercasingFirstCharacterOf: "") == "")
  #expect(String(lowercasingFirstCharacterOf: "Widget") == "widget")
  #expect(String(lowercasingFirstCharacterOf: "URLValue".dropFirst()) == "rLValue")
}

@Test("String first-character lowercasing matches manual construction")
func testStringFirstCharacterLowercasingMatchesManualConstruction() {
  // Property-style test: for several ASCII spellings, the helper should match
  // manually lowercasing the first character and appending the untouched suffix.
  for value in ["", "A", "URLValue", "already", "1Number"] {
    let expected: String
    if value.isEmpty {
      expected = ""
    } else {
      let splitIndex = value.index(after: value.startIndex)
      expected = "\(value.prefix(upTo: splitIndex).lowercased())\(value.suffix(from: splitIndex))"
    }
    
    #expect(String(lowercasingFirstCharacterOf: value) == expected)
    #expect(String(lowercasingFirstCharacterOf: value[...]) == expected)
  }
}

@Test("String tuple stringification helpers")
func testStringTupleStringificationHelpers() {
  // Hand-written examples: each tuple-string initializer gets a two-element
  // sample so both first-element and separator paths are pinned explicitly.
  #expect(
    String(forCaption: "point", describingTuple: (1, "two"))
    ==
    "(point: 1, two)"
  )
  #expect(String(describingTuple: (1, "two")) == "(1, two)")
  #expect(
    String(describingLabeledTuple: (("x", 1), ("y", "two")))
    ==
    "(x: 1, y: two)"
  )
  #expect(
    String(reflectingLabeledTuple: (("x", "one"), ("y", 2)))
    ==
    #"(x: "one", y: 2)"#
  )
  #expect(Optional<String>.none.argumentLabelRepresentation == "")
  #expect(Optional("").argumentLabelRepresentation == "")
  #expect(Optional("value").argumentLabelRepresentation == "value: ")

  // Single-element variadic packs: Swift represents `(repeat each T)` as the
  // scalar element type when the pack has exactly one element, so the
  // initializers must iterate the pack directly rather than relying on
  // `Mirror`-based child enumeration, which would yield zero children for a
  // scalar like `Int` and silently drop the argument.
  #expect(
    String(forCaption: "solo", describingTuple: (1))
    ==
    "(solo: 1)"
  )
  #expect(String(describingTuple: (1)) == "(1)")

  // Labeled single-element packs cannot be expressed with literal tuple
  // syntax — Swift cannot disambiguate `(String, T)` between a 1-element
  // labeled pack and a 2-element non-labeled pack — so the regression is
  // exercised through generic wrappers that forward a real pack expansion.
  #expect(forwardingDescribingLabeledTuple(("x", 1)) == "(x: 1)")
  #expect(forwardingReflectingLabeledTuple(("x", "one")) == #"(x: "one")"#)
}

private func forwardingDescribingLabeledTuple<each T>(
  _ labeledValues: repeat (String, each T)
) -> String {
  String(describingLabeledTuple: (repeat each labeledValues))
}

private func forwardingReflectingLabeledTuple<each T>(
  _ labeledValues: repeat (String, each T)
) -> String {
  String(reflectingLabeledTuple: (repeat each labeledValues))
}

@Test("String constructor stringification helpers preserve labels and arguments")
func testStringConstructorStringificationHelpersPreserveLabelsAndArguments() {
  // Property-style test: constructor spellings are checked across labeled,
  // unlabeled, nil-label, and empty-label arguments so label insertion stays
  // consistent with `argumentLabelRepresentation`.
  let labeled = String(
    forConstructorOf: TupleStringificationFixture.self,
    arguments: ((nil, 1), ("label", "two"), ("", 3))
  )
  let unlabeled = String(
    forConstructorOf: TupleStringificationFixture.self,
    unlabeledArguments: (1, "two", 3)
  )

  #expect(labeled.hasSuffix(#"TupleStringificationFixture(1, label: "two", 3)"#))
  #expect(unlabeled.hasSuffix(#"TupleStringificationFixture(1, "two", 3)"#))

  // Single-element packs must also reach the constructor-string initializers
  // without losing the argument, since variadic packs collapse to the scalar
  // type for one element. The labeled constructor takes pairs whose first
  // component is `String?`, so Swift cannot disambiguate a literal pair from
  // a 2-element pack of non-labeled values — the regression is exercised via
  // a generic wrapper that forwards a real pack expansion.
  let singleLabeled = forwardingForConstructorArgument(("label", 1))
  let singleUnlabeled = String(
    forConstructorOf: TupleStringificationFixture.self,
    unlabeledArguments: (1)
  )

  #expect(singleLabeled.hasSuffix("TupleStringificationFixture(label: 1)"))
  #expect(singleUnlabeled.hasSuffix("TupleStringificationFixture(1)"))
  
  for label in [String?.none, "", "value"] {
    let expected = label.map { $0.isEmpty ? "" : "\($0): " } ?? ""
    #expect(label.argumentLabelRepresentation == expected)
  }
  
  // Hand-written edge cases: the reflection fallbacks should preserve a useful
  // description when a helper is called with a value that is not a labeled pair.
  #expect(
    String.constructorArgumentComponents(reflecting: (1, ("label", 2)))
    ==
    ["1", "label: 2"]
  )
  #expect(
    String.tuplePairComponents(from: (1, ("x", 2))) { pair in
      "\(pair.label)=\(pair.value)"
    }
    ==
    ["1", "x=2"]
  )
  let missingParsedLabel: String?? = String.parsedConstructorArgumentLabel(
    from: 1
  )
  #expect(missingParsedLabel == nil)
}

private func forwardingForConstructorArgument<each T>(
  _ labeledValues: repeat (String?, each T)
) -> String {
  String(
    forConstructorOf: TupleStringificationFixture.self,
    arguments: (repeat each labeledValues)
  )
}

private enum SupportExampleCase: String, CaseIterable, MacroToolboxCaseNameAwareEnumeration, CustomStringConvertible, CustomDebugStringConvertible {
  case alpha
  case beta
}

private enum SupportExampleCodingKey: String, CaseIterable, CodingKey, MacroToolboxCaseNameAwareEnumeration {
  case alpha
  case beta
  
  var stringValue: String {
    rawValue
  }
  
  init?(stringValue: String) {
    self.init(rawValue: stringValue)
  }
  
  var intValue: Int? {
    nil
  }
  
  init?(intValue: Int) {
    nil
  }
}

private struct TupleStringificationFixture {}
