//
//  File.swift
//  
//
//  Created by Dave Duprey on 01/11/2024.
//

import CoreLocation
import W3WSwiftCore


public enum W3WMapInputEvent {

  case center(W3WSquare, W3WMapScale?)
  case selected(W3WSquare?)
  case markers(W3WMarkersLists)
  
}
