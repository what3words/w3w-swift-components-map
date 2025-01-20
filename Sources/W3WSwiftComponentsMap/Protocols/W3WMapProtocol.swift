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
  
  /// the map state to act upon
  var state: W3WMapStateProtocol { get set }
  
  /// to resolve words into coords and vice versa
  var w3w: W3WProtocolV4 { get set }
  
  // returns the error enum for any error that occurs
  var onError: W3WErrorResponse { get set }

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
  
  func set(center: W3WSquare?)
  func set(center: W3WSuggestion?)
  func set(center: String?)
  func set(center: CLLocationCoordinate2D?, language: W3WLanguage)
  
  // zoom related setter functions
  func set(defaultZoom: W3WPointsPerSquare) // sets the size of a square after .zoom is used in a show() call
  func set(zoom: W3WMapScale) // sets the size of a square after .zoom is used in a show() call

  // zoom related getter functions
  func getZoom() -> W3WMapScale
  func getViewBoundaries() -> W3WBox
  func set(viewBoundaries: W3WBox)
}


public extension W3WMapProtocol {
  
  static var defautGroupName: String { get { return "default" } }
  
    
  func addMarker(at square: W3WSquare?, camera: W3WCameraMovement, color: W3WColor?, group: String?) {
  }
  
  func addMarker(at suggestion: W3WSuggestion?, camera: W3WCameraMovement, color: W3WColor?, group: String?) {
  }
  
  func addMarker(at words: String?, camera: W3WCameraMovement, color: W3WColor?, group: String?) {
  }
  
  func addMarker(at coordinates: CLLocationCoordinate2D?, camera: W3WCameraMovement, color: W3WColor?, group: String?) {
  }
  
  func addMarker(at squares: [W3WSquare]?, camera: W3WCameraMovement, color: W3WColor?, group: String?) {
  }
  
  func addMarker(at suggestions: [W3WSuggestion]?, camera: W3WCameraMovement, color: W3WColor?, group: String?) {
  }
  
  func addMarker(at words: [String]?, camera: W3WCameraMovement, color: W3WColor?, group: String?) {
  }
  
  func addMarker(at coordinates: [CLLocationCoordinate2D]?, camera: W3WCameraMovement, color: W3WColor?, group: String?) {
  }
  
  func removeMarker(at suggestion: W3WSuggestion?) {
  }
  
  func removeMarker(at words: String?) {
  }
  
  func removeMarker(at squares: [W3WSquare]?) {
  }
  
  func removeMarker(at suggestions: [W3WSuggestion]?) {
  }
  
  func removeMarker(at words: [String]?) {
  }
  
  func removeMarker(at square: W3WSquare?) {
  }
  
  func removeMarker(group: String) {
  }
  
  func select(at: W3WSquare) {
  }
  
  func unselect() {
  }
  
  func hover(at: CLLocationCoordinate2D) {
  }
  
  func unhover() {
  }
  
  func getAllMarkers() -> [W3WSquare] {
    return []
  }
  
  func removeAllMarkers() {
  }
  
  func findMarker(by coordinates: CLLocationCoordinate2D) -> W3WSquare? {
    return nil
  }
  
  func set(center: W3WSquare?) {
    //state.send(center: center?.coordinates)
  }
 
  func set(center: W3WSuggestion?) {
    if let words = center?.words {
      w3w.convertToCoordinates(words: words) { square, error in
        //self.state.send(center: square?.coordinates)
      }
    } else {
      //self.state.send(center: nil)
    }
  }
 
  func set(center: String?) {
    if let words = center {
      w3w.convertToCoordinates(words: words) { square, error in
        //self.state.send(center: square?.coordinates)
      }
    } else {
      //self.state.send(center: nil)
    }
  }
 
  func set(center: CLLocationCoordinate2D?, language: W3WLanguage) {
    if let coordinates = center {
      w3w.convertTo3wa(coordinates: coordinates, language: language) { square, error in
        //self.state.send(center: square?.coordinates)
      }
    } else {
      //self.state.send(center: nil)
    }
  }
 

  func set(defaultZoom: W3WPointsPerSquare) {
  }
  
  func set(zoom: W3WMapScale) {
  }
  
  func getZoom() -> W3WMapScale {
    return 0.0
  }
  
  func getViewBoundaries() -> W3WBox {
    return W3WBaseBox(southWest: CLLocationCoordinate2D(), northEast: CLLocationCoordinate2D())
  }
  
  func set(viewBoundaries: W3WBox) {
  }
  

}
