//
//  File.swift
//  
//
//  Created by Dave Duprey on 07/10/2024.
//

import CoreLocation
import Combine
import W3WSwiftCore
import W3WSwiftThemes


/// all the state data for a map
public class W3WMapState: W3WMapStateProtocol, W3WEventSubscriberProtocol {
  public var subscriptions = W3WEventsSubscriptions()
  
  /// current langauge to use
  public var language = W3WLive<W3WLanguage?>(W3WBaseLanguage(code: "en"))

  /// error event
  public var error = W3WEvent<W3WError?>()
  
  // is this redundant? - it's needed for W3WMapStateProtocol conformity...
  public var onError: W3WErrorResponse = { _ in }

  /// colour scheme for a map - do we need this?
  public var scheme = W3WLive<W3WScheme?>(.w3w)
  
  /// all the markers to show on a map
  public var markers = W3WLive<W3WMarkersLists>(W3WMarkersLists())
  
  /// the selected square on a map
  public var selected = W3WLive<W3WSquare?>(nil)
  
  /// the square to show as hovered over
  public var hovered = W3WLive<W3WSquare?>(nil)

  /// the position of the map in the view
  public var camera = W3WEvent<W3WMapCamera?>()

  
  public init(
    language: W3WLive<W3WLanguage?> = W3WLive<W3WLanguage?>(W3WBaseLanguage(code: "en")),
    error: W3WEvent<W3WError?> = W3WEvent<W3WError?>(),
    scheme: W3WLive<W3WSwiftThemes.W3WScheme?> = W3WLive<W3WSwiftThemes.W3WScheme?>(.w3w),
    markers: W3WLive<W3WMarkersLists> = W3WLive<W3WMarkersLists>(W3WMarkersLists()),
    selected: W3WLive<(any W3WSquare)?> = W3WLive<(any W3WSquare)?>(nil),
    hovered: W3WLive<(any W3WSquare)?> = W3WLive<(any W3WSquare)?>(nil),
    camera: W3WEvent<W3WMapCamera?> = W3WEvent<W3WMapCamera?>()
  ) {
    self.language = language
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
    //var scale = camera.value?.scale ?? 10.0
    //if scale.pointsPerMeter < 0.3 {
    //  scale = 0.3
    //}
    //send(scale: scale.pointsPerMeter * 0.9)
  }
  
  
  public func zoomIn() {
    //var scale = camera.value?.scale ?? 10.0
    //if scale.pointsPerMeter > 100.0 {
    //  scale = 100.0
    //}
    //send(scale: scale.pointsPerMeter * 1.1)
  }
  
  
  public func send(scale: Double?) {
    //var newValue = getOrMakeCamera()
    //if let s = scale {
    //  newValue?.scale = W3WMapScale(pointsPerMeter: s)
    //} else {
    //  newValue?.scale = nil
    //}
    //camera.send(newValue)
  }
  
  
  public func send(scale: W3WMapScale?) {
    //var newValue = getOrMakeCamera()
    //newValue?.scale = scale
    //camera.send(newValue)
  }

  
  public func send(center: CLLocationCoordinate2D?) {
    //var newValue = getOrMakeCamera()
    //newValue?.center = center
    //camera.send(newValue)
  }
  
  
  public func send(pitch: W3WAngle?) {
    //var newValue = getOrMakeCamera()
    //newValue?.pitch = pitch
    //camera.send(newValue)
  }
    
  
//  func getOrMakeCamera() -> W3WMapCamera? {
//    return camera ?? W3WMapCamera()
//  }
  
}
