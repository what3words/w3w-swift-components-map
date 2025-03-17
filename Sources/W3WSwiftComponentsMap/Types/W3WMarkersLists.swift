//
//  File.swift
//  
//
//  Created by Dave Duprey on 04/12/2024.
//

import W3WSwiftCore
import W3WSwiftThemes


public class W3WMarkersLists: CustomStringConvertible {
  
  var lists: [String: W3WMarkerList]
  
  var defaultColour: W3WColor

  var defaultName = "default"

  
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
  @discardableResult public func remove(square: W3WSquare, listName: String) -> Bool {
    guard let _ = lists[listName] else { return false }
    guard let _ = lists[listName]?.markers.first(where: { s in s.coordinates?.latitude == square.coordinates?.latitude }) else { return false }
    lists[listName]?.markers.removeAll(where: { s in s.coordinates?.latitude == square.coordinates?.latitude })
    return true
  }
  
  
  /// as a string
  public var description: String {
    var retval = ""
    
    for list in lists {
      retval += "[\(list.key): \(list.value)]\n"
    }
    
    return retval
  }
  
  /// Returns a dictionary of all marker lists indexed by their names.
  ///
  /// Use this method to access all marker lists stored in the W3WMarkersLists instance.
  /// Each list contains markers and associated settings like color.
  ///
  /// - Returns: A dictionary where the key is the list name (String) and the value is the corresponding W3WMarkerList.
  ///           The dictionary includes the default list with key "default" if no other lists were added.
  ///
  /// - Example:
  ///   ```
  ///   let markerLists = W3WMarkersLists()
  ///   let allLists = markerLists.getLists()
  ///
  ///   // Access the default list
  ///   if let defaultList = allLists["default"] {
  ///       // Work with default list markers
  ///   }
  ///   ```
  public func getLists() -> [String: W3WMarkerList] {
    return lists
  }

}
