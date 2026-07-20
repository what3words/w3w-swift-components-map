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
import W3WSwiftDesign


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
  @available(*, deprecated, renamed: "asGoogleZoom(latitude:)", message: "latitude is needed for an accurate conversion")
  public var googleZoom: Float { get { return Self.pointsPerMeterToGoogleZoom(pointsPerMeter: value, latitude: 45.0) } }
  
  
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
  @available(*, deprecated, renamed: "init(googleZoom:latitude:)", message: "latitude is needed for an accurate conversion")
  public init(googleZoom: Float) { self.value = Self.googleZoomToPointsPerMeter(googleZoom: googleZoom, latitude: 45.0) }

  
  /// init with a google zoom value
  /// - Parameters:
  ///   - googleZoom: the google map zoom value
  public init(googleZoom: Float, latitude: Double) { self.value = Self.googleZoomToPointsPerMeter(googleZoom: googleZoom, latitude: latitude) }

  
  /// init with a MapKit coordiante span
  /// - Parameters:
  ///   - span: the MKMapView span value
  ///   - mapSize: the size of the map view in points
  @available(*, deprecated, renamed: "init(span:mapSize:centerLatitude:)", message: "latitude is needed for an accurate conversion")
  public init(span: MKCoordinateSpan, mapSize: CGSize) { self.value = Self.spanToPointsPerMeter(span: span, mapSize: mapSize, centerLatitude: 45.0) }

  
  /// init with a MapKit coordiante span
  /// - Parameters:
  ///   - span: the MKMapView span value
  ///   - mapSize: the size of the map view in points
  public init(span: MKCoordinateSpan, mapSize: CGSize, centerLatitude: CLLocationDegrees) { self.value = Self.spanToPointsPerMeter(span: span, mapSize: mapSize, centerLatitude: centerLatitude) }
  

  // MARK: Accessors
  

  /// returns a MKCoordinateSpan representing the zoom value
  /// - Parameters:
  ///   - mapSize: the size of the map view in points
  ///   - latitude: the latitude of the region that the span will be
  public func asSpan(mapSize: CGSize, latitude: Double) -> MKCoordinateSpan {
    return Self.pointsPerMeterToSpan(pointsPerMeter: value, mapSize: mapSize, latitude: latitude)
  }
  
  
  public func asGoogleZoom(latitude: Double) -> Float {
    return Self.pointsPerMeterToGoogleZoom(pointsPerMeter: value, latitude: latitude)
  }
  

  /// description
  public var description: String { get { String("\(value)ppm") } }
  

  // MARK: Conversion functions
  
  /// Converts a Google Maps zoom level to Points Per Meter (ppm)
  /// - Parameters:
  ///   - googleZoom: The Google Maps zoom level (e.g., 0 for world view, 15 for streets)
  ///   - latitude: The center latitude of the map in degrees
  /// - Returns: The scale in points per meter (CGFloat)
  public static func googleZoomToPointsPerMeter(googleZoom: Float, latitude: Double) -> CGFloat {
    // Clamp latitude to standard Web Mercator limits to prevent division by zero / infinity at poles
    let clampedLat = min(max(latitude, -85.051128), 85.051128)
    let latRadians = clampedLat * .pi / 180.0
    
    // Calculate the width of the world map in points at this zoom level
    let pointsPerWorld = Self.googleTileSize * pow(2.0, Float(googleZoom))
    
    // Calculate the physical circumference of the Earth at this latitude
    let metersPerWorld = earthCircumference.meters * cos(latRadians)
    
    return CGFloat(pointsPerWorld / Float(metersPerWorld))
  }
  
  /// Converts Points Per Meter (ppm) to a Google Maps zoom level
  /// - Parameters:
  ///   - pointsPerMeter: Your internal agnostic scale value
  ///   - latitude: The center latitude of the map in degrees
  /// - Returns: The corresponding Google Maps zoom level (Float)
  public static func pointsPerMeterToGoogleZoom(pointsPerMeter: CGFloat, latitude: Double) -> Float {
    // Clamp latitude to standard Web Mercator limits
    let clampedLat = min(max(Float(latitude), -85.051128), 85.051128)
    let latRadians = clampedLat * .pi / 180.0
    
    // Calculate the physical circumference of the Earth at this latitude
    let metersPerWorld = Float(earthCircumference.meters) * cos(latRadians)
    
    // If we know points per meter, and we know meters per world at this latitude,
    // we can find the total points needed to represent the world.
    let pointsPerWorld = Float(pointsPerMeter) * metersPerWorld
    
    // Google zoom is log base 2 of (pointsPerWorld / tileSize)
    let zoom = log2(pointsPerWorld / googleTileSize)
    
    return Float(zoom)
  }
  

  /// Center-based points-per-meter using span and view size.
  /// - Parameters:
  ///   - span: the MKMapView span value
  ///   - mapSize: the size of the map view in points
  ///   - centerLatitude: so longitude distances can be computed correctly.
  public static func spanToPointsPerMeter(span: MKCoordinateSpan, mapSize: CGSize, centerLatitude: CLLocationDegrees) -> CGFloat {
    guard mapSize.width > 0, mapSize.height > 0, span.latitudeDelta > 0, span.longitudeDelta > 0 else { return W3WMapScale.standardZoom.value }

    // More accurate WGS-84 approximations for meters per degree:
    // Latitude (north-south)
    let φ = centerLatitude * .pi / 180
    let metersPerDegreeLat =
        111_132.92
        - 559.82 * cos(2 * φ)
        + 1.175  * cos(4 * φ)
        - 0.0023 * cos(6 * φ)

    // Longitude (east-west)
    let metersPerDegreeLon =
        111_412.84 * cos(φ)
        - 93.5     * cos(3 * φ)
        + 0.118    * cos(5 * φ)

    // Degrees per screen point on each axis
    let degPerPointLat = span.latitudeDelta / Double(mapSize.height)
    let degPerPointLon = span.longitudeDelta / Double(mapSize.width)

    // Meters per point on each axis
    let mppVertical   = degPerPointLat * metersPerDegreeLat
    let mppHorizontal = degPerPointLon * metersPerDegreeLon

    // Convert to points-per-meter
    let vPPM = mppVertical   > 0 ? CGFloat(1.0 / mppVertical)   : 0
    let hPPM = mppHorizontal > 0 ? CGFloat(1.0 / mppHorizontal) : 0

    // Stable single value: average axes (or pick one consistently, e.g., horizontal)
    //return (vPPM + hPPM) / 2.0
    return vPPM
  }
  
  
  /// converts points per meter to a mapkit span
  /// - Parameters:
  ///   - pointsPerMeter: the number of screen points to represent one meter
  ///   - mapSize: the size of the map view in points
  ///   - latitude: the latitude of the region
  public static func pointsPerMeterToSpan(pointsPerMeter: Double, mapSize: CGSize, latitude: Double) -> MKCoordinateSpan {
    // Meters visible in each direction for the given points-per-meter
    let verticalMeters = Double(mapSize.height) / pointsPerMeter
    let horizontalMeters = Double(mapSize.width) / pointsPerMeter

    // WGS‑84 meters-per-degree at center latitude (same model as spanToPointsPerMeter)
    let φ = latitude * .pi / 180
    let metersPerDegreeLat =
        111_132.92
      - 559.82 * cos(2 * φ)
      +   1.175 * cos(4 * φ)
      -  0.0023 * cos(6 * φ)

    let metersPerDegreeLon =
        111_412.84 * cos(φ)
      -     93.5 * cos(3 * φ)
      +     0.118 * cos(5 * φ)

    // Convert meters back to degrees on each axis
    let latitudeDelta  = verticalMeters   / metersPerDegreeLat
    let longitudeDelta = horizontalMeters / metersPerDegreeLon

    // Preserve aspect ratio: no square enforcement
    return MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
  }
    

  public func squareLineThickness() -> W3WLineThickness {
    var v = 1.9623 * exp(-0.077 * (value - 1.0))
    
    v = min(v, 2.0)
    v = max(v, 0.5)
    
    v = round(v * 2.0)
    
    return W3WLineThickness(value: v)
  }
  
  
  public func gridLineThickness() -> W3WLineThickness {
    var v = 1.9623 * exp(-0.077 * (value - 1.0))
    
    v = min(v, 2.0)
    v = max(v, 0.5)
    
    v = round(v * 2.0) / 2.0
    
    return W3WLineThickness(value: v)
  }
  
}
