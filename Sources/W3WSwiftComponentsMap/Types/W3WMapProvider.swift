//
//  W3WMapProvider.swift
//  w3w-swift-components-map
//
//  Created by Dave Duprey on 17/04/2026.
//

import Foundation

public struct W3WMapProvider: Equatable, ExpressibleByStringLiteral, CustomStringConvertible {
  public typealias StringLiteralType = String
  
  public let value: String
  var displayName: String
  
  public var description: String { get { return displayName } }
  

  public init(stringLiteral value: String) {
    self.value = value
    self.displayName = value

    self.displayName = typeToName(type: value)
  }

  
  public init(value: String, displayName: String? = nil) {
    self.value = value
    self.displayName = value

    self.displayName = displayName == nil ? value : self.typeToName(type: value)
  }
  
  
  func typeToName(type: String) -> String {
    return type.replacingOccurrences(
      of: "(\\p{UppercaseLetter}\\p{LowercaseLetter}|\\p{UppercaseLetter}+(?=\\p{UppercaseLetter}))",
      with: " $1",
      options: .regularExpression
    )
    .capitalized
  }

  
  // NOTE:
  //  Use pascalCase CamelCase for the entries here.  This allows typeToName(type:)
  //  to convert to a displayable value.
  
  public static let google: W3WMapProvider = "google"
  public static let apple:  W3WMapProvider = "apple"

}

