//
//  File.swift
//  
//
//  Created by Dave Duprey on 19/10/2024.
//

import UIKit
import CoreLocation


public protocol W3WMapViewProtocol: UIView {
  
  var viewModel: W3WMapViewModelProtocol { get set }
  
  var types: [W3WMapType] { get }
  
  func set(viewModel: W3WMapViewModelProtocol)
  
  func set(type: String)
  
  func getType() -> W3WMapType
  
  func pointFor(coordinate: CLLocationCoordinate2D) -> CGPoint
  
  func coordinateFor(point: CGPoint) -> CLLocationCoordinate2D
}


extension W3WMapViewProtocol {
  
  public func set(type: W3WMapType) {
    set(type: type.value)
  }
  
  
  @available(*, deprecated, message: "REMOVE THIS, ITS JUST FOR DEBUGGING UNTIL APP MAPS CONFORM TO IT")
  public func getType() -> W3WMapType {
    return "unknown"
  }
  
  
  @available(*, deprecated, message: "REMOVE THIS, ITS JUST FOR DEBUGGING UNTIL APP MAPS CONFORM TO IT")
  public func pointFor(coordinate: CLLocationCoordinate2D) -> CGPoint {
    return CGPoint(x: 200.0, y: 400.0)
  }
  
  
  @available(*, deprecated, message: "REMOVE THIS, ITS JUST FOR DEBUGGING UNTIL APP MAPS CONFORM TO IT")
  public func coordinateFor(point: CGPoint) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: 51.0, longitude: -0.1)
  }

}
