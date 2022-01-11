//
//  PHaus.swift
//  ParkAid
//
//  Created by Fabian Vistorin on 09.07.20.
//  Copyright © 2020 Pierre Sucker. All rights reserved.
//

import Foundation


struct ParkhausDaten: Codable {
    
    var id : String
    var Name: String
    var Stadt: String
    var Straße: String
    var PLZ: Int
    var Öffnungszeit: String
    var Schließzeit: String
    var Kosten: Double
    var Kapazität: Int
    var Frauenparkplatz: Bool
    var Behindertenparkplatz: Bool
    var Elektroladestation: Bool
    var Bild: String
 
    }
     

