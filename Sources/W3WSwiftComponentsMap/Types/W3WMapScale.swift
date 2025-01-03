//
//  File.swift
//  
//
//  Created by Dave Duprey on 11/12/2024.
//

import CoreGraphics
import MapKit


public struct W3WMapScale: Equatable, ExpressibleByFloatLiteral, CustomStringConvertible {
  public typealias FloatLiteralType = Float
  
  /// number of screen points that represent one meter in a map view
  public let value: CGFloat

  
  /// init with an assigment operator from CGFloat
  public init(floatLiteral value: Float) { self.value = CGFloat(value) }
  
  /// init with an assigment operator from Double
  public init(floatLiteral value: CGFloat) { self.value = value }
  
  /// init with the number of screen points that represent one meter in a map view
  public init(pointsPerMeter: CGFloat) { self.value = pointsPerMeter }
  
  /// init with the number of screen points that represent one kilometer in a map view
  public init(pointsPerKilometer: CGFloat) { self.value = pointsPerKilometer * 1000.0 }
  
  /// this HAS NOT been tested, it is here as a temporary example, and the convert funciton was taken from some random web page
  @available(*, message: "this HAS NOT been tested, it is here as a temporary example, and the convert funciton was taken from some random web page")
  public init(googleZoom: Double, latitude: Double) { self.value = Self.getPixelsPerMeter(lat: W3WAngle(degrees: latitude), zoom: googleZoom) }

  
  /// the number of screen points that represent one meter in a map view
  var pointsPerMeter: CGFloat { get { return value } }

  /// the number of screen points that represent one kilometer in a map view
  var pointsPerKilometer: CGFloat { get { return value / 1000.0 } }

  
  /// this HAS NOT been tested, it is here as a temporary example
  @available(*, deprecated, message: "this HAS NOT been tested, it is here as a temporary example")
  func asSpan(mapView: MKMapView) -> MKCoordinateSpan {
    return Self.scaleToSpan(scale: self, mapView: mapView)
  }
  

  /// description
  public var description: String { get { String("\(value)ppm") } }
  

  // MARK: Conversion functions
  
  /// this HAS NOT been tested, it is here as a temporary example, and the convert funciton was taken from some random web page
  @available(*, deprecated, message: "this HAS NOT been tested, it is here as a temporary example, and the convert funciton was taken from some random web page")
  public static func getPixelsPerMeter(lat: W3WAngle, zoom: Double) -> CGFloat {
    let pixelsPerTile = 256.0 * 163.0 / 160.0;
    let numTiles = pow(2.0, zoom);
    let metersPerTile = cos(lat.radians) * 6000.0 / numTiles;
    return pixelsPerTile / metersPerTile;
  }
  
  
  
  /// this HAS NOT been tested, it is here as a temporary example
  /// it needs to be rewritten carefully
  @available(*, deprecated, message: "this HAS NOT been tested, it is here as a temporary example")
  public static func scaleToSpan(scale: W3WMapScale, mapView: MKMapView) -> MKCoordinateSpan {
        
    let span = mapView.region.span
    let center = mapView.region.center
    
    let pxWidth  = mapView.frame.width
    let pxHeight = mapView.frame.height

    let metersX = pxWidth / scale.value
    let metersY = pxHeight / scale.value

    var newregion = mapView.region
    return MKCoordinateRegion(center: center, latitudinalMeters: metersY, longitudinalMeters: metersX).span

//    let loc1 = CLLocation(latitude: center.latitude - span.latitudeDelta * 0.5, longitude: center.longitude)
//    let loc2 = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5, longitude: center.longitude)
//    let loc3 = CLLocation(latitude: center.latitude, longitude: center.longitude - span.longitudeDelta * 0.5)
//    let loc4 = CLLocation(latitude: center.latitude, longitude: center.longitude + span.longitudeDelta * 0.5)
//     
//    let metersInLatitude = loc1.distance(from: loc2)
//    let metersInLongitude = loc3.distance(from: loc4)
//    
//    let px1 = mapView.convert(loc1.coordinate, toPointTo: mapView)
//    let px2 = mapView.convert(loc2.coordinate, toPointTo: mapView)
//    let px3 = mapView.convert(loc3.coordinate, toPointTo: mapView)
//    let px4 = mapView.convert(loc4.coordinate, toPointTo: mapView)
//    
//    let pixelsInLatitude  = abs(px1.y - px2.y)
//    let pixelsInLongitude = abs(px3.x - px4.x)
//    
//    let pixels = min(pixelsInLatitude, pixelsInLongitude)
//    var meters = min(metersInLatitude, metersInLongitude)
//    
//    if meters == 0 {
//      meters = 1.0
//    }
//    
//    let pixelsPerMeter = pixels / meters
//    
//    let factor = pixelsPerMeter / scale.pointsPerMeter
//    
//    var latDelta = span.latitudeDelta * factor
//    var lngDelta = span.longitudeDelta * factor
//    
//    // sanity check
//    if latDelta.isNaN || lngDelta.isNaN {
//      latDelta = span.latitudeDelta
//      lngDelta = span.longitudeDelta
//    }
//
//    print("latitudeDelta", latDelta, "longitudeDelta", lngDelta)
//    
//    return MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
  }

}


