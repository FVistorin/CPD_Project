//
//  Parkdetails.swift
//  ParkAid
//
//  Created by Sara on 02.07.20.
//  Copyright © 2020 Pierre Sucker. All rights reserved.
//

import UIKit

class ParkdetailsController : UIViewController {

   
    @IBOutlet weak var MainImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var openTime: UILabel!
    @IBOutlet weak var electric: UIImageView!
     @IBOutlet weak var woman: UIImageView!
     @IBOutlet weak var disabled: UIImageView!
    
    
    var mapVC: MapViewController?
    var spot: ParkingSpot!
    
    var BuyTicketVC: BuyTicketController?
    var RoutingVC: RoutingViewController?
    
    func setParkDetailsVC(spot: ParkingSpot) {
        self.spot = spot
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetDetails()
    }
    
    func SetDetails(){
        name.text = spot.name
        adress.text=spot.adress.street + String(", ") + String(spot.adress.plz) + String(" ") + spot.adress.city
        openTime.text = spot.openingTime + String(" - ") + spot.closingTime
        SetBase64()
        if(spot.electric==true){
            electric.image = UIImage(named: "elektro_true")} else{
            electric.image = UIImage(named: "")
        }
        if(spot.woman==true){
            woman.image = UIImage(named: "woman_true")} else{
            woman.image = UIImage(named: "")
        }
        if(spot.disabled==true){
            disabled.image = UIImage(named: "disable_true")} else{
            disabled.image = UIImage(named: "")
        }
    }
        
        
    
    func SetBase64(){
        
        let stringx = spot.pictureString
        let decodedData = NSData(base64Encoded: stringx, options: [])
        let image = UIImage(data: decodedData! as Data)
       
         MainImage.image = image
     
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToBuyTicket" {
            BuyTicketVC = ((segue.destination) as! BuyTicketController)
            BuyTicketVC!.setBuyTicketVC(spot: spot!)
        }else if segue.identifier == "segueToRouting" {
            RoutingVC = (segue.destination as! RoutingViewController)
            RoutingVC?.setDestinationPlace(desPos: spot.coordinates!.coordinate)
            //RoutingVC?.setParkingSpot(spot: spot!)
        }
             
    }
       
}
