//
//  File.swift
//  
//
//  Created by Dave Duprey on 10/12/2024.
//

import Foundation
import CoreLocation
import W3WSwiftCore
import W3WSwiftThemes


open class W3WMapComponent: W3WMultiMapViewController, W3WMapProtocol {

  var viewModel: W3WMapViewModelProtocol!
  
  // for W3WMapProtocol compliance
  public var w3w: W3WProtocolV4 {
    get { return viewModel.w3w }
    set { viewModel.w3w = newValue }
  }
  
  /// called when the user taps a square in the map
  public var onSquareSelected: (W3WSquare) -> () = { _ in }
  
  /// called when the user taps a square that has a marker added to it
  public var onMarkerSelected: (W3WSquare) -> () = { _ in }
  
  /// returns the error enum for any error that occurs
  public var onError: W3WErrorResponse = { _ in }

  
  public var state: any W3WMapStateProtocol {
    get { return viewModel.mapState }
    set { viewModel.mapState = newValue; bind() }
  }
  

  private override init(view: W3WMapViewProtocol, keepAlive: [Any?] = []) {
    super.init(view: view)
    viewModel = view.viewModel
    
    bind()
  }
  
  
  public init(w3w: W3WProtocolV4) {
    viewModel = W3WMapViewModel(w3w: w3w)
    let view = W3WOldAppleMapView(viewModel: viewModel)
    super.init(view: view)

    bind()
  }

  
  required public init?(coder: NSCoder) {
    viewModel = W3WMapViewModel(w3w: W3WDummyApi()) // instantiate with a fake API, and set the real one after to get around a catch-22
    let view = W3WOldAppleMapView(viewModel: viewModel)
    super.init(view: view)

    bind()
  }
  
  
  func bind() {
    subscribe(to: viewModel.output) { [weak self] event in
      self?.handle(event: event)
    }
    subscribe(to: viewModel.mapState.error) { [weak self] error in
      self?.handle(error: error)
    }
  }
  
  
  public func set(state: any W3WMapStateProtocol) {
    self.state = state
  }

  
  public func set(w3w: W3WProtocolV4) {
    viewModel.w3w = w3w
  }
  
  
  func handle(event: W3WMapOutputEvent) {
    switch event {
      case .selected(let square):
        onSquareSelected(square)
      
      case .marker(let square):
        onMarkerSelected(square)
    }
  }
  

  func handle(error: W3WError?) {
    if let e = error {
      onError(e)
    }
  }
  
  

}
