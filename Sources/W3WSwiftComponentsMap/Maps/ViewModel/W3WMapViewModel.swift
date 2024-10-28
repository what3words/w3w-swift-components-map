//
//  File.swift
//  
//
//  Created by Dave Duprey on 13/10/2024.
//

import CoreLocation
import W3WSwiftCore
import W3WSwiftThemes


public class W3WMapViewModel: W3WMapViewModelProtocol, W3WMapStateFunctionsProtocol {
  
  public var w3w: W3WProtocolV4
  
  public var mapState = W3WMapState()

  public var onError: W3WErrorResponse = { _ in }

  
  public init(mapState: W3WMapState = W3WMapState(), w3w: W3WProtocolV4) {
    self.mapState = mapState
    self.w3w = w3w
  }
  
  
}
