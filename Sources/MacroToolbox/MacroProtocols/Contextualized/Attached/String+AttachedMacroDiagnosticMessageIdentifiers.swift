
/// Contains "mesage identifiers" associated specifically with attached-macro expansion. 
extension String {
  
  /// Message identifier for when our macro is attached to the wrong type-of-thing.
  ///
  /// - note: This is emitted during validation, as part of the general-purpose archetype-check.
  public static let attachedToExcludedArchetype: String = "attached-to-excluded-archetype"

  /// Message identifier for when our macro found something, but it was of the wrong type.
  ///
  /// - note: This is emitted during generation, e.g. by trying-and-failing to get the declaration as a struct-decl (or similar).
  public static let declarationOfIncorrectType: String = "declaration-of-incorrect-type"

}
