//
//  MapViewController.swift
//  ParkAid
//
//  Created by Pierre Sucker on 27.04.20.
//  Copyright © 2020 Pierre Sucker. All rights reserved.
//

import UIKit
import MapKit



class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var switchSort: UISwitch!
    var dataLoader = DataLoader()
    let locationManager = CLLocationManager()

    var list:[ParkingSpot] = []
    
    var parkDetailsVC = ParkdetailsController()
    
    override func loadView() {
        super.loadView()
        
    }       
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //locationManager.startUpdatingLocation()
        }
        
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled  = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        let span = MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        self.tableView.reloadData()
        GenerateParkingSpots()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
            self.addMarkerToMap()
            self.mapView.zoomFitAllAnnotations()
        }
    }

   
    /// - Tag: ParkingSpot
    func GenerateParkingSpots(){
        for parkData in dataLoader.parkhausDaten {
            let spot = ParkingSpot(_name: parkData.Name, _adress:Adress(plz: parkData.PLZ, city: parkData.Stadt, street:parkData.Straße), _openingTime: parkData.Öffnungszeit, _closingTime: parkData.Schließzeit, _price: parkData.Kosten, _pictureString: parkData.Bild, _disabled: parkData.Behindertenparkplatz, _electric: parkData.Elektroladestation, _woman: parkData.Frauenparkplatz)
            list += [spot]
        }
        SortByDistance()
    }
    
    func SortByDistance(){
        list.sort{$0.distanceToGPS < $1.distanceToGPS}
    }
    
    func SortByPrice(){
        list.sort{$0.priceInCent < $1.priceInCent}
    }
    
    func addMarkerToMap(){
        for parkingspot in list {
            let anno = MKPointAnnotation()
            anno.coordinate = parkingspot.coordinates!.coordinate
            anno.title = "\(parkingspot.name!)"
            mapView.addAnnotation(anno)
        }
    }
    
        /// - Tag: Switch
    @IBAction func switchDidChange(sender: UISwitch){
        if sender.isOn {
            SortByDistance()
            self.tableView.reloadData()
            
        }
        else {
            SortByPrice()            
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "segueToParkDetails" {
              parkDetailsVC = (segue.destination) as! ParkdetailsController
              parkDetailsVC.mapVC = self
          }
      }

    
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return list.count
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
      
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleCell", for: indexPath) as? ParkingSpotTableViewCell else {
              return UITableViewCell()
           }
       cell.name.text = list[indexPath.row].name
        
       cell.price.text = String(list[indexPath.row].priceInEuro) + " Euro"
           
       var distance = list[indexPath.row].distanceToGPS
        if(distance<1000){
            round(distance)
            let distanceInt:Int = Int(distance)
            cell.distance.text = String(distanceInt) + " m"
        } else {
            distance=distance/1000
            distance = Double(round(100*distance)/100)
            cell.distance.text = String(distance) + " km"
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        parkDetailsVC.setParkDetailsVC(spot: list[indexPath.row])

    }
}
extension MKMapView {
    
    func zoomFitAllAnnotations() {
        var zoomRect = MKMapRect.null;
        for annotation in annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01);
            zoomRect = zoomRect.union(pointRect);
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
    }
}
