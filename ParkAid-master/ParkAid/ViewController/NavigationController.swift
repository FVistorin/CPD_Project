//
//  NavigationController.swift
//  ParkAid
//
//  Created by Meik on 06.07.20.
//  Copyright © 2020 Pierre Sucker. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class NavigationController:UINavigationController {

    func pushView(viewController:UIViewController) {
        pushViewController(viewController, animated: true)
    }
}


