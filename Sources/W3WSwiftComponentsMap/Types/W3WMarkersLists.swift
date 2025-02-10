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
  
  var lists: [String: W3WMarkerList]
  
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
  
  
  /// add a marker list to these groups
  /// - Parameters:
  ///   - group: the name of the group to add
  ///   - color: the color for the group
  /// - Returns: true if added successfully, false if there is already a group named that
  @discardableResult public func add(listName: String, color: W3WColor) -> Bool {
    if lists[listName] != nil {
      return false
    }
    
    lists[listName] = W3WMarkerList(color: color, markers: [])
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
