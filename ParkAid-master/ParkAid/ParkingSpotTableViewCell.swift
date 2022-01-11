//
//  ParkingSpotTableViewCell.swift
//  ParkAid
//
//  Created by Meik on 06.07.20.
//  Copyright © 2020 Pierre Sucker. All rights reserved.
//

import UIKit

class ParkingSpotTableViewCell: UITableViewCell {


    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var imagex: UIImageView!
    @IBOutlet weak var preisProStunde: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    

   

}
