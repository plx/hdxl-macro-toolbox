import MacroTransflection

/// Synthesizes conformance to ``TransflectableViaSourceCodeIdentifier`` for simple enumerations.
///
/// - note: If necessary, you can exclude particular cases by tagging them with `@ExcludeFromTransflection`
/// - warning: This only supports attachment to "simple" enums (e.g. enums for which *all cases* are payload-free).
///
/// - seealso: ``TransflectableViaSourceCodeIdentifier``
/// - seealso: ``ExcludeFromTransflection()``
/// 
@attached(
  extension,
  conformances: TransflectableViaSourceCodeIdentifier,
  names: named(init(transflectingSourceCodeIdentifier:))
)
public macro AddSourceCodeIdentifierTransflection() = #externalMacro(
  module: "MacroTransflectionMacrosPlugin",
  type: "AddSourceCodeIdentifierTransflectionMacro"
)
