//
//  SettingsController.swift
//  ParkAid
//
//  Created by Meik on 16.07.20.
//  Copyright © 2020 Pierre Sucker. All rights reserved.
//

import Foundation
import UIKit

class SettingsController:UIViewController{
    var reports = [Report].self
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    }
    

struct Report{
    var spot : ParkingSpot
    var parkingTimeString: String
    var amountString : String
}
