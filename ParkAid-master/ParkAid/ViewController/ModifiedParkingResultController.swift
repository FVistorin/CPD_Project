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

class ModiefiedParkingResultController:UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    var timer: Timer?
    var parkingHours: Int = 0
    var parkingMins: Int = 0
    var parkingSecs: Int = 0
    
    var parkingTimeInSecs: Int?
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    var parkingPosition: CLLocation?
    let locationManager = CLLocationManager()
    
    
    var parkingSpot: ParkingSpot?
    var parkingTime: Int?
   
    func setModifiedParkingResultVC(spot: ParkingSpot, parkingTime: Int){
        self.parkingSpot = spot
        self.parkingTime = parkingTime
        
        parkingTimeInSecs = parkingTime * 3600
        
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
        
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SetTimer), userInfo: nil, repeats: true)
    }
    
    func zoomAndCenter() {
        let defaultGPS = CLLocation(latitude: 51.682401, longitude: 7.840312)
        var span: MKCoordinateSpan = mapView.region.span
        span.latitudeDelta /= 700
        span.longitudeDelta /= 700
        let region = MKCoordinateRegion(center: parkingSpot?.coordinates?.coordinate ?? defaultGPS.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func setPlacemark(){
        let defaultGPS = CLLocation(latitude: 51.682401, longitude: 7.840312)
        let place = MKPlacemark(coordinate: parkingSpot?.coordinates?.coordinate ?? defaultGPS.coordinate, addressDictionary: nil)
        mapView.addAnnotation(place)
    }
    
    @objc func SetTimer() {
        parkingTimeInSecs!-=1
        
        parkingHours = parkingTimeInSecs! / 3600
        parkingMins = parkingTimeInSecs! / 60 - parkingHours*60
        parkingSecs = parkingTimeInSecs! - parkingHours*3600 - parkingMins * 60
        
        
    
    
        timerLabel.text = "\(parkingHours)" + ":\(parkingMins)" + ":\(parkingSecs)"
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToModifiedParkingResult" {
           var BuyTicketVC = ((segue.destination) as! BuyTicketController)
            BuyTicketVC.setBuyTicketVC(spot: parkingSpot!)
        }
   

        
   

    
    }
    
    
}
    
    
       


    

    

