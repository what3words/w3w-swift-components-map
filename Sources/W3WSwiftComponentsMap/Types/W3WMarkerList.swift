//
//  File.swift
//  
//
//  Created by Dave Duprey on 23/09/2024.
//

import W3WSwiftCore
import W3WSwiftThemes


public class W3WMarkerGroup {
  
  /// name of the group
  var name: String
  
  /// the colour of the markers in theis group
  var color: W3WColor?
  
  /// the list of squares to mark
  var markers: [W3WSquare]
  
  
  /// a named, coloured, group of markers
  init(name: String, color: W3WColor? = nil, markers: [W3WSquare]) {
    self.name = name
    self.color = color
    self.markers = markers
  }
  
}
