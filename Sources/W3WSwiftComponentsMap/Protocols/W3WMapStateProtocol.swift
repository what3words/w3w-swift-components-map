//
//  Created by Dave Duprey on 01/03/2022.
//

import Foundation
import CoreLocation
import UIKit
import W3WSwiftCore
import W3WSwiftThemes


public protocol W3WMapStateProtocol {

  var language: W3WLive<W3WLanguage?> { get set }
  
  var markers: W3WLive<W3WMarkersLists> { get set }
  
  var selected: W3WLive<W3WSquare?> { get set }
  
  var hovered: W3WLive<W3WSquare?> { get set }

  var camera: W3WEvent<W3WMapCamera?> { get set }

}


public extension W3WMapStateProtocol {
  static var defautGroupName: String { get { return "default" } }

  func loadValues(state: W3WMapStateProtocol) {
    //self.scheme.send(state.scheme.value)
    self.markers.send(state.markers.value)
    self.selected.send(state.selected.value)
    self.hovered.send(state.hovered.value)
    //self.camera.send(state.camera.value)
  }
  
  
  func send() {
    hovered.send(hovered.value)
    selected.send(selected.value)
    markers.send(markers.value)
    language.send(language.value)
  }
  
}
