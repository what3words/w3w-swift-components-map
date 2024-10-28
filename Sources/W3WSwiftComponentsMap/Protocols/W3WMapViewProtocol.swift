//
//  File.swift
//  
//
//  Created by Dave Duprey on 19/10/2024.
//

import UIKit


public protocol W3WMapViewProtocol: UIView {
  
  var types: [W3WMapType] { get }
  
  func set(viewModel: W3WMapViewModelProtocol)
  
  func set(type: String)
}
