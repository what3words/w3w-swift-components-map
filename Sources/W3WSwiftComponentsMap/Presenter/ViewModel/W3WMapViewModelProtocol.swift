//
//  File.swift
//  
//
//  Created by Dave Duprey on 13/10/2024.
//

import W3WSwiftCore
import CoreLocation

public protocol W3WMapViewModelProtocol {
  
  var w3w: W3WProtocolV4 { get set }
  
  var gps: W3WLive<W3WSquare?> { get set }

  var input: W3WMapStateProtocol { get set }

  var output: W3WEvent<W3WMapOutputEvent> { get set }

  func selectSquare(with coordinates: CLLocationCoordinate2D)
  
  func updateCameraPosition(with camera: W3WMapCamera)
}
