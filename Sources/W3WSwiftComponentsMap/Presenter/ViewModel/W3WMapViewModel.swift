//
//  File.swift
//  
//
//  Created by Dave Duprey on 13/10/2024.
//

import CoreLocation
import W3WSwiftCore
import W3WSwiftThemes


public class W3WMapViewModel: W3WMapViewModelProtocol, W3WEventSubscriberProtocol {
  public var subscriptions = W3WEventsSubscriptions()
  
  public var input = W3WEvent<W3WMapInputEvent>()

  public var output = W3WEvent<W3WMapOutputEvent>()

  public var w3w: W3WProtocolV4
  
  public var gps: W3WLive<W3WSquare?>
  
  public var mapState: W3WMapStateProtocol

  public var onError: W3WErrorResponse = { _ in }

  
  public init(language: W3WLive<W3WLanguage?> = W3WLive<W3WLanguage?>(W3WBaseLanguage.english), w3w: W3WProtocolV4, gps: W3WLive<W3WSquare?> = W3WLive<W3WSquare?>(nil)) {
    self.mapState = W3WMapState(language: language)
    self.w3w = w3w
    self.gps = gps
    
    subscribe(to: input) { [weak self] event in
      self?.handle(event: event)
    }
  }
  
  
  func handle(event: W3WMapInputEvent) {
    switch event {
      case .selected(let square):
        mapState.camera.send(W3WMapCamera(center: square?.coordinates))
        mapState.selected.send(square)
      case .markers(let markers):
        mapState.markers.send(markers)
      case .center(let square, let scale):
        if let centre = square.coordinates {
          mapState.camera.send(W3WMapCamera(center: centre, scale: scale))
        }
    }
  }
  
  
}
