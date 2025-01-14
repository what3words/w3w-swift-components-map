//
//  File.swift
//  
//
//  Created by Dave Duprey on 08/01/2025.
//

import MapKit


infix operator ↑ : AdditionPrecedence
infix operator ↓ : AdditionPrecedence
infix operator → : AdditionPrecedence
infix operator ← : AdditionPrecedence


extension CLLocationCoordinate2D {
  
  static public func +(left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(
      latitude: left.latitude + right.latitude,
      longitude: left.latitude + right.longitude
    )
  }

  
  static public func -(left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(
      latitude: left.latitude - right.latitude,
      longitude: left.latitude - right.longitude
    )
  }


  static public func +(left: CLLocationCoordinate2D, right: MKCoordinateSpan) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(
      latitude: left.latitude + right.latitudeDelta,
      longitude: left.latitude + right.longitudeDelta
    )
  }

  
  static public func +(left: MKCoordinateSpan, right: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(
      latitude: right.latitude + left.latitudeDelta,
      longitude: right.latitude + left.longitudeDelta
    )
  }

  
  static public func -(left: CLLocationCoordinate2D, right: MKCoordinateSpan) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(
      latitude: left.latitude - right.latitudeDelta,
      longitude: left.latitude - right.longitudeDelta
    )
  }

  
  static public func -(left: MKCoordinateSpan, right: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(
      latitude: right.latitude - left.latitudeDelta,
      longitude: right.latitude - left.longitudeDelta
    )
  }

  
  static public func ↑(left: CLLocationCoordinate2D, right: MKCoordinateSpan) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(
      latitude: left.latitude + right.latitudeDelta,
      longitude: left.longitude
    )
  }

  
  static public func ↓(left: CLLocationCoordinate2D, right: MKCoordinateSpan) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(
      latitude: left.latitude - right.latitudeDelta,
      longitude: left.longitude
    )
  }

  
  static public func →(left: CLLocationCoordinate2D, right: MKCoordinateSpan) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(
      latitude: left.latitude,
      longitude: left.longitude + right.longitudeDelta
    )
  }

  
  static public func ←(left: CLLocationCoordinate2D, right: MKCoordinateSpan) -> CLLocationCoordinate2D {
    return CLLocationCoordinate2D(
      latitude: left.latitude,
      longitude: left.longitude - right.longitudeDelta
    )
  }


}

