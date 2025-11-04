//
//  File.swift
//  
//
//  Created by Dave Duprey on 19/10/2024.
//

import UIKit
import CoreLocation
import W3WSwiftCore
import W3WSwiftThemes


public protocol W3WMapViewProtocol: UIView {
  
  var viewModel: W3WMapViewModelProtocol { get set }
  
  var types: [W3WMapType] { get }
  
  var transitionScale: W3WMapScale { get set }
  
  func set(viewModel: W3WMapViewModelProtocol)
  
  func set(type: String)
  
  func set(scheme: W3WScheme?)
  
  func getType() -> W3WMapType
  
  func getCameraState() -> W3WMapCamera
  
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
  
  
  @available(*, deprecated, message: "Now a function of W3WMapScale - gridLineThickness")
  func lineWidth(scale: W3WMapScale) -> W3WLineThickness {
    var v = 1.9623 * exp(-0.077 * (scale.value - 1.0))
    
    v = min(v, 2.0)
    v = max(v, 0.5)
    
    v = round(v * 2.0) / 2.0
    
    return W3WLineThickness(value: v)
  }
  

}
