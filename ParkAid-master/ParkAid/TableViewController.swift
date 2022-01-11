//
//  TableView.swift
//  ParkAid
//
//  Created by Pierre Sucker on 06.07.20.
//  Copyright © 2020 Pierre Sucker. All rights reserved.
//

import UIKit
import Foundation

class TableViewController: UITableView {
   
    
    
    var list:[ParkingSpot] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        tblView.register(UITableViewCell.self, forCellReuseIdentifier: "ExampleCell")
        tableView.delegate = self
        tableView.dataSource = self
        GenerateParkingSpots()
    }


    
}

extension TableViewController: UITableViewDataSource, UITableViewDelegate{
    

    
}






