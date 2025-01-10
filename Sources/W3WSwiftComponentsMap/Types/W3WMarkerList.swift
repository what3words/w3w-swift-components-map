//
//  File.swift
//  
//
//  Created by Dave Duprey on 23/09/2024.
//

import W3WSwiftCore
import W3WSwiftThemes
import Foundation


public class W3WMarkerList: CustomStringConvertible {
  
  /// the colour of the markers in theis group
  public var color: W3WColor?
  
  /// the list of squares to mark
  public var markers: [W3WSquare]
  
  
  /// a named, coloured, group of markers
  public init(color: W3WColor? = nil, markers: [W3WSquare] = []) {
    self.color = color
    self.markers = markers
  }
  
  
  /// as a string
  public var description: String {
    var retval = ""
    
    if let c = color {
      retval += "(\(c.description)) "
    }
    
    for marker in markers {
      retval += "\(marker.description), "
    }
    
    return retval.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: CharacterSet(charactersIn: ","))
  }

  
}
