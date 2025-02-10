//
//  File.swift
//  
//
//  Created by Dave Duprey on 01/11/2024.
//

import W3WSwiftCore
import W3WSwiftAppEvents


public enum W3WMapOutputEvent: W3WAppEventConvertable {
  
  case selected(W3WSquare)
  case camera(W3WMapCamera)
  case error(W3WError)

  
  public func asAppEvent() -> W3WAppEvent {
    switch self {
      case .selected(let square): return W3WAppEvent(type: Self.self, name: .squareSelected, parameters: ["selected": .square(square)])
      case .camera(let camera): return W3WAppEvent(type: Self.self, name: "camera", parameters: ["camera": .text(camera.description)])
      case .error(let error): return W3WAppEvent(type: Self.self, name: "error", parameters: [.error(error)])
    }
  }

}
