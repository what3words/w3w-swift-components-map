//
//  File.swift
//  
//
//  Created by Dave Duprey on 25/01/2025.
//

import UIKit
import CoreLocation
import W3WSwiftCore
import W3WSwiftDesign
import W3WSwiftComponentsMap


public class W3WBlankMapView: W3WView, W3WMapViewProtocol, W3WEventSubscriberProtocol {
  public var subscriptions = W3WEventsSubscriptions()
  
  public var viewModel: W3WMapViewModelProtocol
  
  public var types: [W3WMapType] = [.standard]
  
  public var transitionScale = W3WMapScale(pointsPerMeter: 4.0)
  
  var camera: W3WMapCamera = W3WMapCamera()
  
  
  public init(viewModel: W3WMapViewModelProtocol) {
    self.viewModel = viewModel
    
    super.init(scheme: .standard.with(background: .powderBlue))
    
    subscribe(to: viewModel.input.camera) { [weak self] camera in
      if let camera = camera {
        self?.camera = camera
      }
    }
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  public func set(viewModel: W3WMapViewModelProtocol) {
    self.viewModel = viewModel
  }
  
  
  public func getCameraState() -> W3WMapCamera {
    //return self.camera
    let coords = CLLocationCoordinate2D(latitude: 51.520847000000003, longitude: -0.195521)
    return W3WMapCamera(center: coords, scale: .standardZoom)
  }
  
  
  public func set(type: String) {
  }
  
  
  override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    viewModel.w3w.convertToCoordinates(words: "filled.count.soap") { [weak self] square, error in
      if let square = square {
        self?.viewModel.output.send(.selected(square))
        self?.viewModel.output.send(.camera(W3WMapCamera(scale: .standardZoom)))
      }
    }
  }

  
//  func makeCamera() -> W3WMapCamera {
//    w3w.convertToCoordinates(words: "filled.count.soap") { [weak self] square, error in
//      if let square = square {
//        return W3WMapCamera(center: square.coordinates, scale: W3WMapScale(pointsPerMeter: 4.0))
//      }
//    }
//  }
  
}
