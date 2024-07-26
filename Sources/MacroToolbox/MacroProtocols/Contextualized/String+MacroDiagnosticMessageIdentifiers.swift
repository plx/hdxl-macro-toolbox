
/// Contains "mesage identifiers" associated macro expansion (any type).
extension String {

  /// For use when some value was empty, but shouldn't have been.
  public static let mustNotBeEmpty: String = "must-not-be-empty"
  
  /// For use when some value was unobtainable (e.g. errored or `nil`).
  public static let unableToObtainRequiredValue: String = "unable-to-obtain-required-value"

  /// For use when something wasn't transflectable as-expected.
  public static let unableToPerformRequiredTransflection: String = "unable-to-perform-required-transflection"

  /// For use when some particular property was `nil`.
  public static let requiredPropertyWasNil: String = "required-property-was-nil"
  
  /// For use when some logical condition evaluated to `false`.
  public static let necessaryConditionWasFalse: String = "necessary-condition-was-false"
}
