//
//  W3WNavigation.swift
//  w3w-swift-components-map
//
//  Created by Dave Duprey on 24/02/2025.
//

import W3WSwiftCore
import W3WSwiftThemes
import MapKit


public class W3WDirections {
  
  var w3w: W3WProtocolV4
  
  var directions: MKDirections?
  
  var route = W3WLive<[MKRoute]>([])
  
  
  public init(w3w: W3WProtocolV4, from: String, to: String) {
    self.w3w = w3w
    start(from: from, to: to)
  }
  
  
  public func start(from: String, to: String) {
    let (start, end) = getSquares(start: from, end: to)
  
    if let startCoords = start?.coordinates, let endCoords = end?.coordinates {
      let request = MKDirections.Request()
      
      request.source = MKMapItem(placemark: MKPlacemark(coordinate: startCoords))
      request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endCoords))
      
      directions = MKDirections(request: request)
      
      directions?.calculate() { [weak self] directionsHandler, error in
        if let r = directionsHandler?.routes {
          self?.route.send(r)
        }
      }
    }
  }

    
  
  func getSquares(start: String, end: String) -> (W3WSquare?, W3WSquare?) {
    let task = DispatchGroup()
    var startSquare: W3WSquare?
    var endSquare: W3WSquare?
    
    task.enter()
    w3w.convertToCoordinates(words: start) { start, error in
      startSquare = start
      task.leave()
    }
    
    task.enter()
    w3w.convertToCoordinates(words: end) { end, error in
      endSquare = end
      task.leave()
    }

    task.wait()

    return (startSquare, endSquare)
  }
  
}
