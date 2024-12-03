//
//  File.swift
//  
//
//  Created by Dave Duprey on 19/10/2024.
//

import UIKit


public protocol W3WMapViewProtocol: UIView {
  
  var viewModel: W3WMapViewModelProtocol { get set }
  
  var types: [W3WMapType] { get }
  
  func set(viewModel: W3WMapViewModelProtocol)
  
  func set(type: String)
}


extension W3WMapViewProtocol {
  
  public func set(type: W3WMapType) {
    set(type: type.value)
  }
  
}
