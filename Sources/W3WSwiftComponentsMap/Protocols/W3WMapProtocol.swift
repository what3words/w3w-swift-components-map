//
//  Created by Dave Duprey on 01/03/2022.
//

import Foundation
import CoreLocation
import UIKit
import W3WSwiftCore
import W3WSwiftThemes


/// Interface for map functions
public protocol W3WMapProtocol {
  
  //var state: W3WMapStateProtocol { get set }
  
  // set the actual map view to use
  //func set(mapView: W3WMapStateProtocol)
  
  // set the language to use for three word addresses when they need to be looked up
  //func set(language: W3WLanguage)
  
  func set(state: W3WMapStateProtocol)
  
  // put a what3words annotation on the map showing the address
  func addMarker(at square: W3WSquare?, camera: W3WCameraMovement, color: W3WColor?, group: String?)
  func addMarker(at suggestion: W3WSuggestion?, camera: W3WCameraMovement, color: W3WColor?, group: String?)
  func addMarker(at words: String?, camera: W3WCameraMovement, color: W3WColor?, group: String?)
  func addMarker(at coordinates: CLLocationCoordinate2D?, camera: W3WCameraMovement, color: W3WColor?, group: String?)
  func addMarker(at squares: [W3WSquare]?, camera: W3WCameraMovement, color: W3WColor?, group: String?)
  func addMarker(at suggestions: [W3WSuggestion]?, camera: W3WCameraMovement, color: W3WColor?, group: String?)
  func addMarker(at words: [String]?, camera: W3WCameraMovement, color: W3WColor?, group: String?)
  func addMarker(at coordinates: [CLLocationCoordinate2D]?, camera: W3WCameraMovement, color: W3WColor?, group: String?)
  
  // remove what3words annotations from the map if they are present
  func removeMarker(at suggestion: W3WSuggestion?)
  func removeMarker(at words: String?)
  func removeMarker(at squares: [W3WSquare]?)
  func removeMarker(at suggestions: [W3WSuggestion]?)
  func removeMarker(at words: [String]?)
  func removeMarker(at square: W3WSquare?)
  func removeMarker(group: String)

  // show the "selected" outline around a square
  func select(at: W3WSquare)

  // remove the selection from the selected square
  func unselect()
  
  // show the "hover" outline around a square
  func hover(at: CLLocationCoordinate2D)
  
  // hide the "hover" outline around a square
  func unhover()
  
  // get the list of added squares
  func getAllMarkers() -> [W3WSquare]
  
  // remove what3words annotations from the map if they are present
  func removeAllMarkers()
  
  // find a marker by it's coordinates and return it if it exists in the map
  func findMarker(by coordinates: CLLocationCoordinate2D) -> W3WSquare?
  
  // zoom related setter functions
  func set(defaultZoom: W3WPointsPerSquare) // sets the size of a square after .zoom is used in a show() call
  func set(zoom: W3WPointsPerMeter) // sets the size of a square after .zoom is used in a show() call

  // zoom related getter functions
  func getZoom() -> W3WPointsPerMeter
  func getViewBoundaries() -> W3WBox
  func set(viewBoundaries: W3WBox)

  // returns the error enum for any error that occurs
  var onError: W3WErrorResponse { get set }
}


public extension W3WMapProtocol {
  
  static var defautGroupName: String { get { return "default" } }
  
}
