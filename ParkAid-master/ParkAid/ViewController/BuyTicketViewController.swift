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

class BuyTicketController:UIViewController{
    
    
    var hours:Double=1
    var price:Double?
    
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var modifiedParkingResultController: ModiefiedParkingResultController?
    var parkingSpot: ParkingSpot?
    
        
    @IBAction func HoursDown(_ sender: Any) {
        if(hours>1){
            hours = hours - 1
        }        
        hoursLabel.text = "\(hours)"
        SetPrice()
    }
    @IBAction func HoursUp(_ sender: Any) {
        hours = hours + 1
        hoursLabel.text = "\(hours)"
        SetPrice()
    }
    
    
    func setBuyTicketVC(spot: ParkingSpot){
        self.parkingSpot = spot
        self.price = spot.priceInEuro
    }
    
    func SetPrice(){
        let amount = hours*price!
        priceLabel.text = "\(amount) €"
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        SetPrice()
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToModifiedParkingResult" {
           modifiedParkingResultController = ((segue.destination) as! ModiefiedParkingResultController)
            modifiedParkingResultController?.setModifiedParkingResultVC(spot: parkingSpot!, parkingTime: Int(hours))
        }
    }
    
    
       
}

    

    

