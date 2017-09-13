//
//  MainTabBarController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/22.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create Tab one
        let mapNC = UINavigationController(rootViewController: MapController())
        let mapBarItem = UITabBarItem(title: NSLocalizedString("Map", comment: ""), image: #imageLiteral(resourceName: "map"), selectedImage: nil)

        mapNC.tabBarItem = mapBarItem

        // Create Tab two
        let mesNC = UINavigationController(rootViewController: MessageController())
        let mesBarItem = UITabBarItem(title: NSLocalizedString("Message", comment: ""), image: #imageLiteral(resourceName: "message"), selectedImage: nil)

        mesNC.tabBarItem = mesBarItem

        // Create Tab three

        let dealNC = UINavigationController(rootViewController: DealController())
        let dealBarItem = UITabBarItem(title: NSLocalizedString("Deal", comment: ""), image: #imageLiteral(resourceName: "deal"), selectedImage: nil)

        dealNC.tabBarItem = dealBarItem
        self.viewControllers = [mapNC, mesNC, dealNC]
    }
}
