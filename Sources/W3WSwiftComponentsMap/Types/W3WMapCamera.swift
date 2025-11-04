//
//  File.swift
//  
//
//  Created by Dave Duprey on 20/10/2024.
//

import CoreLocation
import W3WSwiftCore
import MapKit


public struct W3WMapCamera: Equatable, CustomStringConvertible {
  
  public var center: CLLocationCoordinate2D?
  
  public var scale: W3WMapScale? = 0.1

  public var angle: W3WAngle?
  
  public var pitch: W3WAngle?

  
  public init(center: CLLocationCoordinate2D? = nil, scale: W3WMapScale? = nil, angle: W3WAngle? = nil, pitch: W3WAngle? = nil) {
    self.center = center
    self.scale = scale
    self.angle = angle
    self.pitch = pitch
  }
  
  
  // MARK: Protocol Conformance
  
  public static func == (lhs: W3WMapCamera, rhs: W3WMapCamera) -> Bool {
    return lhs.center?.latitude == rhs.center?.latitude
    && lhs.center?.longitude == rhs.center?.longitude
    && lhs.scale == rhs.scale
    && lhs.angle == rhs.angle
    && lhs.pitch == rhs.pitch
  }
  
  
  public func contains(coordinates: CLLocationCoordinate2D?, mapSize: CGSize) -> Bool {
    if let coords = coordinates, let point = center {
      if let span = scale?.asSpan(mapSize: mapSize, latitude: coords.latitude) {
        if coords.longitude < point.longitude + span.longitudeDelta && coords.longitude > point.longitude - span.longitudeDelta {
          if coords.latitude < point.latitude + span.latitudeDelta && coords.latitude > point.latitude - span.latitudeDelta {
            return true
          }
        }
      }
    }
    return false
  }
  
  
  public var description: String {
    var retval = [String]()

    if let center = center { retval.append("\(center.latitude), \(center.longitude)") }
    if let scale  = scale  { retval.append(scale.description) }
    if let angle  = angle  { retval.append(angle.description) }
    if let pitch  = pitch  { retval.append(pitch.description) }

    return "(" + retval.joined(separator: ", ") + ")"
  }
  

  
}






// EXPERIMENTAL FUNCTIONS
extension W3WMapCamera {
  
  //https://gist.github.com/marmelroy/0fee54bfe69bfbfcbbf7057298fca046
  func cameraZoom(from minLongitudinalMeters: Double, viewBounds: CGRect) -> MKMapView.CameraZoomRange? {
    // The aperture of the MKMapCamera isn’t documented, but there are reports here and
    // there of this being the case. And we have established this by telling the map to
    // focus on a specific latitudinal distance (because that’s the longest dimension),
    // and then checking the centre coordinate distance of the camera. The aperture can
    // then be calculated by `2 * atan(latitudinalDistance / 2.0 /
    // mapView.camera.centerCoordinateDistance) * 180.0 * .pi`, which gives ≈30.00.
    // Converted to radians for the calculation below.
    let mapCameraAperture = 30.0 * .pi / 180
    
    // Because the map view isn’t square, we need to adjust for the aspect ratio.
    let aspectRatio = Double(viewBounds.size.height / viewBounds.size.width)
    
    // For some reason, the camera zoom range is off by a factor ≈1.55. That is, if
    // you set the minimum to 2500, and then zoom as far in as you can, the camera
    // reports a center coordinate distance of ≈1610. Verified on iOS 13 and 14, in
    // the simulator and on device. (https://stackoverflow.com/q/64352591/446328)
    let mapKitBugAdjustmentFactor = 1.55
    
    let minCameraDistance = (minLongitudinalMeters * aspectRatio) /
        (2 * tan(mapCameraAperture / 2)) * mapKitBugAdjustmentFactor
    
    return MKMapView.CameraZoomRange(minCenterCoordinateDistance: minCameraDistance)
  }

  
}
