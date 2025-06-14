//
//  File.swift
//  
//
//  Created by Dave Duprey on 03/12/2024.
//

import MapKit
import W3WSwiftCore
import W3WSwiftDesign

#if canImport(W3WSwiftCoreSdk)
import W3WSwiftCoreSdk
#endif


public class W3WDebugMapView: W3WView, W3WMapViewProtocol, W3WEventSubscriberProtocol {
  
  public var subscriptions = W3WEventsSubscriptions()
  
  public var viewModel: W3WMapViewModelProtocol
  
  public var types: [W3WMapType] { get { return ["Muted Standard"] } }

  /// the point at which annotations turn into overlay drawing when zoomed closer into
  public var transitionScale = W3WMapScale(pointsPerMeter: 4.0)
  
  var mapView = MKMapView(frame: .w3wWhatever)
  
  var selected  = W3WLabel(scheme: .w3w.with(border: .lightBlue, thickness: 0.5))
  var markers   = W3WLabel(scheme: .w3w.with(border: .lightBlue, thickness: 0.5))
  var hovered   = W3WLabel(scheme: .w3w.with(border: .lightBlue, thickness: 0.5))
  var mapCamera = W3WLabel(scheme: .w3w.with(border: .lightBlue, thickness: 0.5))
  var errors    = W3WLabel(scheme: .w3w.with(border: .lightBlue, thickness: 0.5))
  var mapKind   = W3WLabel(scheme: .w3w.with(border: .lightBlue, thickness: 0.5))

  
  public init(viewModel: W3WMapViewModelProtocol) {
    self.viewModel = viewModel
    super.init(scheme: .w3w)
    configure()
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
 
  
  func configure() {
    set(viewModel: viewModel)

    addSubview(mapView)
    
    selected.numberOfLines = 1
    hovered.attributedText = "Selected:".w3w.style(color: .mediumGrey).asAttributedString()
    selected.set(position: .absolute(x: 32.0, y: 192.0, width: 300.0, height: 24.0)) //.center(size: CGSize(width: 320.0, height: 32.0)))
    addSubview(selected)
    
    hovered.numberOfLines = 0
    hovered.attributedText = "Hovered:".w3w.style(color: .mediumGrey).asAttributedString()
    hovered.set(position: .place(below: selected, height: 24.0))
    addSubview(hovered)

    markers.numberOfLines = 0
    markers.attributedText = "Markers:".w3w.style(color: .mediumGrey).asAttributedString()
    markers.set(position: .place(below: hovered, height: 48.0))
    addSubview(markers)

    mapCamera.numberOfLines = 0
    mapCamera.attributedText = "Camera:".w3w.style(color: .mediumGrey).asAttributedString()
    mapCamera.set(position: .place(below: markers, height: 48.0))
    addSubview(mapCamera)

    errors.numberOfLines = 0
    errors.set(position: .place(below: mapCamera, height: 48.0))
    addSubview(errors)
    
    mapKind.numberOfLines = 0
    mapKind.attributedText = "Map Type:".w3w.style(color: .mediumGrey).asAttributedString()
    mapKind.set(position: .place(below: errors, height: 24.0))
    addSubview(mapKind)
  }
  
  
  func bind() {
    subscribe(to: viewModel.mapState.selected) { [weak self] square in
      self?.handle(selected: square)
    }
    subscribe(to: viewModel.mapState.markers) { [weak self] markers in
      self?.handle(markers: markers)
    }
    subscribe(to: viewModel.mapState.hovered) { [weak self] square in
      self?.handle(hovered: square)
    }
    subscribe(to: viewModel.mapState.camera) { [weak self] camera in
      self?.handle(mapCamera: camera)
    }
    //subscribe(to: viewModel.mapState.scheme) { [weak self] scheme in
    //  self?.set(scheme: scheme)
    //  self?.selected.set(scheme: scheme?.with(border: .lightBlue, thickness: 0.5))
    //  self?.hovered.set(scheme: scheme?.with(border: .lightBlue, thickness: 0.5))
    //  self?.markers.set(scheme: scheme?.with(border: .lightBlue, thickness: 0.5))
    //  self?.mapCamera.set(scheme: scheme?.with(border: .lightBlue, thickness: 0.5))
    //}
    //subscribe(to: viewModel.mapState.error) { [weak self] error in
    //  self?.handle(error: error)
    //}
    
    //viewModel.mapState.error.send(W3WError.message("Error: Ha ha ha"))
  }
 
  
  // MARK: Accessors
  
  
  public func set(viewModel: W3WMapViewModelProtocol) {
    self.viewModel = viewModel
    bind()
  }
 
  
  public func set(type: String) {
    self.mapKind.attributedText = ("Map type: ".w3w.style(color: .mediumGrey) + W3WString(type.description)).asAttributedString()
    mapView.mapType = .mutedStandard
  }

  
  public func getType() -> W3WMapType {
    return types.first ?? "Unknown"
  }
  

  public func getCameraState() -> W3WMapCamera {
    return W3WMapCamera()
  }
  
  
  // MARK: Event Handlers
  
  
  func handle(selected: W3WSquare?) {
    self.selected.attributedText = ("Selected: ".w3w.style(color: .mediumGrey) + W3WString(selected?.words ?? "").withSlashes()).asAttributedString()
  }
  
  
  func handle(markers: W3WMarkersLists) {
    var text = "Markers: {".w3w.style(color: .mediumGrey)
    text += markers.description.w3w
    text += "}".w3w.style(color: .mediumGrey)
    
    self.markers.attributedText = text.asAttributedString()
  }
  
  
  func handle(hovered: W3WSquare?) {
    self.selected.attributedText = ("Hovered: ".w3w.style(color: .mediumGrey) + W3WString(hovered?.words ?? "").withSlashes()).asAttributedString()
  }
  
  
  func handle(error: W3WError?) {
    var text = W3WString(errors.attributedText)
    text = (Date.timeIntervalBetween1970AndReferenceDate.description + ": " + (error?.description ?? "") + "\n").w3w + text
    errors.attributedText = text.asAttributedString()
  }
  
  
  func handle(mapCamera: W3WMapCamera?) {
    var text = "Camera: {\n".w3w.style(color: .mediumGrey)

    text += "\(mapCamera?.description ?? "")".w3w
    
    text += "\n}".w3w.style(color: .mediumGrey)

    self.mapCamera.attributedText = text.asAttributedString()
  }
  
  
  // MARK: Untilities
  
  
  public func pointFor(coordinate: CLLocationCoordinate2D) -> CGPoint {
    return mapView.convert(coordinate, toPointTo: nil)
  }
  
  public func coordinateFor(point: CGPoint) -> CLLocationCoordinate2D {
    return mapView.convert(point, toCoordinateFrom: nil)
  }
  
  
  // MARK: UIView overrides
  
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    updateView()
    
    mapView.frame = bounds
    
    // update all w3wview positions
    for subview in subviews {
      if let w3wview = subview as? W3WViewProtocol {
        w3wview.updateView()
      }
    }
  }

  
}
