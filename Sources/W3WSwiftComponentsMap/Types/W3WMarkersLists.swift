//
//  File.swift
//  
//
//  Created by Dave Duprey on 04/12/2024.
//

import CoreLocation
import W3WSwiftCore
import W3WSwiftThemes


public class W3WMarkersLists: CustomStringConvertible {
  
  public var lists: [String: W3WMarkerList]
  
  var defaultColour: W3WColor

  public var defaultName = "default"

  
  /// a named, coloured, group of markers
  public init(lists: [String: W3WMarkerList]? = nil, defaultColor: W3WColor = .red) {
    self.lists = lists ?? [defaultName: W3WMarkerList()]
    self.defaultColour = defaultColor
  }

  
  public func getLists() -> [String: W3WMarkerList] {
    return lists
  }
  
  
  /// make a deep copy of the list
  public func copy() -> W3WMarkersLists {
    // Deep copy the container: create a new instance and copy each list
    let copiedLists: [String: W3WMarkerList] = self.lists.reduce(into: [:]) { result, entry in
      let (key, list) = entry
      result[key] = list.copy()
    }
    let copied = W3WMarkersLists(lists: copiedLists, defaultColor: self.defaultColour)
    copied.defaultName = self.defaultName
    return copied
  }

  
  public func allSquares() -> [W3WSquare] {
    var squares = [W3WSquare]()
    
    for (_, list) in lists {
      for square in list.markers {
        squares.append(square)
      }
    }
    
    return squares
  }
  
  
  public func findMissing(from: W3WMarkersLists) -> [W3WMapMarker] {
    var result: [W3WMapMarker] = []

    // Build a set of IDs from all squares in the 'from' lists for quick lookup
    let fromIDs: Set<Int64> = Set(from.allSquares().compactMap { $0.bounds?.id })

    // For each list in this container, ask the list to compute its missing squares
    for (_, list) in lists {
      // Create a lightweight list containing only the squares that are present in `from`
      // to use as the comparison base for this sublist
      let fromList = W3WMarkerList(color: list.color, type: list.type, markers: from.allSquares())

      // Use the list-level API to find missing squares compared to the `from` container
      // (Assumes W3WMarkerList.findMissing(from:) now returns [W3WMapMarker] or [W3WSquare].
      // We will compute missing here to preserve color/type if needed.)

      // Compute missing squares for this specific list by filtering against fromIDs
      let missingSquares = list.markers.filter { square in
        guard let id = square.bounds?.id else { return false }
        return fromIDs.contains(id) == false
      }

      // Map missing squares to W3WMapMarker, preserving this list's color and type
      let mapped: [W3WMapMarker] = missingSquares.map { square in
        W3WMapMarker(square: square, color: list.color ?? W3WPresetMarkers.defaultMarkerColor, type: list.type ?? W3WPresetMarkers.defaultMarkerType)
      }
      result.append(contentsOf: mapped)
    }

    return result
  }
  
  
  /// given a square, this returns all lists that contain that square with
  /// only occurances of that square in the list.  this is useful for
  /// operations that do unions or intersectoins of the lists
  public func findAllOccurancesOf(square: W3WSquare) -> W3WMarkersLists? {
    let markerLists = W3WMarkersLists()
    
    var found = false
    for (name, list) in lists {
      if let foundItems = list.findAllOccurancesOf(square: square) {
        markerLists.add(listName: name, list: foundItems)
        found = true
      }
    }
    
    if found {
      return markerLists
    } else {
      return nil
    }
  }
  
  
  /// add a marker list to these groups
  /// - Parameters:
  ///   - group: the name of the group to add
  ///   - color: the color for the group
  /// - Returns: true if added successfully, false if there is already a group named that
  @discardableResult public func add(listName: String, type: W3WMarkerType? = nil, color: W3WColor) -> Bool {
    if lists[listName] != nil {
      return false
    }
    
    lists[listName] = W3WMarkerList(color: color, type: type, markers: [])
    return true
  }

  
  /// remove a marker list from these groups
  /// - Parameters:
  ///   - group: the name of the group to add
  /// - Returns: true if removed successfully, false if there is no group named that
  @discardableResult public func remove(listName: String) -> Bool {
    guard let _ = lists[listName] else { return false }
    lists[listName] = nil
    return true
  }

  
  /// add a square to a group
  /// - Parameters:
  ///   - group: the name of the group to add to
  ///   - square: the square to add
  /// - Returns: true if added successfully, false if no such group exists
  @discardableResult public func add(square: W3WSquare, listName: String? = nil) -> Bool {
    if let list = lists[listName ?? defaultName] {
      list.markers.append(square)
      return true
      
    } else {
      return false
    }
  }
  
  
  /// add a list
  /// - Parameters:
  ///   - listName: the name of the group to add to
  ///   - list: the list to add
  /// - Returns: true if added successfully, false if no such group exists
  public func add(listName: String, list: W3WMarkerList) {
    lists[listName] = list
  }

  
  /// remove a square from a group
  /// - Parameters:
  ///   - group: the name of the group to add to
  ///   - square: the square to add
  /// - Returns: true if removed successfully, false if no such group exists, or square wasn't there
  @discardableResult public func remove(words: String, listName: String? = nil) -> Bool {
    let listName: String = listName ?? defaultName
    
    guard let _ = lists[listName] else { return false }
    guard let _ = lists[listName]?.markers.first(where: { s in s.words == words }) else { return false }
    lists[listName]?.markers.removeAll(where: { s in s.words == words })

    return true
  }

  
  /// remove a square from a group
  /// - Parameters:
  ///   - group: the name of the group to add to
  ///   - square: the square to add
  /// - Returns: true if removed successfully, false if no such group exists, or square wasn't there
  @discardableResult public func remove(coordinates: CLLocationCoordinate2D?, listName: String? = nil) -> Bool {
    let listName: String = listName ?? defaultName
    
    guard let _ = lists[listName] else { return false }
    guard let _ = lists[listName]?.markers.first(where: { s in s.coordinates?.latitude == coordinates?.latitude }) else { return false }
    lists[listName]?.markers.removeAll(where: { s in s.coordinates?.latitude == coordinates?.latitude })

    return true
  }

  
  /// remove a square from a group
  /// - Parameters:
  ///   - group: the name of the group to add to
  ///   - square: the square to add
  /// - Returns: true if removed successfully, false if no such group exists, or square wasn't there
  @discardableResult public func remove(square: W3WSquare, listName: String? = nil) -> Bool {
    if let words = square.words {
      return remove(words: words, listName: listName)

    } else if let coordinates = square.coordinates {
      return remove(coordinates: coordinates, listName: listName)

    } else {
      return false
    }
  }

  
  /// as a string
  public var description: String {
    var retval = ""
    
    for list in lists {
      retval += "[\(list.key): \(list.value)]\n"
    }
    
    return retval
  }

}

