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
  func addMarker(at coordinates: CLLocationCoordinate2D?, language: W3WLanguage, camera: W3WCameraMovement, color: W3WColor?, group: String?)
  func addMarker(at squares: [W3WSquare]?, camera: W3WCameraMovement, color: W3WColor?, group: String?)
  func addMarker(at suggestions: [W3WSuggestion]?, camera: W3WCameraMovement, color: W3WColor?, group: String?)
  func addMarker(at words: [String]?, camera: W3WCameraMovement, color: W3WColor?, group: String?)
  func addMarker(at coordinates: [CLLocationCoordinate2D]?, language: W3WLanguage, camera: W3WCameraMovement, color: W3WColor?, group: String?)
  
  // remove what3words annotations from the map if they are present
  func removeMarker(at suggestion: W3WSuggestion?, group: String?)
  func removeMarker(at words: String?, group: String?)
  func removeMarker(at squares: [W3WSquare]?, group: String?)
  func removeMarker(at suggestions: [W3WSuggestion]?, group: String?)
  func removeMarker(at words: [String]?, group: String?)
  func removeMarker(at square: W3WSquare?, group: String?)
  func removeMarker(group: String)

  // show the "selected" outline around a square
  func select(at: W3WSquare)

  // remove the selection from the selected square
  func unselect()
  
  // show the "hover" outline around a square
  func hover(at: W3WSquare?)
  
  // hide the "hover" outline around a square
  func unhover()
  
  // get the list of added squares
  func getAllMarkers() -> W3WMarkersLists
  
  // remove what3words annotations from the map if they are present
  func removeAllMarkers()
  
  // find a marker by it's coordinates and return it if it exists in the map
  //func findMarker(by coordinates: CLLocationCoordinate2D) -> W3WSquare?
  
  func set(center: W3WSquare?)
  func set(center: W3WSuggestion?)
  func set(center: String?)
  func set(center: CLLocationCoordinate2D?)
  
  // zoom related setter functions, sets the size of a square after .zoom is used in a show() call
  func set(zoom: W3WMapScale)
  func set(pointsPerMeter: Double)
  func set(googleZoom: Float)

  // zoom related getter functions
  //func getZoom() -> W3WMapScale
  //func getViewBoundaries() -> W3WBox
  //func set(viewBoundaries: W3WBox)
}


public extension W3WMapProtocol {
  
  static var defautGroupName: String { get { return "default" } }
  
    
  func addMarker(at square: W3WSquare?, camera: W3WCameraMovement = .none, color: W3WColor? = nil, group: String? = nil) {
    if let square = square {
      if let listName = group, state.markers.value.lists[listName] == nil {
        state.markers.value.add(listName: listName, list: W3WMarkerList(color: color))
      }
      state.markers.value.add(square: square, listName: group)
      state.markers.send(state.markers.value)
    }
  }
  
  
  func addMarker(at words: String?, camera: W3WCameraMovement = .none, color: W3WColor? = nil, group: String? = nil) {
    if let words = words {
      w3w.convertToCoordinates(words: words) { square, error in
        addMarker(at: square, camera: camera, color: color, group: group)
      }
    }
  }


  func addMarker(at coordinates: CLLocationCoordinate2D?, language: W3WLanguage, camera: W3WCameraMovement = .none, color: W3WColor? = nil, group: String? = nil) {
    if let coordinates = coordinates {
      w3w.convertTo3wa(coordinates: coordinates, language: language) { square, error in
        addMarker(at: square, camera: camera, color: color, group: group)
      }
    }
  }
  

  func addMarker(at suggestion: W3WSuggestion?, camera: W3WCameraMovement = .none, color: W3WColor? = nil, group: String? = nil) {
    addMarker(at: suggestion?.words, camera: camera, color: color, group: group)
  }
  

  func addMarker(at squares: [W3WSquare]?, camera: W3WCameraMovement = .none, color: W3WColor? = nil, group: String? = nil) {
    for square in squares ?? [] {
      addMarker(at: square, camera: camera, color: color, group: group)
    }
  }
  
  
  func addMarker(at suggestions: [W3WSuggestion]?, camera: W3WCameraMovement = .none, color: W3WColor? = nil, group: String? = nil) {
    for suggestion in suggestions ?? [] {
      addMarker(at: suggestion, camera: camera, color: color, group: group)
    }
  }
  
  
  func addMarker(at words: [String]?, camera: W3WCameraMovement = .none, color: W3WColor? = nil, group: String? = nil) {
    for address in words ?? [] {
      addMarker(at: address, camera: camera, color: color, group: group)
    }
  }

  
  func addMarker(at coordinates: [CLLocationCoordinate2D]?, language: W3WLanguage, camera: W3WCameraMovement = .none, color: W3WColor? = nil, group: String? = nil) {
    for coordinate in coordinates ?? [] {
      addMarker(at: coordinate, language: language, camera: camera, color: color, group: group)
    }
  }
  
  
  func removeMarker(at words: String?, group: String? = nil) {
    if let words = words {
      state.markers.value.remove(words: words, listName: group)
      state.markers.send(state.markers.value)
    }
  }
  
  
  func removeMarker(at suggestion: W3WSuggestion?, group: String? = nil) {
    removeMarker(at: suggestion?.words, group: group)
  }
  
  
  func removeMarker(at square: W3WSquare?, group: String? = nil) {
    removeMarker(at: square, group: group)
  }
  
  
  func removeMarker(at squares: [W3WSquare]?, group: String? = nil) {
    for square in squares ?? [] {
      removeMarker(at: square, group: group)
    }
  }
  
  
  func removeMarker(at suggestions: [W3WSuggestion]?, group: String? = nil) {
    for suggestion in suggestions ?? [] {
      removeMarker(at: suggestion, group: group)
    }
  }
  
  
  func removeMarker(at words: [String]?, group: String? = nil) {
    for address in words ?? [] {
      removeMarker(at: address, group: group)
    }
  }
  
  
  func removeMarker(group: String) {
    state.markers.value.remove(listName: group)
    state.markers.send(state.markers.value)
  }
  
  
  func select(at: W3WSquare) {
    state.selected.send(at)
  }
  

  func unselect() {
    state.selected.send(nil)
  }
  

  func hover(at: W3WSquare?) {
    state.hovered.send(at)
  }
  

  func unhover() {
    hover(at: nil)
  }
  
  
  func getAllMarkers() -> W3WMarkersLists {
    return state.markers.value
  }
  
  
  func removeAllMarkers() {
    for list in state.markers.value.lists {
      state.markers.value.remove(listName: list.key)
    }

    state.markers.send(state.markers.value)
  }
  
  
  func set(center: W3WSquare?) {
    set(center: center?.coordinates)
  }
 
  
  func set(center: W3WSuggestion?) {
    if let words = center?.words {
      w3w.convertToCoordinates(words: words) { square, error in
        set(center: square)
      }
    }
  }
 
  
  func set(center: String?) {
    if let words = center {
      w3w.convertToCoordinates(words: words) { square, error in
        set(center: square)
      }
    }
  }
 

  func set(center: CLLocationCoordinate2D?) {
    state.camera.send(W3WMapCamera(center: center))
  }
 

  func set(defaultZoom: W3WPointsPerSquare) {
  }
  

  func set(zoom: W3WMapScale) {
    state.camera.send(W3WMapCamera(scale: zoom))
  }
  
  
  func set(pointsPerMeter: Double) {
    set(zoom: W3WMapScale(pointsPerMeter: pointsPerMeter))
  }
  
  
  func set(googleZoom: Float) {
    set(zoom: W3WMapScale(googleZoom: googleZoom))
  }

  
//  func getZoom() -> W3WMapScale {
//    return 0.0
//  }
//  
//  func getViewBoundaries() -> W3WBox {
//    return W3WBaseBox(southWest: CLLocationCoordinate2D(), northEast: CLLocationCoordinate2D())
//  }
//  
//  func set(viewBoundaries: W3WBox) {
//  }
//
//  func findMarker(by coordinates: CLLocationCoordinate2D) -> W3WSquare? {
//    return nil
//  }
    
    

}
