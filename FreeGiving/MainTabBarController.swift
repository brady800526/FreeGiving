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
        let tabOneBarItem = UITabBarItem(title: NSLocalizedString("Map", comment: ""), image: #imageLiteral(resourceName: "map"), selectedImage: nil)

        mapNC.tabBarItem = tabOneBarItem

        // Create Tab two
        let mesNC = UINavigationController(rootViewController: MessageController())
        let tabTwoBarItem2 = UITabBarItem(title: NSLocalizedString("Message", comment: ""), image: #imageLiteral(resourceName: "message"), selectedImage: nil)

        mesNC.tabBarItem = tabTwoBarItem2

        // Create Tab three
        let vc = DealController()

        let ownNC = UINavigationController(rootViewController: vc)
        let tabTwoBarItem3 = UITabBarItem(title: NSLocalizedString("Deal", comment: ""), image: #imageLiteral(resourceName: "deal"), selectedImage: nil)

        ownNC.tabBarItem = tabTwoBarItem3
        self.viewControllers = [mapNC, mesNC, ownNC]
    }
}
