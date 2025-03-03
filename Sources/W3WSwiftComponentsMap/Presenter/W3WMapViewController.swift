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
open class W3WMapViewController: W3WViewController, W3WEventSubscriberProtocol {
  public var subscriptions = W3WEventsSubscriptions()
  
  /// keeps a reference to objects to keep them alive and release them on destruction
  var keepAlive = [Any?]()

  /// convenience accessor for the map view
  public var mapView: W3WMapViewProtocol?
  
  
  /// Holds an interchangable map view
  public init(view: W3WMapViewProtocol, theme: W3WLive<W3WTheme?>? = nil, keepAlive: [Any?] = []) {
    self.keepAlive = keepAlive
    
    super.init(theme: theme?.value)
    
    subscribe(to: theme) { [weak self] theme in
      self?.handle(theme: theme)
    }

    // set the initial map view
    set(mapView: view)
  }
  
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  /// sets a map type for this view controller
  public func set(mapType: W3WMapType) {
    mapView?.set(type: mapType)
  }

  
  /// gets the map type for this view controller
  public func getMapType() -> W3WMapType {
    return mapView?.getType() ?? "Unknown"
  }

  
  /// gets the map scale
  public func getMapScale() -> W3WMapScale? {
    return mapView?.getCameraState().scale
  }


  /// sets a map view for this view controller
  open func set(mapView: W3WMapViewProtocol) {
    let mapCamera = self.mapView?.getCameraState() ?? mapView.getCameraState()
    
    // transfer the viewModel from the current view to the new one
    if let oldVm = self.mapView?.viewModel {
      mapView.set(viewModel: oldVm)
    }

    // if there is already a map there, then fade the new one in
    if let currentMap = self.mapView {
      self.mapView = mapView
      mapView.alpha = 0.0
      self.view.insertSubview(mapView, aboveSubview: currentMap)
      UIView.animate(withDuration: W3WDuration.defaultAnimationSpeed.seconds, animations: {
        mapView.alpha = 1.0
      }, completion: { success in
        currentMap.removeFromSuperview()
      })
      
    // if this is the first map then just plop it into place
    } else {
      self.mapView = mapView
      
      // set the view to the new map view
      self.view.addSubview(mapView)
      view.sendSubviewToBack(mapView)
    }
    
    //if let camera = mapCamera {
      mapView.viewModel.input.camera.send(mapCamera)
    //}
  }
  
  
  // MARK: Event Handlers
  
  
  open func handle(theme: W3WTheme?) {
    set(theme: theme)
    mapView?.set(scheme: theme?.mapScheme())
  }
  
  
  override open func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    mapView?.frame = view.bounds
  }
  
}
