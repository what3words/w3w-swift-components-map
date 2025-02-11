//
//  File.swift
//  
//
//  Created by Dave Duprey on 21/10/2024.
//

import Foundation

public struct W3WMapType: Equatable, ExpressibleByStringLiteral, CustomStringConvertible {
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

  
  public static let standard:  W3WMapType = "standard"
  public static let satellite: W3WMapType = "satellite"
  public static let hybrid:    W3WMapType = "hybrid"


}

