//
//  DataLoader.swift
//  ParkAid
//
//  Created by Fabian Vistorin on 09.07.20.
//  Copyright © 2020 Pierre Sucker. All rights reserved.
//

import Foundation

public class DataLoader {
    
    @Published var parkhausDaten = [ParkhausDaten]()
    
    init() {
        load()
     
    }
    
    func load() {
        
        if let fileLocation = Bundle.main.url(forResource: "Parkhaus", withExtension: "json") {
            
           
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([ParkhausDaten].self, from: data)
                
                self.parkhausDaten = dataFromJson
            } catch {
                print(error)
            }
        }
    }
    
    
}
