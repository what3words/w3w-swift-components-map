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
    #expect(mapComponent.viewModel.input.markers.value.lists.first?.value.markers.first?.words == square.words)
    
    mapComponent.removeMarker(at: square.words)
    #expect(mapComponent.viewModel.input.markers.value.lists.first?.value.markers.first == nil)
  }

  
  @Test("Test findalloccurances of")
  func listsMath() {
    let markerLists = W3WMarkersLists()
    
    let list1 = W3WMarkerList(color: .red, type: .square, markers: [square0, square1, square2, square3])
    let list2 = W3WMarkerList(color: .orange, type: .square, markers: [square4, square5, square6, square7])
    let list3 = W3WMarkerList(color: .yellow, type: .square, markers: [square2, square4])
    
    markerLists.add(listName: "one", list: list1)
    markerLists.add(listName: "two", list: list2)
    markerLists.add(listName: "three", list: list3)
    
    let square2Lists = markerLists.findAllOccurancesOf(square: square2)
    #expect(square2Lists?.lists.first!.1.markers.first?.words == square2.words)
  }

  
//  @Test("Test extra squares")
//  func listsMath2() {
//    let markerLists1 = W3WMarkersLists()
//    let markerLists2 = W3WMarkersLists()
//
//    let list1 = W3WMarkerList(color: .red, type: .square, markers: [square0, square1, square2, square3])
//    let list3 = W3WMarkerList(color: .yellow, type: .square, markers: [square2, square4])
//    markerLists1.add(listName: "one", list: list1)
//    markerLists2.add(listName: "three", list: list3)
//
//    let utitlity = W3WListUtility(oldList: markerLists1, newList: markerLists2)
//    let missingInList2 = utitlity.missingMarkers()
//
//    print(missingInList2)
//    
//    #expect(missingInList2.lists.first!.1.markers.first?.words == square2.words)
//  }

  
  @Test("Test extra squares")
  func testMarkerListFindMissing() {
    // Scenario 1: Some overlap, expect only items in self not in 'from'
    let listA = W3WMarkerList(color: .red, type: .square, markers: [square0, square1, square2, square3])
    let listB = W3WMarkerList(color: .yellow, type: .square, markers: [square2, square4])

    let missingFromB = listA.findMissing(from: listB)
    let missingWords = Set(missingFromB.map { $0.words })
    // Expect square0, square1, square3 are missing from B; square2 is present in B and should not be returned
    #expect(missingWords.contains(square0.words))
    #expect(missingWords.contains(square1.words))
    #expect(missingWords.contains(square3.words))
    #expect(missingWords.contains(square2.words) == false)
    #expect(missingWords.contains(square4.words) == false)

    // Scenario 2: No overlap, expect all from self
    let listC = W3WMarkerList(color: .orange, type: .square, markers: [square5, square6, square7])
    let missingFromC = listA.findMissing(from: listC)
    let missingFromCWords = Set(missingFromC.map { $0.words })
    #expect(missingFromCWords == Set([square0.words, square1.words, square2.words, square3.words]))

    // Scenario 3: Identical lists, expect empty
    let listD = W3WMarkerList(color: .red, type: .square, markers: [square0, square1, square2, square3])
    let missingFromD = listA.findMissing(from: listD)
    #expect(missingFromD.isEmpty)
  }
  

  @Test("Test extra squares in lists lists")
  func testMarkersListsFindMissing() {
    // Build a markers container with multiple lists
    let markersLists = W3WMarkersLists()

    let list1 = W3WMarkerList(color: .red, type: .square, markers: [square0, square1, square2, square3])
    let list2 = W3WMarkerList(color: .orange, type: .square, markers: [square4, square5])
    let list3 = W3WMarkerList(color: .yellow, type: .square, markers: [square2, square4])

    markersLists.add(listName: "one", list: list1)
    markersLists.add(listName: "two", list: list2)
    markersLists.add(listName: "three", list: list3)

    // Build a 'from' markers-lists containing a single list with square2 and square4
    let fromMarkersLists = W3WMarkersLists()
    fromMarkersLists.add(listName: "from", list: W3WMarkerList(color: .yellow, type: .square, markers: [square2, square4]))
    let missing = markersLists.findMissing(from: fromMarkersLists)

    let missingWords = Set(missing.map { $0.words })
    // Expect squares 0,1,3,5 to be missing; 2 and 4 should not be returned
    #expect(missingWords.contains(square0.words))
    #expect(missingWords.contains(square1.words))
    #expect(missingWords.contains(square3.words))
    #expect(missingWords.contains(square5.words))
    #expect(missingWords.contains(square2.words) == false)
    #expect(missingWords.contains(square4.words) == false)

    // Add a from-lists that contains all squares; expect empty
    let fromAllLists = W3WMarkersLists()
    fromAllLists.add(listName: "all", list: W3WMarkerList(color: .purple, type: .square, markers: [square0, square1, square2, square3, square4, square5]))
    let missingNone = markersLists.findMissing(from: fromAllLists)
    #expect(missingNone.isEmpty)
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
  

  // MARK: - Fake Test Squares
  
  let square0 = W3WBaseSquare(
    words: "index.home.raft",
    country: W3WBaseCountry(code: "GB"),
    nearestPlace: "London, UK",
    distanceToFocus: W3WBaseDistance(kilometers: 0.2),
    language: W3WBaseLanguage(code: "en"),
    coordinates: CLLocationCoordinate2D(latitude: 51.50998, longitude: -0.13370),
    bounds: W3WBaseBox(
      southWest: CLLocationCoordinate2D(latitude: 51.50898, longitude: -0.13520),
      northEast: CLLocationCoordinate2D(latitude: 51.51098, longitude: -0.13220)
    )
  )

  let square1 = W3WBaseSquare(
    words: "filled.count.soap",
    country: W3WBaseCountry(code: "US"),
    nearestPlace: "San Francisco, USA",
    distanceToFocus: W3WBaseDistance(kilometers: 0.5),
    language: W3WBaseLanguage(code: "en"),
    coordinates: CLLocationCoordinate2D(latitude: 37.77490, longitude: -122.41940),
    bounds: W3WBaseBox(
      southWest: CLLocationCoordinate2D(latitude: 37.77370, longitude: -122.42070),
      northEast: CLLocationCoordinate2D(latitude: 37.77610, longitude: -122.41810)
    )
  )

  let square2 = W3WBaseSquare(
    words: "piano.mirror.coffee",
    country: W3WBaseCountry(code: "JP"),
    nearestPlace: "Shinjuku, Tokyo",
    distanceToFocus: W3WBaseDistance(kilometers: 0.3),
    language: W3WBaseLanguage(code: "ja"),
    coordinates: CLLocationCoordinate2D(latitude: 35.68950, longitude: 139.69171),
    bounds: W3WBaseBox(
      southWest: CLLocationCoordinate2D(latitude: 35.68850, longitude: 139.69041),
      northEast: CLLocationCoordinate2D(latitude: 35.69050, longitude: 139.69301)
    )
  )

  let square3 = W3WBaseSquare(
    words: "river.table.window",
    country: W3WBaseCountry(code: "AU"),
    nearestPlace: "Sydney, Australia",
    distanceToFocus: W3WBaseDistance(kilometers: 0.7),
    language: W3WBaseLanguage(code: "en"),
    coordinates: CLLocationCoordinate2D(latitude: -33.86882, longitude: 151.20929),
    bounds: W3WBaseBox(
      southWest: CLLocationCoordinate2D(latitude: -33.86982, longitude: 151.20779),
      northEast: CLLocationCoordinate2D(latitude: -33.86782, longitude: 151.21079)
    )
  )

  let square4 = W3WBaseSquare(
    words: "orange.garden.camera",
    country: W3WBaseCountry(code: "BR"),
    nearestPlace: "Rio de Janeiro, Brazil",
    distanceToFocus: W3WBaseDistance(kilometers: 0.6),
    language: W3WBaseLanguage(code: "pt"),
    coordinates: CLLocationCoordinate2D(latitude: -22.90685, longitude: -43.17290),
    bounds: W3WBaseBox(
      southWest: CLLocationCoordinate2D(latitude: -22.90785, longitude: -43.17420),
      northEast: CLLocationCoordinate2D(latitude: -22.90585, longitude: -43.17160)
    )
  )

  let square5 = W3WBaseSquare(
    words: "mountain.cloud.snow",
    country: W3WBaseCountry(code: "CH"),
    nearestPlace: "Zermatt, Switzerland",
    distanceToFocus: W3WBaseDistance(kilometers: 1.2),
    language: W3WBaseLanguage(code: "de"),
    coordinates: CLLocationCoordinate2D(latitude: 46.02071, longitude: 7.74912),
    bounds: W3WBaseBox(
      southWest: CLLocationCoordinate2D(latitude: 46.01991, longitude: 7.74792),
      northEast: CLLocationCoordinate2D(latitude: 46.02151, longitude: 7.75032)
    )
  )

  let square6 = W3WBaseSquare(
    words: "market.bike.brick",
    country: W3WBaseCountry(code: "IN"),
    nearestPlace: "Delhi, India",
    distanceToFocus: W3WBaseDistance(kilometers: 0.8),
    language: W3WBaseLanguage(code: "hi"),
    coordinates: CLLocationCoordinate2D(latitude: 28.61394, longitude: 77.20902),
    bounds: W3WBaseBox(
      southWest: CLLocationCoordinate2D(latitude: 28.61294, longitude: 77.20772),
      northEast: CLLocationCoordinate2D(latitude: 28.61494, longitude: 77.21032)
    )
  )

  let square7 = W3WBaseSquare(
    words: "desert.date.palace",
    country: W3WBaseCountry(code: "AE"),
    nearestPlace: "Dubai, UAE",
    distanceToFocus: W3WBaseDistance(kilometers: 0.9),
    language: W3WBaseLanguage(code: "en"),
    coordinates: CLLocationCoordinate2D(latitude: 25.20485, longitude: 55.27078),
    bounds: W3WBaseBox(
      southWest: CLLocationCoordinate2D(latitude: 25.20395, longitude: 55.26948),
      northEast: CLLocationCoordinate2D(latitude: 25.20575, longitude: 55.27208)
    )
  )

  
}


