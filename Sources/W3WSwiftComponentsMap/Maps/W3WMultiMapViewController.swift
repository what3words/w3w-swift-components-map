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
  
  /// keeps a reference to objects to keep them alive and release them on destruction
  var keepAlive: [Any?]

  /// convenience accessor for the map view
  var mapView: W3WMapViewProtocol? {
    return view as? W3WMapViewProtocol
  }
  
  
  /// Holds an interchangable map view
  public init(view: W3WMapViewProtocol, sdk: W3WProtocolV4, keepAlive: [Any?] = []) {
    self.sdk = sdk
    self.keepAlive = keepAlive
    
    super.init()

    // set the initial map view
    set(mapView: view)
  }
  
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  /// sets a map view for this view controller
  func set(mapView: W3WMapViewProtocol) {

    // transfer the viewModel from the current view to the new one
    if let oldVm = self.mapView?.viewModel {
      mapView.set(viewModel: oldVm)
    }
    
    // set the view to the new map view
    self.view = mapView
  }
  
}
