//
//  RoutingViewController.swift
//  ParkAid
//
//  Created by Pierre Sucker on 15.07.20.
//  Copyright © 2020 Pierre Sucker. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class RoutingViewController: UIViewController, CLLocationManagerDelegate,  MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    var route: MKRoute?
    var routes: [MKRoute]?
    var destinationPlace: MKPlacemark?
    let locationManager = CLLocationManager()
    
    var ARNavigationVC: ARNavigationViewController = ARNavigationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
           
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled  = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        let sourcePlace = MKPlacemark(coordinate: locationManager.location!.coordinate)
        
        mapView.addAnnotation(destinationPlace!)
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlace)
        directionRequest.destination = MKMapItem(placemark: destinationPlace!)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionsResponse = response else {
                if let error = error {
                    print("error getting directions \(error.localizedDescription)")
                }
                return
            }
            
            self.route = directionsResponse.routes[0]
            self.routes = directionsResponse.routes
            self.mapView.addOverlay(self.route!.polyline, level:.aboveRoads)
            
            let rect = self.route!.polyline.boundingMapRect
            
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        self.mapView.delegate = self
    }
    
    func setDestinationPlace(desPos: CLLocationCoordinate2D){
        self.destinationPlace = MKPlacemark(coordinate: desPos)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToARNavigation" {
            var ARNavigationVC = (segue.destination as! ARNavigationViewController)
            ARNavigationVC.setRoute(route: routes!)
        }
             
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
}

