
public enum LabelCriterion {
  
  case unspecified
  case mustBeNil
  case exactly(String)
  
}

extension LabelCriterion: Sendable { }
extension LabelCriterion: Equatable { }
extension LabelCriterion: Hashable { }
extension LabelCriterion: Codable { }

extension LabelCriterion: CustomStringConvertible {
  
  public var description: String {
    switch self {
    case .unspecified:
      ".unspecified"
    case .mustBeNil:
      ".mustBeNil"
    case .exactly(let label):
      ".exactly(\"\(label)\")"
    }
  }
  
}

extension LabelCriterion: CustomDebugStringConvertible {
  
  public var debugDescription: String {
    switch self {
    case .unspecified:
      "LabelCriterion.unspecified"
    case .mustBeNil:
      "LabelCriterion.mustBeNil"
    case .exactly(let label):
      "LabelCriterion.exactly(\"\(label)\")"
    }
  }
  
}
