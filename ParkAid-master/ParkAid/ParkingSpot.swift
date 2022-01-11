//
//  ListViewController.swift
//  ParkAid
//
//  Created by Meik on 01.07.20.
//  Copyright © 2020 Pierre Sucker. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation


class ParkingSpot{
    let name:String?
    let adress:Adress
    let openingTime:String
    let closingTime:String
    let priceInEuro:Double
    let priceInCent:Int
    let disabled: Bool
    let electric:Bool
    let woman:Bool
    var workload:Double
    var distanceToGPS:Double = 0
    
    var coordinates:CLLocation?
    var latPos:Double=0
    var longPos:Double=0
    var isOpened:Bool
    var pictureString: String
    
    init(_name:String, _adress:Adress, _openingTime:String, _closingTime:String, _price:Double, _pictureString: String, _disabled: Bool, _electric: Bool, _woman: Bool){
        name=_name
        adress=_adress
        
        openingTime=_openingTime
        closingTime=_closingTime
        priceInEuro=_price
        priceInCent=Int(_price*100)
        disabled=_disabled
        electric=_electric
        woman=_woman
        workload=0
        //distanceToGPS=0
        
        pictureString=_pictureString
        isOpened=true
        CalculateDistance()
        
        //CheckIfParkingSpotIsOpened()
    }
    
    
    func RefreshWorkload(){
        //Get actual workload
    }

    func CalculateDistance(){
         
        let adressString = adress.street + String(", ") + String(adress.plz) + String(" ") + adress.city
        
        var placemark : CLPlacemark?
         
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(adressString) {
            placemarks, error in
            
                placemark = placemarks?.first
                self.latPos = Double((placemark?.location?.coordinate.latitude)!)
                self.longPos = Double((placemark?.location?.coordinate.longitude)!)
                self.coordinates = CLLocation(latitude: CLLocationDegrees(self.latPos), longitude: CLLocationDegrees(self.longPos))
                let manager = CLLocationManager()
                self.distanceToGPS = Double((self.coordinates?.distance(from:manager.location ?? CLLocation(latitude: 51.682401, longitude: 7.840312)))!)         
            
            
        }

     }
    
 //   func CheckIfParkingSpotIsOpened(){
  //      let nowDate = Date()
    //    let nowComponents = Calendar.current.dateComponents([.hour, .minute], from: nowDate)
      //  let now = nowComponents.date
        
     //   let opening = DateComponents(calendar: Calendar.current, timeZone:TimeZone(abbreviation: "GMT"), hour: openingTime, minute: 0)
      // let closing = DateComponents(calendar: Calendar.current, timeZone:TimeZone(abbreviation: "GMT"), hour: closingTime, minute: 0)
        
      //  if (now!.timeIntervalSince1970 >= opening.date!.timeIntervalSince1970 && now!.timeIntervalSince1970 <= closing.date!.timeIntervalSince1970){
        //    isOpened = true
          //  print("offen")
       // }else{
        //    isOpened = false
         //    print("zu")
       // }
        
   // }
    
}
struct Adress{
var plz:Int
var city:String
var street:String
}
