//
//  File.swift
//  
//
//  Created by Dave Duprey on 19/10/2024.
//

import UIKit
import CoreLocation
import W3WSwiftCore
import W3WSwiftThemes
import W3WSwiftDesign


/// Holds an interchangable map view
open class W3WMultiMapViewController: W3WViewController, W3WEventSubscriberProtocol {
  public var subscriptions = W3WEventsSubscriptions()
  
  /// the sdk
  var sdk: W3WProtocolV4

  /// the view model to any W3WMapViewProtocol conforming map view
  var viewModel: W3WMapViewModelProtocol

  
  /// Holds an interchangable map view
  public init(view: W3WMapViewProtocol, viewModel: W3WMapViewModelProtocol, sdk: W3WProtocolV4) {
    self.viewModel = viewModel
    self.sdk = sdk

    super.init()

    // set the initial map view
    set(mapView: view)
  }
  
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  /// sets a map view for this view controller
  func set(mapView: W3WMapViewProtocol) {
    self.view = mapView
    mapView.set(viewModel: viewModel)
  }
  
}
