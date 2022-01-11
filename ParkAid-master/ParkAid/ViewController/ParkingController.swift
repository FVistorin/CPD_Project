//
//  ParkingController.swift
//  ParkAid
//
//  Created by Meik on 07.07.20.
//  Copyright © 2020 Pierre Sucker. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class ParkingController:UIViewController, CLLocationManagerDelegate, UITextFieldDelegate{

    @IBOutlet weak var priceTextField: UITextField!
    var ParkingResultVC: ParkingResultController = ParkingResultController()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToParkingResult"{
            ParkingResultVC = (segue.destination) as! ParkingResultController
            ParkingResultVC.parkVC = self
            
            let manager = CLLocationManager()
            //set location to gps?
            let positionx=manager.location ?? CLLocation(latitude: 51.682401, longitude: 7.840312)
            let priceString : String = priceTextField.text ?? "0.00"
            let pricex:Double = priceString.toDouble()!
            ParkingResultVC.setParkDetailsVC(position: positionx, price: pricex)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceTextField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        priceTextField.keyboardType = UIKeyboardType.decimalPad
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
    
    

