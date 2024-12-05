//
//  File.swift
//  
//
//  Created by Dave Duprey on 07/10/2024.
//

import CoreLocation
import W3WSwiftCore
import W3WSwiftThemes


/// all the state data for a map
public class W3WMapState: W3WMapStateProtocol, W3WMapStateFunctionsProtocol, W3WEventSubscriberProtocol {
  public var subscriptions = W3WEventsSubscriptions()
  
  public var mapState: W3WMapState { get { return self } }
  
  /// error event
  public var error = W3WEvent<W3WError?>()
  
  // is this redundant? - it's needed for W3WMapStateProtocol conformity...
  public var onError: W3WErrorResponse = { _ in }

  /// colour scheme for a map - do we need this?
  public var scheme = W3WLive<W3WSwiftThemes.W3WScheme?>(.w3w)
  
  /// all the markers to show on a map
  public var markers = W3WLive<W3WMarkersLists>(W3WMarkersLists())
  
  /// the selected square on a map
  public var selected = W3WLive<(any W3WSquare)?>(nil)
  
  /// the square to show as hovered over
  public var hovered = W3WLive<(any W3WSquare)?>(nil)

  /// the position of the map in the view
  public var camera = W3WLive<W3WMapCamera?>(nil)

  
  public init(
    error: W3WEvent<W3WError?> = W3WEvent<W3WError?>(),
    scheme: W3WLive<W3WSwiftThemes.W3WScheme?> = W3WLive<W3WSwiftThemes.W3WScheme?>(.w3w),
    markers: W3WLive<W3WMarkersLists> = W3WLive<W3WMarkersLists>(W3WMarkersLists()),
    selected: W3WLive<(any W3WSquare)?> = W3WLive<(any W3WSquare)?>(nil),
    hovered: W3WLive<(any W3WSquare)?> = W3WLive<(any W3WSquare)?>(nil),
    camera: W3WLive<W3WMapCamera?> = W3WLive<W3WMapCamera?>(nil)
  ) {
    self.error = error
    self.scheme = scheme
    self.markers = markers
    self.selected = selected
    self.hovered = hovered
    self.camera = camera
    
    configure()
  }
  

  /// all the state data needed to show a map
  public func configure() {
    // hook up the onError closure
    subscribe(to: error) { [weak self] error in
      if let e = error {
        self?.onError(e)
      }
    }
  }

  
  public func zoomOut() {
    var scale = camera.value?.scale ?? 10.0
    if scale < 0.3 {
      scale = 0.3
    }
    send(scale: scale * 0.9)
  }
  
  
  public func zoomIn() {
    var scale = camera.value?.scale ?? 10.0
    if scale > 100.0 {
      scale = 100.0
    }
    send(scale: scale * 1.1)
  }
  
  
  public func send(scale: Double) {
    var newValue = getOrMakeCamera()
    newValue?.scale = scale
    camera.send(newValue)
  }
    
  
  public func send(center: CLLocationCoordinate2D) {
    var newValue = getOrMakeCamera()
    newValue?.center = center
    camera.send(newValue)
  }
  
  
  public func send(pitch: W3WAngle) {
    var newValue = getOrMakeCamera()
    newValue?.pitch = pitch
    camera.send(newValue)
  }
    
  
  func getOrMakeCamera() -> W3WMapCamera? {
    return camera.value ?? W3WMapCamera()
  }
  
}
