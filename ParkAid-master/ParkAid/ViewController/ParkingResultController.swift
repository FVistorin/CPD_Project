//
//  ParkingResultController.swift
//  ParkAid
//
//  Created by Meik on 08.07.20.
//  Copyright © 2020 Pierre Sucker. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Contacts

class ParkingResultController:UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    var parkVC: ParkingController?
    var RoutingVC: RoutingViewController = RoutingViewController()
    var timer: Timer?
    var parkingHours: Int = 0
    var parkingMins: Int = 0
    var parkingSecs: Int = 0
    @IBOutlet weak var timerLabel: UILabel!
    
    var price:Double?
    @IBOutlet weak var priceLabel: UILabel!
    
    
    
    var parkingPosition: CLLocation?
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var label: UILabel!
        
       
    
    func setParkDetailsVC(position: CLLocation, price: Double){
        self.parkingPosition = position
        self.price = price
    }

    @objc func SetTimer() {
        parkingSecs+=1
        if(parkingSecs==60){
            parkingMins+=1
            parkingSecs=0
            if (parkingMins==60){
                parkingHours+=1
                parkingMins=0
                SetAmount()
            }
        }
        timerLabel.text = "\(parkingHours)" + ":\(parkingMins)" + ":\(parkingSecs)"
        }
        
        
    func SetText(){
        label.text = "Position gespeichert"
    }
    
    func SetAmount(){
        let amount = Double(parkingHours+1)*price!
        priceLabel.text = "\(amount) €"
    }
    
        
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
           
        mapView.isZoomEnabled  = false
        mapView.isScrollEnabled = false
        
        mapView.showsUserLocation = true
        
        zoomAndCenter()
        setPlacemark()

        SetText()
    
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SetTimer), userInfo: nil, repeats: true)
        SetAmount()
    }

    func zoomAndCenter() {
        var span: MKCoordinateSpan = mapView.region.span
        span.latitudeDelta /= 700
        span.longitudeDelta /= 700
        let region = MKCoordinateRegion(center: parkingPosition!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    func setPlacemark(){
        var defaultGPS = CLLocation(latitude: 51.682401, longitude: 7.840312)
        let place = MKPlacemark(coordinate: parkingPosition!.coordinate ?? defaultGPS.coordinate, addressDictionary: nil)
        mapView.addAnnotation(place)
    }
        
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "segueToNavigationTwo" {
            RoutingVC = (segue.destination as! RoutingViewController)
            RoutingVC.setDestinationPlace(desPos: parkingPosition!.coordinate)
           }
    }
}
    

