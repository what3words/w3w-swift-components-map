//
//  W3WAppStateFunctionsProtocol.swift
//
//
//  Created by Dave Duprey on 21/10/2024.
//

import CoreLocation
import W3WSwiftCore
import W3WSwiftThemes


public protocol W3WMapStateFunctionsProtocol: W3WMapProtocol {
  
  var mapState: W3WMapState { get }
  
}


public extension W3WMapStateFunctionsProtocol {
  
  func set(state: any W3WMapStateProtocol) {
    self.mapState.loadValues(state: state)
  }
  
  
  func addMarker(at square: (any W3WSquare)?, camera: W3WCameraMovement, color: W3WColor?, group: String? = nil) {
    mapState.markers.value
    //let groupName = group ?? Self.defautGroupName
    //
    //if let s = square {
    //  if let markerGroup = mapState.markers.value.first(where: { m in m.name == groupName }) {
    //    markerGroup.markers.append(s)
    //  } else {
    //    mapState.markers.value.append(W3WMarkerGroup(name: groupName, markers: [s]))
    //  }
    //}
  }

  
  func addMarker(at suggestion: (any W3WSuggestion)?, camera: W3WCameraMovement, color: W3WColor?, group: String?) {
  }
  
  
  func addMarker(at words: String?, camera: W3WCameraMovement, color: W3WColor?, group: String?) {
  }
  
  
  func addMarker(at coordinates: CLLocationCoordinate2D?, camera: W3WCameraMovement, color: W3WColor?, group: String?) {
  }
  
  
  func addMarker(at squares: [any W3WSquare]?, camera: W3WCameraMovement, color: W3WColor?, group: String?) {
  }
  
  
  func addMarker(at suggestions: [any W3WSuggestion]?, camera: W3WCameraMovement, color: W3WColor?, group: String?) {
  }
  
  
  func addMarker(at words: [String]?, camera: W3WCameraMovement, color: W3WColor?, group: String?) {
  }
  
  
  func addMarker(at coordinates: [CLLocationCoordinate2D]?, camera: W3WCameraMovement, color: W3WColor?, group: String?) {
  }
  
  
  func removeMarker(at suggestion: (any W3WSuggestion)?) {
  }
  
  
  func removeMarker(at words: String?) {
  }
  
  
  func removeMarker(at squares: [any W3WSquare]?) {
  }
  
  
  func removeMarker(at suggestions: [any W3WSuggestion]?) {
  }
  
  
  func removeMarker(at words: [String]?) {
  }
  
  
  func removeMarker(at square: (any W3WSquare)?) {
  }
  
  
  func removeMarker(group: String) {
  }
  
  
  func select(at: any W3WSquare) {
  }
  
  
  func unselect() {
  }
  
  
  func hover(at: CLLocationCoordinate2D) {
  }
  
  
  func unhover() {
  }
  
  
  func getAllMarkers() -> [any W3WSquare] {
    return []
  }
  
  
  func removeAllMarkers() {
  }
  
  
  func findMarker(by coordinates: CLLocationCoordinate2D) -> (any W3WSquare)? {
    return nil
  }
  
  
  func set(defaultZoom: W3WPointsPerSquare) {
  }
  
  
  func set(zoom: W3WPointsPerMeter) {
  }
  
  
  func getZoom() -> W3WPointsPerMeter {
    return 8.0
  }
  
  
  func getViewBoundaries() -> any W3WBox {
    return W3WBaseBox(southWest: .init(latitude: 0.0, longitude: 0.0), northEast: .init(latitude: 0.1, longitude: 0.1))
  }
  
  
  func set(viewBoundaries: any W3WBox) {
  }

  
}
