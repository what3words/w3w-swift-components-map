//
//  W3WMapScale.swift
//
//  Created by Dave Duprey on 11/12/2024.
//
//  Stores an internal value representing map scale.  It can be constructed with a
//  number of different scale and zoom types, including Google zoom, and MapKit span.
//  It also returns a number of different scale and zoom types, and so can be used
//  for translation between different systems of scale and zoom. The internal value
//  is stored in units of screen points per meter.
//

import CoreGraphics
import MapKit
import W3WSwiftCore


/// Stores an internal value representing map scale
public struct W3WMapScale: Equatable, ExpressibleByFloatLiteral, CustomStringConvertible {
  public typealias FloatLiteralType = Float
  
  /// number of screen points that represent one meter in a map view
  public let value: CGFloat

  /// circumference of the earth, duh
  static let earthCircumference = W3WBaseDistance(meters: 40075016.686)
  
  /// radius of the earth
  static let earthRadius = W3WBaseDistance(meters: 6371000.0)
  
  /// Tile size in pixels (Google Maps uses 256x256 tiles)
  static let googleTileSize: Float = 256.0

  
  // MARK: calculated values
  
  
  /// the number of screen points that represent one meter in a map view
  public var pointsPerMeter: CGFloat { get { return value } }

  /// the number of screen points that represent one kilometer in a map view
  public var pointsPerKilometer: CGFloat { get { return value / 1000.0 } }
  
  // the google zoom value for this scale
  public var googleZoom: Float { get { return Self.pointsPerMeterToGoogleZoom(pointsPerMeter: value) } }
  
  
  // MARK: Innit
  
  
  /// init with an assigment operator from CGFloat
  public init(floatLiteral value: Float) { self.value = CGFloat(value) }
  
  
  /// init with an assigment operator from Double
  public init(floatLiteral value: CGFloat) { self.value = value }
  
  
  /// init with the number of screen points that represent one meter in a map view
  /// - Parameters:
  ///   - pointsPerMeter: the number of screen points to represent one meter
  public init(pointsPerMeter: CGFloat) { self.value = pointsPerMeter }
  
  
  /// init with the number of screen points that represent one kilometer in a map view
  /// - Parameters:
  ///   - pointsPerKilometer: the number of screen points to represent one kilometer
  public init(pointsPerKilometer: CGFloat) { self.value = pointsPerKilometer * 1000.0 }
  
  
  /// init with a google zoom value
  /// - Parameters:
  ///   - googleZoom: the google map zoom value
  public init(googleZoom: Float) { self.value = Self.googleZoomToPixelsPerMeter(googleZoom: googleZoom) }

  
  /// init with a MapKit coordiante span
  /// - Parameters:
  ///   - span: the MKMapView span value
  ///   - mapSize: the size of the map view in points
  public init(span: MKCoordinateSpan, mapSize: CGSize) { self.value = Self.spanToPointsPerMeter(span: span, mapSize: mapSize) }
  

  // MARK: Accessors
  

  /// returns a MKCoordinateSpan representing the zoom value
  /// - Parameters:
  ///   - mapSize: the size of the map view in points
  ///   - latitude: the latitude of the region that the span will be
  func asSpan(mapSize: CGSize, latitude: Double) -> MKCoordinateSpan {
    return Self.pointsPerMeterToSpan(pointsPerMeter: value, mapSize: mapSize, latitude: 0.0) // latitude)
  }
  

  /// description
  public var description: String { get { String("{\(value)ppm, \(googleZoom)zm}") } }
  

  // MARK: Conversion functions
  
  
  /// converts a google zoom level to pixels per meter
  /// - Parameters:
  ///   - googleZoom: the google map zoom value
  public static func googleZoomToPixelsPerMeter(googleZoom: Float) -> CGFloat {
    
    // Calculate points per meter
    let pointsPerMeter = pow(2.0, googleZoom) * Self.googleTileSize / Float(earthCircumference.meters)
    
    return CGFloat(pointsPerMeter)
  }
  

  /// convert a pixels per meter to google zoom level
  /// - Parameters:
  ///   - pointsPerMeter: the number of screen points to represent one meter
  public static func pointsPerMeterToGoogleZoom(pointsPerMeter: CGFloat) -> Float {
    // Clamp zoom to zero if pixelsPerMeter is negative
    if pointsPerMeter <= 0.0 {
      return 0.0
    }
    
    // Calculate zoom level
    let zoom = log2(Float(pointsPerMeter) * Float(earthCircumference.meters) / Self.googleTileSize)
    
    return zoom
  }
  
  
  /// converts a MapKit span to pixels per meter
  /// - Parameters:
  ///   - span: the MKMapView span value
  ///   - mapSize: the size of the map view in points
  public static func spanToPointsPerMeter(span: MKCoordinateSpan, mapSize: CGSize) -> Double {
    // Earth's radius in meters
    //let earthRadius: Double = 6371000.0

    // Calculate the vertical distance (latitude delta to meters)
    let latitudeDelta = span.latitudeDelta
    let verticalMeters = (latitudeDelta / 360.0) * 2 * .pi * earthRadius.meters
    let pointsPerMeterVertical = mapSize.height / verticalMeters

    // Calculate the horizontal distance (longitude delta to meters). Longitude distance varies with latitude (cosine scaling)
    let longitudeDelta = span.longitudeDelta
    let latitudeForLongitudeScaling = span.latitudeDelta / 2.0 // Midpoint latitude
    let horizontalMeters = (longitudeDelta / 360.0) * 2 * .pi * earthRadius.meters * cos(latitudeForLongitudeScaling * .pi / 180.0)
    let pointsPerMeterHorizontal = mapSize.width / horizontalMeters

    // Return the minimum of vertical and horizontal points per meter
    return min(pointsPerMeterVertical, pointsPerMeterHorizontal)
  }
  
  
  /// converts points per meter to a mapkit span
  /// - Parameters:
  ///   - pointsPerMeter: the number of screen points to represent one meter
  ///   - mapSize: the size of the map view in points
  ///   - latitude: the latitude of the region
  public static func pointsPerMeterToSpan(pointsPerMeter: Double, mapSize: CGSize, latitude: Double) -> MKCoordinateSpan {
    // Earth's radius in meters
    //let earthRadius: Double = 6_371_000.0

    // Vertical span (latitudeDelta)
    let verticalMeters = mapSize.height / pointsPerMeter
    let latitudeDelta = (verticalMeters * 360) / (2 * .pi * earthRadius.meters)

    // Horizontal span (longitudeDelta)
    let horizontalMeters = mapSize.width / pointsPerMeter
    let longitudeDelta = (horizontalMeters * 360) / (2 * .pi * earthRadius.meters * cos(latitude * .pi / 180.0))

    // make it a square with the minimum value
    let minSpan = min(latitudeDelta, longitudeDelta)

    // Return the span
    return MKCoordinateSpan(latitudeDelta: minSpan, longitudeDelta: minSpan)
  }
  
}





// MARK: Old failed code



//    let eastMapPoint = mapView.region.center.longitude - mapView.region.span.longitudeDelta
//    let westMapPoint = mapView.region.center.longitude + mapView.region.span.longitudeDelta
//
//    let northMapPoint = mapView.region.center.latitude + mapView.region.span.latitudeDelta
//    let southMapPoint = mapView.region.center.latitude - mapView.region.span.latitudeDelta
//
//    let longitudinal = W3WBaseDistance(from: mapView.region.center, to: mapView.region.center)
//
//    let longitudinalDistance = eastMapPoint.distance(to: westMapPoint)
//    let latidudinalDistance = southMapPoint.distance(to: northMapPoint)
//
//    let shortestDistance = min(longitudinalDistance, latidudinalDistance)
//    let shortestPoints = min(mapView.frame.width, mapView.frame.height)
//
//    let pointsPerMeter = shortestPoints / shortestDistance
//
//    return pointsPerMeter


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



//// Calculate the scale denominator
//let scaleDenominator = Float(earthCircumference.meters) / Self.googleTileSize
//
//// Calculate zoom level
//let zoom = log2(Float(pixelsPerMeter) / scaleDenominator)
//
//return zoom

// based on 591657550.500000 / 2^(level) from https://gis.stackexchange.com/questions/7430/what-ratio-scales-do-google-maps-zoom-levels-correspond-to
//let scale = Float(pixelsPerMeter)
//let zoom = log(591657550.5 / scale) / log(2.0)

//metersPerPx = 156543.03392 * Math.cos(latLng.lat() * Math.PI / 180) / Math.pow(2, zoom)
//let ground_resolution = (cos(latitude.degrees * pi/180) * 2 * pi * 6378137) / (256 * 2 ^ zoomLevel)

//return zoom



/// this HAS NOT been tested, it is here as a temporary example
/// it needs to be rewritten carefully
//  @available(*, deprecated, message: "this HAS NOT been tested, it is here as a temporary example")
//  public static func spanToPointsPerMeter(span: MKCoordinateSpan, mapView: MKMapView) -> CGFloat {
//
//    let east  = mapView.region.center → mapView.region.span
//    let west  = mapView.region.center ← mapView.region.span
//    let north = mapView.region.center ↑ mapView.region.span
//    let south = mapView.region.center ↓ mapView.region.span
//
//    let latitudinalDistance  = W3WBaseDistance(from: south, to: north)
//    let longitudinalDistance = W3WBaseDistance(from: east, to: west)
//
//    let shortestDistance = min(longitudinalDistance.meters, latitudinalDistance.meters)
//    let shortestPoints = min(mapView.frame.width, mapView.frame.height)
//
//    let pointsPerMeter = shortestPoints / shortestDistance
//
//    return pointsPerMeter
//  }



//  func spanToPointsPerMeter2(span: MKCoordinateSpan, mapSizeInPoints: CGSize) -> (latPointsPerMeter: Double, lonPointsPerMeter: Double) {
//      // Earth's radius in meters
//      let earthRadius: Double = 6_371_000.0
//      // Calculate the vertical distance (latitudeDelta to meters)
//      let latitudeMeters = (span.latitudeDelta / 360.0) * 2 * .pi * earthRadius
//      let pointsPerMeterVertical = mapSizeInPoints.height / latitudeMeters
//      // Calculate the horizontal distance (longitudeDelta to meters)
//      // Correctly scale longitude by latitude
//      let longitudeMeters = (span.longitudeDelta / 360.0) * 2 * .pi * earthRadius * cos((span.latitudeDelta / 2.0) * .pi / 180.0)
//      let pointsPerMeterHorizontal = mapSizeInPoints.width / longitudeMeters
//      return (latPointsPerMeter: pointsPerMeterVertical, lonPointsPerMeter: pointsPerMeterHorizontal)
//  }

/// this HAS NOT been tested, it is here as a temporary example
/// it needs to be rewritten carefully
//  @available(*, deprecated, message: "this HAS NOT been tested, it is here as a temporary example")
//  public static func scaleToSpan(scale: W3WMapScale, mapView: MKMapView) -> MKCoordinateSpan {
//
//    let span = mapView.region.span
//    let center = mapView.region.center
//
//    let pxWidth  = mapView.frame.width
//    let pxHeight = mapView.frame.height
//
//    let metersX = pxWidth / scale.value
//    let metersY = pxHeight / scale.value
//
//    var newregion = mapView.region
//    return MKCoordinateRegion(center: center, latitudinalMeters: metersY, longitudinalMeters: metersX).span
//  }
