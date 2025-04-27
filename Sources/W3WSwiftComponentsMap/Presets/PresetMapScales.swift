//
//  File.swift
//  
//
//  Created by Dave Duprey on 08/01/2025.
//

import W3WSwiftCore

public extension W3WMapScale {
  
  /// the default scale to zoom to if none is provided for certain calls
  static var standardZoom = W3WMapScale(pointsPerMeter: 4.0)

  /// the maximum allowed grid size
  static var maxGridSize: W3WDistance = W3WBaseDistance(meters: 4000.0)
  
}
