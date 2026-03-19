//
//  W3WMapMarker.swift
//  w3w-swift-components-map
//
//  Created by Dave Duprey on 19/03/2026.
//

import W3WSwiftCore
import W3WSwiftThemes


public struct W3WMapMarker {
  
  /// the colour of the markers in this group
  public var color: W3WColor

  /// the type of marker
  public var type: W3WMarkerType

  /// the square for the marker
  public var square: W3WSquare
  

  /// Holds the information needed for a map annotation/marker
  public init(square: W3WSquare, color: W3WColor = W3WPresetMarkers.defaultMarkerColor, type: W3WMarkerType = W3WPresetMarkers.defaultMarkerType) {
    self.color = color
    self.type = type
    self.square = square
  }
  
}
