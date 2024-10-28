//
//  File.swift
//  
//
//  Created by Dave Duprey on 20/10/2024.
//


// stored as meters
public struct W3WAngle: ExpressibleByFloatLiteral, Equatable, CustomStringConvertible {

  /// the angle in radians
  public var radians: Double = 0.0

  public init(radians: Double) { self.radians = radians }
  
  public init(floatLiteral value: Float) { self.radians = Double(value) }

  public init(degrees: Double)     { self.radians = degrees * .pi / 180.0 }

  var degrees: Double { get { return radians * 180.0 / .pi } }
  
  static public let zero = 0.0
  
  public var description: String {
    return "\(degrees)º"
  }

}
