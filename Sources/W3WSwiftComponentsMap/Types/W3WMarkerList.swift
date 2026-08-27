//
//  File.swift
//  
//
//  Created by Dave Duprey on 23/09/2024.
//

import W3WSwiftCore
import W3WSwiftThemes
import Foundation


public class W3WMarkerList: CustomStringConvertible {
  
  /// the colour of the markers in this group
  public var color: W3WColor?

  /// the type of marker (circle, sqaure, etc
  public var type: W3WMarkerType?
  
  /// the list of squares to mark
  public var markers: [W3WSquare]
  
  
  /// a named, coloured, group of markers
  public init(color: W3WColor? = nil, type: W3WMarkerType? = nil, markers: [W3WSquare] = []) {
    self.color = color
    self.type = type
    self.markers = markers
  }
  
  
  public func getMarkers() -> [W3WSquare] {
    return markers
  }
  
  
  static func + (left: W3WMarkerList, right: W3WMarkerList) -> W3WMarkerList {
    return W3WMarkerList(color: left.color, type: left.type, markers: left.markers + right.markers)
  }
  

  /// make a deep copy of the list
  public func copy() -> W3WMarkerList {
    return W3WMarkerList(color: self.color, type: self.type, markers: self.markers.map { $0 })
  }
  
  
  public func findMissing(from: W3WMarkerList) -> [W3WMapMarker] {
    // Build a set of IDs from the 'from' list for fast lookup
    let fromIDs: Set<Int64> = Set(from.markers.compactMap { $0.bounds?.id })
    
    // Return all squares in self that do not exist in the 'from' list
    let missing = markers.filter { square in
      guard let id = square.bounds?.id else { return false }
      return fromIDs.contains(id) == false
    }
    
    return missing.map { [weak self] square in return W3WMapMarker(square: square, color: self?.color ?? W3WPresetMarkers.defaultMarkerColor, type: self?.type ?? W3WPresetMarkers.defaultMarkerType) }
  }
  
  
  public func findAllOccurancesOf(square: W3WSquare) -> W3WMarkerList? {
    var list = W3WMarkerList()
    list.color = color
    list.type = type
    
    var found = false
    for s in markers {
      if let sBoundsId = s.bounds?.id, let squareBoundsId = square.bounds?.id {
        if sBoundsId == squareBoundsId {
          list.markers.append(s)
          found = true
        }
      }
    }
    
    if found {
      return list
    } else {
      return nil
    }
  }

  
  /// as a string
  public var description: String {
    var retval = ""
    
    if let c = color {
      retval += "(\(c.description)) "
    }
    
    for marker in markers {
      retval += "\(marker.description), "
    }
    
    return retval.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: CharacterSet(charactersIn: ","))
  }
  
  /// Returns an array of all W3WSquare markers in the marker list.
  ///
  /// Since the markers property is internal to the W3WMarkerList class package,
  /// this method provides public access to the markers collection.
  ///
  /// - Returns: An array of W3WSquare objects representing all markers in the list.
  ///           Returns an empty array if no markers are present.
  ///
  /// - Example:
  ///   ```swift
  ///   let markerList = W3WMarkerList()
  ///   let squares = markerList.getMarkers()
  ///
  ///   for square in squares {
  ///       // Work with each W3WSquare marker
  ///       mapHelper.addMarker(at: square)
  ///   }
  ///   ```
  
  public func getmarkers() -> [W3WSquare] {
    return markers
  }

  
}

