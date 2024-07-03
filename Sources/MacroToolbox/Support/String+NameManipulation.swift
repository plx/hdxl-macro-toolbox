
extension String {
  
  package init(lowercasingFirstCharacterOf source: String) {
    switch source.isEmpty {
    case true:
      self = ""
    case false:
      let splitIndex = source.index(after: source.startIndex)
      self = "\(source.prefix(upTo: splitIndex).lowercased())\(source.suffix(from: splitIndex))"
    }
  }

  package init(lowercasingFirstCharacterOf source: Substring) {
    switch source.isEmpty {
    case true:
      self = ""
    case false:
      let splitIndex = source.index(after: source.startIndex)
      self = "\(source.prefix(upTo: splitIndex).lowercased())\(source.suffix(from: splitIndex))"
    }
  }

}
