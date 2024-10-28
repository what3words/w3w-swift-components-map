//
//  File.swift
//  
//
//  Created by Dave Duprey on 19/10/2024.
//

import MapKit
import W3WSwiftCore
import W3WSwiftDesign
import W3WSwiftComponents

#if canImport(W3WSwiftCoreSdk)
import W3WSwiftCoreSdk
#endif

// FOR ZOOM LEVEL LOOK AT https://github.com/johndpope/MKMapViewZoom

public class W3WAppleMapView: W3WView, W3WMapViewProtocol, W3WEventSubscriberProtocol, MKMapViewDelegate {
    
  public var subscriptions = W3WEventsSubscriptions()
  
  public var viewModel: W3WMapViewModelProtocol
  
  public lazy var mapView = W3WMapView(frame: .w3wWhatever, w3w: viewModel.w3w)

  public var types: [W3WMapType] { get { return [.standard, .satellite, .hybrid, "satelliteFlyover", "hybridFlyover", "mutedStandard"] } }

  public init(viewModel: W3WMapViewModelProtocol) {
    self.viewModel = viewModel
    super.init(scheme: .w3w)
    configure()
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func configure() {
    mapView.delegate = self
    addSubview(mapView)
    mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 0.00001, maxCenterCoordinateDistance: 10000.0)
    mapView.mapType = .mutedStandard
  }

  
  public func set(viewModel: W3WMapViewModelProtocol) {
    self.viewModel = viewModel
    
    subscribe(to: viewModel.mapState.camera) { [weak self] camera in self?.handle(mapCamera: camera) }
  }
  
  
  public func set(type: String) {
    switch type {
      case "standard": mapView.mapType = .standard
      case "satellite": mapView.mapType = .satellite
      case "hybrid": mapView.mapType = .hybrid
      case "satelliteFlyover": mapView.mapType = .satelliteFlyover
      case "hybridFlyover": mapView.mapType = .hybridFlyover
      case "mutedStandard": mapView.mapType = .mutedStandard
      default: mapView.mapType = .standard
    }
  }
  
  
  func handle(mapCamera: W3WMapCamera?) {
    if let center = mapCamera?.center, let scale = mapCamera?.scale {
      let region = MKCoordinateRegion(center: center, span: scaleToSpan(scale: scale))
      mapView.setRegion(region, animated: true)
      
    } else if let center = mapCamera?.center {
      mapView.setCenter(center, animated: true)
      
    } else if let scale = mapCamera?.scale {
      let region = MKCoordinateRegion(center: mapView.centerCoordinate, span: scaleToSpan(scale: scale))
      mapView.setRegion(region, animated: true)
    }
  }
  
  
  // MARK: Delegate
  
  
  // Tells the delegate when the map view’s visible region changes.
  public func mapViewDidChangeVisibleRegion(_: MKMapView) {
    //viewModel.mapState.camera.send(makeW3WMapCameraFromMapView())
  }


  // MARK: Util
  
  
  // given a W3WMapCamera, make a MKMapCamera
  func mkMapCameraFromW3WCamera(camera: W3WMapCamera?) -> MKMapCamera {
    return MKMapCamera(
      lookingAtCenter: camera?.center ?? mapView.centerCoordinate,
      fromDistance: camera?.scale ?? 1.0,
      pitch: camera?.pitch?.degrees ?? 0.0,
      heading: camera?.angle?.degrees ?? 0.0
    )
  }
  
  
  func makeW3WMapCameraFromMapView() -> W3WMapCamera {
    return W3WMapCamera(
      center: mapView.camera.centerCoordinate,
      scale: 10.0,
      angle: W3WAngle(degrees: mapView.camera.heading),
      pitch: W3WAngle(degrees: mapView.camera.pitch)
    )
  }
  
  
  func scaleToSpan(scale: W3WPointsPerMeter) -> MKCoordinateSpan {
    let span = mapView.region.span
    let center = mapView.region.center
     
    let loc1 = CLLocation(latitude: center.latitude - span.latitudeDelta * 0.5, longitude: center.longitude)
    let loc2 = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5, longitude: center.longitude)
    let loc3 = CLLocation(latitude: center.latitude, longitude: center.longitude - span.longitudeDelta * 0.5)
    let loc4 = CLLocation(latitude: center.latitude, longitude: center.longitude + span.longitudeDelta * 0.5)
     
    let metersInLatitude = loc1.distance(from: loc2)
    let metersInLongitude = loc3.distance(from: loc4)
    
    let px1 = mapView.convert(loc1.coordinate, toPointTo: mapView)
    let px2 = mapView.convert(loc2.coordinate, toPointTo: mapView)
    let px3 = mapView.convert(loc3.coordinate, toPointTo: mapView)
    let px4 = mapView.convert(loc4.coordinate, toPointTo: mapView)
    
    let pixelsInLatitude  = abs(px1.y - px2.y)
    let pixelsInLongitude = abs(px3.x - px4.x)
    
    let pixels = min(pixelsInLatitude, pixelsInLongitude)
    var meters = min(metersInLatitude, metersInLongitude)
    
    if meters == 0 {
      meters = 1.0
    }
    
    let pixelsPerMeter = pixels / meters
    
    let factor = pixelsPerMeter / scale
    
    var latDelta = span.latitudeDelta * factor
    var lngDelta = span.longitudeDelta * factor
    
    // sanity check
    if latDelta.isNaN || lngDelta.isNaN {
      latDelta = span.latitudeDelta
      lngDelta = span.longitudeDelta
    }

    print("latitudeDelta", latDelta, "longitudeDelta", lngDelta)
    
    return MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
  }
  
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    // keep the map view filling the whole frame
    mapView.frame = frame
  }
    
}


// MARK: leftover

  
//  func scaleToRegion(center: CLLocationCoordinate2D, scale: W3WPointsPerMeter) -> MKCoordinateRegion {
//
//    let lat = mapView.centerCoordinate.latitude
//    let lng = mapView.centerCoordinate.longitude
//    let spanLat = mapView.region.span.latitudeDelta
//    let spanLng = mapView.region.span.longitudeDelta
//    
//    let corner = CLLocation(latitude: lat - spanLat, longitude: lng - spanLng)
//    let north  = CLLocation(latitude: lat + spanLat, longitude: lng - spanLng)
//    let east   = CLLocation(latitude: lat - spanLat, longitude: lng + spanLng)
//
//    let latDistance = corner.distance(from: north)
//    let lngDistance = corner.distance(from: east)
//
//    let cornerPix = mapView.convert(corner.coordinate, toPointTo: mapView)
//    let northPix  = mapView.convert(north.coordinate, toPointTo: mapView)
//    let eastPix  = mapView.convert(east.coordinate, toPointTo: mapView)
//    
//    let eastDistance = abs(cornerPix.x - northPix.x)
//    let northDistance = abs(cornerPix.y - northPix.y)
//
//    let pixelsPerMeter0 = northDistance / latDistance
//    let pixelsPerMeter1 = eastDistance / lngDistance
//
//    return MKCoordinateRegion(center: center, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0)
//
////    let point0 = MKMapPoint(CLLocationCoordinate2D(
////      latitude: mapView.centerCoordinate.latitude - mapView.region.span.latitudeDelta,
////      longitude: mapView.centerCoordinate.longitude - mapView.region.span.longitudeDelta)
////    )
////    let point1 = MKMapPoint(CLLocationCoordinate2D(
////      latitude: mapView.centerCoordinate.latitude + mapView.region.span.latitudeDelta,
////      longitude: mapView.centerCoordinate.longitude + mapView.region.span.longitudeDelta)
////    )
////    
////    let distance = W3WBaseDistance(meters:point0.distance(to: point1))
////
////    let region = MKCoordinateRegion(center: mapView.centerCoordinate, latitudinalMeters: scale, longitudinalMeters: scale)
////    return region
//    
////    let pointsAcrossView = min(frame.width, frame.height)
////    let spanAcrossView =  frame.width < frame.height ? region.span.longitudeDelta : region.span.latitudeDelta
////    let distance = W3WBaseDistance(meters: scale)
////    return MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: distance.meters, longitudinalMeters: distance.meters)
//  }



/// LEFT OVER
///
///   // Tells the delegate when the region the map view is displaying changes.
//public func mapView(_: MKMapView, regionDidChangeAnimated: Bool) {
//}
//Tells the delegate when the region the map view is displaying is about to change.
//public func mapView(_: MKMapView, regionWillChangeAnimated: Bool) {
//}

//  public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//    print("called", #function)
//    commandQueue.executeNextCommand(mapView: mapView)
//  }

//  public func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
//    executeNextCommand()
//  }
//
//  public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//    executeNextCommand()
//  }


