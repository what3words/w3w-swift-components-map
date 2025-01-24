//
//  File.swift
//  
//
//  Created by Dave Duprey on 23/01/2025.
//

import UIKit
import W3WSwiftCore
import W3WSwiftThemes
import W3WSwiftComponentsMap


class W3WMockMapView: UIView, W3WMapViewProtocol {
  
  var viewModel: any W3WMapViewModelProtocol = W3WMapViewModel(mapState: W3WMapState(), w3w: MockApi())
  
  var types = [W3WMapType(value: "standard")]
  
  var transitionScale = W3WMapScale(pointsPerMeter: 4.0)
  
  func getCameraState() -> W3WMapCamera {
    return W3WMapCamera()
  }
  
  func set(viewModel: any W3WSwiftComponentsMap.W3WMapViewModelProtocol) {
  }
  
  func set(type: String) {
  }
  
  func set(scheme: W3WScheme?) {
  }
  

}
