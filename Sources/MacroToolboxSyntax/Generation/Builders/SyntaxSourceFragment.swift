import SwiftParser
import SwiftSyntax

/// Explicit source-fragment escape hatch. The dedicated parser retains unconsumed tokens as
/// unexpected syntax, so validation rejects incomplete fragments and trailing extra syntax.
/// This checks grammar only; type, access, attribute, and conformance legality belong to Swift.
public enum SyntaxSourceFragment {
  public static func parse<Node: SyntaxParseable>(_ source: String, as type: Node.Type) throws -> Node {
    var parser = Parser(source)
    return try Node.parse(from: &parser).validated()
  }
}
