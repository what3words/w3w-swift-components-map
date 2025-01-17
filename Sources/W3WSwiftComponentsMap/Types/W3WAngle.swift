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

  public var degrees: Double { get { return radians * 180.0 / .pi } }
  
  static public let zero  = W3WAngle(degrees: 0.0)
  static public let north = W3WAngle(degrees: 0.0)
  static public let west  = W3WAngle(degrees: 90.0)
  static public let south = W3WAngle(degrees: 180.0)
  static public let east  = W3WAngle(degrees: 270.0)

  public var description: String {
    return "\(degrees)º"
  }

  
  public static func +(left: W3WAngle, right: W3WAngle) -> W3WAngle {
    return W3WAngle(radians: left.radians + right.radians)
  }
  
  
  public static func -(left: W3WAngle, right: W3WAngle) -> W3WAngle {
    return W3WAngle(radians: left.radians - right.radians)
  }
  

  /// find the nearest coterminal angle that prevents a complete revolution
  /// in other words, if self = 0.1r, and to = 6.2r return -0.08318530717958605
  /// instead of 6.3, because this prevents rotating all the way around, it will
  /// rotate to the correct angle using the shortest path
  public func nearestCoterminal(to: W3WAngle) -> W3WAngle {
    let coterminalplus  = W3WAngle(radians: to.radians + 2.0 * .pi)
    let coterminalminus = W3WAngle(radians: to.radians - 2.0 * .pi)
    
    if abs(to.radians - radians) < abs(coterminalplus.radians - radians) && abs(to.radians - radians) < abs(coterminalminus.radians - radians) {
      return to
    } else if abs(coterminalminus.radians - radians) < abs(coterminalplus.radians - radians) {
      return coterminalminus
    } else {
      return coterminalplus
    }
  }
  
}
