//
//  Parkdetails.swift
//  ParkAid
//
//  Created by Sara on 02.07.20.
//  Copyright © 2020 Pierre Sucker. All rights reserved.
//

import UIKit

class ParkdetailsController : UIViewController {

    @IBOutlet weak var smallImageLeft: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var smallImageMid: UIImageView!
    @IBOutlet weak var smallImageRight: UIImageView!
    @IBOutlet weak var name: UILabel!
    let spot: ParkingSpot
    
    init(coder: NSCoder, spot: ParkingSpot){
        
        self.spot = spot
        super.init(coder: coder)!
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetDetails()
    }   
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    

    
    

    func SetDetails(){
       // name.text=spot.name!
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
