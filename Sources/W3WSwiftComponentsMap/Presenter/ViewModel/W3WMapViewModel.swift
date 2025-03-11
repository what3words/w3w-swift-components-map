//
//  File.swift
//  
//
//  Created by Dave Duprey on 13/10/2024.
//

import CoreLocation
import W3WSwiftCore
import W3WSwiftThemes


open class W3WMapViewModel: W3WMapViewModelProtocol, W3WEventSubscriberProtocol {
  public var subscriptions = W3WEventsSubscriptions()
  
  public var input: W3WMapStateProtocol

  public var output = W3WEvent<W3WMapOutputEvent>()

  public var w3w: W3WProtocolV4
  
  public var gps: W3WLive<W3WSquare?>
  
  public var onError: W3WErrorResponse = { _ in }

  
  public init(mapState: W3WMapStateProtocol, w3w: W3WProtocolV4, gps: W3WLive<W3WSquare?> = W3WLive<W3WSquare?>(nil)) {
    self.input = mapState
    self.w3w = w3w
    self.gps = gps
  }
  
  public func selectSquare(with coordinates: CLLocationCoordinate2D) {
    if let language = mapState.language.value {
      w3w.convertTo3wa(coordinates: coordinates, language: language) { [weak self] square, err in
        if let square {
          self?.output.send(.selected(square))
        }
        if let err {
          self?.onError(err)
        }
      }
    }
  }
  
  public func updateCameraPosition(with camera: W3WMapCamera) {
    output.send(.camera(camera))
  }
}
