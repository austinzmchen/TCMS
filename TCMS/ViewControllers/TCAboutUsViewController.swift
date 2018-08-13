//
//  TCAboutUsViewController.swift
//  TCMS
//
//  Created by Austin Chen on 2018-04-18.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import UIKit
import MapKit

class TCAboutUsViewController: UIViewController, TCDrawerItemViewControllerType {
    
    @IBAction func leftBarButtonTapped(_ sender: Any) {
        viewDelegate?.didTriggerToggleButton()
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var containerView: UIView!
    
    var state: State = .collapsed
    var progressWhenInterrupted: CGFloat = 0
    
    var viewDelegate: TCDrawerMasterViewControllerDelegate?
    private var animatorDelegate: InteractiveAnimatorDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mapView.setCenter(, animated: true)
        let kTcmsCoord2D = CLLocationCoordinate2D(latitude: 43.851386, longitude: -79.384842)
        
        let annotation = MKPointAnnotation()
        let centerCoordinate = kTcmsCoord2D
        annotation.coordinate = centerCoordinate
        annotation.title = "ArtMind Dance Studio"
        mapView.addAnnotation(annotation)
        
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = kTcmsCoord2D
        mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        mapView.setRegion(mapRegion, animated: true)
        
        mapView.setVisibleMapRect(MKMapRectForCoordinateRegion(region: mapRegion), edgePadding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 200.0, right: 0.0), animated: true)

        // interactive pan
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(recognizer:)) )
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned(recognizer:)) )
        containerView.addGestureRecognizer(tapGesture)
        containerView.addGestureRecognizer(panGesture)
        
        animatorDelegate = InteractiveAnimatorDelegate(owner: self)
        view.addSubview(containerView)
        layoutContainerView(state: .collapsed)
        
        blurView.effect = nil
    }
    
    var containerConstants: (minX: CGFloat, minY: CGFloat, maxY: CGFloat, height: CGFloat)
        = (minX: 10, minY: 120, maxY: 450, height: 450)
    
    func layoutContainerView(state: State) {
        switch state {
        case .expanded:
            var f = containerView.frame
            f.origin = CGPoint(x: containerConstants.minX,
                               y: view.bounds.height - containerConstants.maxY)
            f.size.width = view.bounds.width - 2 * containerConstants.minX
            containerView.frame = f
        case .collapsed:
            var f = containerView.frame
            f.size = CGSize.init(width: view.bounds.width,
                                 height: containerConstants.height)
            f.origin = CGPoint.init(x: 0,
                                    y: view.bounds.height - containerConstants.minY)
            containerView.frame = f
        }
    }
    
    func MKMapRectForCoordinateRegion(region:MKCoordinateRegion) -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))
        
        let a = MKMapPointForCoordinate(topLeft)
        let b = MKMapPointForCoordinate(bottomRight)
        
        return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
    }
    
    
    // MARK: non-interactive
    @objc func tapped(recognizer: UITapGestureRecognizer) {
        animatorDelegate.animateOrReverseRunningTransition(state: state.nextState, duration: kDuration)
    }
    
    // MARK: interactive
    @objc func panned(recognizer: UIPanGestureRecognizer) {
        let t = recognizer.translation(in: view)
        var r = t.y / view.bounds.height
        
        switch recognizer.state {
        case .began:
            animatorDelegate.startInteractiveTransition(state: state.nextState, duration: kDuration)
        case .changed:
            r = state.nextState == .expanded ? -r : r
            animatorDelegate.updateInteractiveTransition(fractionComplete: r + progressWhenInterrupted)
        case .ended:
            let cancel = abs(r) < 0.2
            animatorDelegate.continueInteractiveTransition(cancel: cancel)
        default:
            break
        }
    }
}

let kDuration: Double = 0.7

enum State {
    case expanded
    case collapsed
    
    var nextState: State {
        switch self {
        case .expanded:
            return .collapsed
        case .collapsed:
            return .expanded
        }
    }
}
