//
//  File.swift
//
//
//  Created by Dave Duprey on 20/07/2023.
//

import CoreLocation
import W3WSwiftCore

// a fake API injected that returns squares that the iOS simulator will show
class MockApi: W3WProtocolV4 {
  
  var square: W3WSquare = W3WBaseSquare(words: "index.home.raft", country : W3WBaseCountry(code: "GB"), nearestPlace : "Bayswater, UK", distanceToFocus : W3WBaseDistance(kilometers: 1.0), language : W3WBaseLanguage(code:"en"), coordinates: CLLocationCoordinate2D(latitude: 51.50998, longitude: -0.1337))
  
  var index = 0
  
  let english = W3WBaseLanguage(code: "en", name: "English", nativeName: "English")
  
  
  init(square: W3WSquare? = nil) {
    if let s = square {
      self.square = s
    }
  }
  
  
  func convertToCoordinates(words: String, completion: @escaping W3WSquareResponse) {
    completion(square, nil)
  }
  
  func convertTo3wa(coordinates: CLLocationCoordinate2D, language: W3WSwiftCore.W3WLanguage, completion: @escaping W3WSwiftCore.W3WSquareResponse) {
    completion(square, nil)
  }

  func autosuggest(text: String, options: [W3WSwiftCore.W3WOption]?, completion: @escaping W3WSwiftCore.W3WSuggestionsResponse) {
    completion([square], nil)
  }

  func autosuggestWithCoordinates(text: String, options: [W3WSwiftCore.W3WOption]?, completion: @escaping W3WSwiftCore.W3WSquaresResponse) {
    completion([], nil)
  }
  
  func gridSection(bounds: W3WSwiftCore.W3WBox, completion: @escaping W3WSwiftCore.W3WGridResponse) {
    completion([], nil)
  }
  
  func gridSection(south_lat: Double, west_lng: Double, north_lat: Double, east_lng: Double, completion: @escaping W3WGridResponse) {
    completion([], nil)
  }
  
  func gridSection(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D, completion: @escaping W3WGridResponse) {
    gridSection(south_lat: southWest.latitude, west_lng: southWest.longitude, north_lat: northEast.latitude, east_lng: northEast.longitude, completion: completion)
  }
  
  func availableLanguages(completion: @escaping W3WLanguagesResponse) {
    completion([english], nil)
  }
  
  
  // MARK: Util
  
  
//  func incrementIndex() {
//    index += 1
//    if index >= twas.count {
//      index = 0
//    }
//  }
  

  // make a square with a likely match
//  func makeSquare(text: String? = nil) -> W3WBaseSquare {
//    return W3WBaseSquare(
//      words: twa,
//      country : W3WBaseCountry(code: "GB"),
//      nearestPlace : "Bayswater, UK",
//      distanceToFocus : W3WBaseDistance(kilometers: 1.0),
//      language : W3WBaseLanguage(code:"en"),
//      coordinates: CLLocationCoordinate2D(latitude: 51.50998, longitude: -0.1337)
//    )
//  }

  
  // get a three word address that is the same length as the imput
//  func makeWords(text: String?) -> String {
//    if let t = text {
//      for twa in twas {
//        if twa.count == t.count {
//          return twa
//        }
//      }
//    }
//
//    return twas[index]
//  }
  
  
}

