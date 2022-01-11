//
//  ARNavigationViewController.swift
//  ParkAid
//
//  Created by Pierre Sucker on 15.07.20.
//  Copyright © 2020 Pierre Sucker. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import MapKit
//Usage of open source library https://github.com/ProjectDent/ARKit-CoreLocation.git 
import ARKit_CoreLocation


class ARNavigationViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    let sceneLocationView = SceneLocationView()
    
    var routes: [MKRoute]?
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSceneModels()
        
        contentView.addSubview(sceneLocationView)
        sceneLocationView.frame = contentView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        sceneLocationView.run()
    }
    
    func setRoute(route: [MKRoute]){
        self.routes = route
    }
    
    func addSceneModels(){
        guard sceneLocationView.sceneLocationManager.currentLocation != nil else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in self?.addSceneModels()
            }
            return
        }
        
        if let routes = routes {
            sceneLocationView.addRoutes(routes: routes) { distance -> SCNBox in
                let box = SCNBox(width: 1.75, height: 0.5, length: distance, chamferRadius: 0.25)
                box.firstMaterial?.diffuse.contents = UIColor.black.withAlphaComponent(1)
                return box
            }
        }
    }

}
