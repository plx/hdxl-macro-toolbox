import MacroTransflection

public enum SynthesizableProtocol : UInt64 {
  case sendable         = 0b00000001
  case equatable        = 0b00000010
  case hashable         = 0b00000100
  case caseIterable     = 0b00001000
  case encodable        = 0b00010000
  case decodable        = 0b00100000
  case autoIdentifiable = 0b01000000
}

extension SynthesizableProtocol: Sendable { }
extension SynthesizableProtocol: Equatable { }
extension SynthesizableProtocol: Hashable { }
extension SynthesizableProtocol: CaseIterable { }
extension SynthesizableProtocol: Encodable { }
extension SynthesizableProtocol: Decodable { }

extension SynthesizableProtocol: CustomStringConvertible { }
extension SynthesizableProtocol: CustomDebugStringConvertible { }

extension SynthesizableProtocol: MacroToolboxCaseNameAwareEnumeration {
  
  @inlinable
  public var caseNameWithoutLeadingDot: String {
    switch self {
    case .sendable: "sendable"
    case .equatable: "equatable"
    case .hashable: "hashable"
    case .caseIterable: "caseIterable"
    case .encodable: "encodable"
    case .decodable: "decodable"
    case .autoIdentifiable: "autoIdentifiable"
    }
  }
  
}

extension SynthesizableProtocol: TransflectableViaExprSyntax { }
extension SynthesizableProtocol: TransflectableViaSourceCodeIdentifierTable {

  // manual implementation so we can cache this table
  public static let sourceCodeIdentifierTransflectionTable: [String: Self] = _inferred
  
}

extension SynthesizableProtocol {
  
  @inlinable
  public var associatedProtocolName: String {
    switch self {
    case .sendable: "Sendable"
    case .equatable: "Equatable"
    case .hashable: "Hashable"
    case .caseIterable: "CaseIterable"
    case .encodable: "Encodable"
    case .decodable: "Decodable"
    case .autoIdentifiable: "AutoIdentifiable"
    }
  }
  
}
