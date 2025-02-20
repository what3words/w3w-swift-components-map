//
//  SwiftTests.swift
//  w3w-swift-components-map
//
//  Created by Dave Duprey on 14/02/2025.
//

import Testing
import CoreLocation
import W3WSwiftCore
@testable import W3WSwiftComponentsMap

// COMMAND LINE TEST RUN WITH:
//
// xcodebuild -scheme w3w-swift-components-map test -destination "platform=iOS Simulator,name=iPhone 18,OS=latest"
//


@MainActor
class TestMapViewModel {

  var square: W3WSquare = W3WBaseSquare(words: "index.home.raft", country : W3WBaseCountry(code: "GB"), nearestPlace : "Bayswater, UK", distanceToFocus : W3WBaseDistance(kilometers: 1.0), language : W3WBaseLanguage(code:"en"), coordinates: CLLocationCoordinate2D(latitude: 51.50998, longitude: -0.1337))

  lazy var mapComponent = W3WMapComponent(w3w: MockApi(square: square), language: W3WBaseLanguage(locale: "en"))

  @Test("Adding and removing a marker")
  func addRemoveMarker() {
    mapComponent.addMarker(at: square.words)
    #expect(mapComponent.viewModel.mapState.markers.value.lists.first?.value.markers.first?.words == square.words)
    
    mapComponent.removeMarker(at: square.words)
    #expect(mapComponent.viewModel.mapState.markers.value.lists.first?.value.markers.first == nil)
  }
  

//  @Test("Set the map center")
//  func setCenter() async {
//    mapComponent.set(center: CLLocationCoordinate2D(latitude: 51.0, longitude: -0.1))
//
//    // try for 10 seconds
//    await withCheckedContinuation { continuation in
//      for i in 0 ... 10 {
//        print(self.mapComponent.mapView?.center)
//        sleep(3)
//      }
//      // give up
//      continuation.resume()
//    }
//  }
  
}
