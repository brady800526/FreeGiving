//
//  MainTabBarController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/22.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

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
        let tabOneBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        
        mapNC.tabBarItem = tabOneBarItem
        
        // Create Tab two
        let mesNC = UINavigationController(rootViewController: MessageController())
        let tabTwoBarItem2 = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 1)
        
        mesNC.tabBarItem = tabTwoBarItem2
        self.viewControllers = [mapNC, mesNC]
    }
}
