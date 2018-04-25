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
    var viewDelegate: TCDrawerMasterViewControllerDelegate?
    
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
        
        mapView.setVisibleMapRect(MKMapRectForCoordinateRegion(region: mapRegion), edgePadding: UIEdgeInsetsMake(0.0, 0.0, 200.0, 0.0), animated: true)

    }
    
    func MKMapRectForCoordinateRegion(region:MKCoordinateRegion) -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))
        
        let a = MKMapPointForCoordinate(topLeft)
        let b = MKMapPointForCoordinate(bottomRight)
        
        return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
    }
    
}
