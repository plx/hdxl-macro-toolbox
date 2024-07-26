import SwiftDiagnostics

/// Types conforming to ``MacroDiagnosticDomain`` gain access to a streamlined API for reporting macro diagnostics.
///
/// For context on this, `SwiftSyntax` includes a concept of "diagnostics", which are used to report everything from
/// "hard failures" all the way down to "hey, just so you know, you might want to do X, instead of Y like you're doing here."
///
/// All macro diagnostics (indirectly) require providing a `MessageID`, which has two pieces:
///
/// - a "domain", which is an arbitrary string identifier identifying the subsystem, component, or topic (etc.)
/// - an "id", which is an arbitary string identifier identifying the specific type of diagnostic being provided
///
/// ...which is roughly analogous to `NSError`'s domain-and-code system.
///
/// Given this context, the point of ``MacroDiagnosticDomain`` is straightforward: we make our "macro-involved"
/// types aware of their own "domains", at which point we only need to supply an `id` in order to create fully-formed
/// `MesageID` even within *generic contexts*.
///
/// - note:
///
/// An alternative I'd explored used an associated "message-identifier" type rather than just the "domain", and looked like this:
///
/// ```swift
/// protocol DiagnosticDomainAware {
///   static var diagnosticDomainIdentifier: String { get }
/// }
///
/// protocol MessageIdentifierProtocol: RawRepresentable, DiagnosticDomainAware where RawValue == String {
///
/// }
///
/// extension MessageID {
///   init<Identifier>(_ identifier: Identifier) where Identifier: MessageIdentifierProtocol {
///     domain: Identifier.diagnosticDomainIdentifier,
///     messageID: identifer.rawValue
///   }
/// }
///
/// protocol MacroDiagnosticDomain: DiagnosticDomainAware {
///   associatedtype MessageIdentifier: MessageIdentifierProtocol
/// }
///
/// extension MacroDiagnosticDomain {
///   static var diagnosticDomainIdentifier: String { MessageIdentifier.diagnosticDomainIdentifier }
///
///   static func messageID(id identifier: MessageIdentifier) -> MessageID {
///     MessageID(identifier)
///   }
/// }
/// ```
///
/// In theory, this has some advantages b/c (a) the `id` in a `MessageID` is supposed to be drawn from a small/finite set of choices
/// and (b) the design above would *enforce* the rule that "such-and-such domain only ever uses valid/official message identifiers."
///
/// In practice, though, it turned out that there's a lot of scenarios wherein you want a more nuanced relationship between domains
/// and message-ids:
///
/// - *some* message-ids only make sense for some very specific domain
/// - *other* message-ids have wider applicability and make sense to (re-)use across multiple domains
///
/// ...and so, tl;dr, it felt like it'd be a mistake to try and use the type system to enforce a relationship that didn't even necesarily exist.
///
/// Having said all this, *if* you're looking to restrict a domain to particular messages, my suggestion would be like this:
///
/// ```swift
/// enum FooBarMessageIdentifier: String {
///   case fooBarredTooFar
///   case barredFooByMistake
///   case unexpectedQuuxBeforeBaz
/// }
///
/// protocol FooBarMacroProtocol {
///   static func fooBarMessage(_ identifier: FooBarMessageIdentifier) -> MessageID
/// }
///
/// extension FooBarMacroProtocol {
///   static func fooBarMessage(_ identifier: FooBarMessageIdentifier) -> MessageID {
///     messageID(id: identifier.rawValue)
///   }
/// }
/// ```
///
/// ...which will give you a way to:
///
/// - define restricted sets of message-ids
/// - control which types can produce those message ids
///
public protocol MacroDiagnosticDomain {
  
  /// The arbitrary sring identifier servicing as this domain.
  ///
  /// - note: The default implementation returns the name of the type.
  static var diagnosticDomainIdentifier: String { get }
  
}

extension MacroDiagnosticDomain {
  
  @inlinable
  public static var diagnosticDomainIdentifier: String { String(reflecting: self) }

  /// Creates a `MessageID` with the supplied `id` and in our own `diagnosticDomainIdentifier`.
  ///
  /// - note:
  ///
  /// We deliberately *do not* create an analogous method taking, say, a `RawRepresentable<String>` parameter,
  /// b/c doing so would hamper the ability to use a design pattern mentioned in the documentation for the protocol.
  ///
  /// - seealso: ``MacroDiagnosticDomain.diagnosticDomainIdentifier``.
  @inlinable
  public static func messageID(id identifier: String) -> MessageID {
    MessageID(
      domain: diagnosticDomainIdentifier,
      id: identifier
    )
  }
  
}
