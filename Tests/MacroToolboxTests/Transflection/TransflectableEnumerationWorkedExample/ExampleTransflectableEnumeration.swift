import SwiftSyntax
import MacroTransflection
@testable import MacroToolbox

enum ExampleTransflectableEnumeration: Hashable, CaseIterable {
  
  case transmogrify
  case frobulate
  case transmogrifyAndFrobulate
  
}

extension ExampleTransflectableEnumeration: TransflectableViaSourceCodeIdentifier {
  
  enum TransflectionError: Error {
    case unrecognizedEnumerationCase(String)
  }
  
  init(transflectingSourceCodeIdentifier sourceCodeIdentifier: String) throws {
    switch sourceCodeIdentifier {
    case ".transmogrify":
      self = .transmogrify
    case ".frobulate":
      self = .frobulate
    case ".transmogrifyAndFrobulate":
      self = .transmogrifyAndFrobulate
    default:
      throw TransflectionError.unrecognizedEnumerationCase(sourceCodeIdentifier)
    }
  }
  
}

extension ExampleTransflectableEnumeration: TransflectableViaExprSyntax { }
