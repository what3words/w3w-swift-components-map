//
//  File.swift
//  
//
//  Created by Dave Duprey on 10/12/2024.
//

import CoreLocation
import W3WSwiftCore


class W3WDummyApi: W3WProtocolV4 {
  
  func convertToCoordinates(words: String, completion: @escaping W3WSquareResponse) {
  }
  
  func convertTo3wa(coordinates: CLLocationCoordinate2D, language: any W3WLanguage, completion: @escaping W3WSquareResponse) {
  }
  
  func autosuggest(text: String, options: [W3WOption]?, completion: @escaping W3WSuggestionsResponse) {
  }
  
  func autosuggestWithCoordinates(text: String, options: [W3WOption]?, completion: @escaping W3WSquaresResponse) {
  }
  
  func gridSection(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D, completion: @escaping W3WGridResponse) {
  }
  
  func gridSection(bounds: any W3WBox, completion: @escaping W3WGridResponse) {
  }
  
  func availableLanguages(completion: @escaping W3WLanguagesResponse) {
  }
  
}
