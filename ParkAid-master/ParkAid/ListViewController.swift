//
//  ListViewController.swift
//  ParkAid
//
//  Created by Meik on 01.07.20.
//  Copyright © 2020 Pierre Sucker. All rights reserved.
//
import UIKit
import Foundation

class ListViewController: UITableViewController {
    
    var list:[ParkingSpot]! = []

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleCell", for: indexPath)
        cell.textLabel?.text=list[indexPath.row].name ?? "Parkhaus undefinded" + String(list[indexPath.row].priceInCents)
        print("set Text in TableViewCell")
        return cell
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        print("func viewDidLoad List")
        GenerateParkingSpots()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ExampleCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    func GenerateParkingSpots(){
        let spot1 = ParkingSpot(_name:"Parkhaus A",_adress:Adress(plz: 59063, city: "Hamm", street:"Marker Allee 76"), _openingTime:12, _closingTime: 22, _price: 220)
        let spot2 = ParkingSpot(_name:"Parkhaus B",_adress:Adress(plz: 44894, city: "Bochum", street:"Hauptstraße 44"), _openingTime:15, _closingTime: 16, _price: 120)
        print("generated Parking Spots (list)")
        list += [spot1, spot2]
        SortByPrice()
    }
    
    func SortByDistance(){
       list.sort{$0.distanceToGPS < $1.distanceToGPS}
        print("Sortiere nach entfernung")
    }
    func SortByPrice(){
        list.sort{$0.priceInCents < $1.priceInCents}
        print("Sortiere nach preis")
    }
    
}





