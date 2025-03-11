//
//  W3WMapError.swift
//
//
//  Created by Khải Toàn Năng on 10/1/25.
//

import Foundation
import W3WSwiftCore

/// error response code block definition
public typealias W3WMapErrorResponse = (W3WMapError) -> ()


/// errors the map components might face
public enum W3WMapError : Error, CustomStringConvertible {
  case mapNotConfigured
  case badSquares
  case apiError(error: W3WError)
  
  public var description : String {
    switch self {
    case .mapNotConfigured:     return "Map isn't configured properly, is the API or SDK set?"
    case .badSquares:           return "Invalid three word address, or coordinates passed into map function"
    case .apiError(let error):  return String(describing: error)
    }
  }
}



