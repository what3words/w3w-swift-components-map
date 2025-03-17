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
  var color: W3WColor?
  
  /// the list of squares to mark
  var markers: [W3WSquare]
  
  
  /// a named, coloured, group of markers
  public init(color: W3WColor? = nil, markers: [W3WSquare] = []) {
    self.color = color
    self.markers = markers
  }
  
  
  public func getMarkers() -> [W3WSquare] {
    return markers
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
  
  /// Returns an array of all W3WSquare markers in the marker list.
  ///
  /// Since the markers property is internal to the W3WMarkerList class package,
  /// this method provides public access to the markers collection.
  ///
  /// - Returns: An array of W3WSquare objects representing all markers in the list.
  ///           Returns an empty array if no markers are present.
  ///
  /// - Example:
  ///   ```swift
  ///   let markerList = W3WMarkerList()
  ///   let squares = markerList.getMarkers()
  ///
  ///   for square in squares {
  ///       // Work with each W3WSquare marker
  ///       mapHelper.addMarker(at: square)
  ///   }
  ///   ```
  
  public func getmarkers() -> [W3WSquare] {
    return markers
  }

  
}
