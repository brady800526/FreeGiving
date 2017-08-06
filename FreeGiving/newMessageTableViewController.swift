//
//  newMessageTableViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/6.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import Firebase

class newMessageTableViewController: UITableViewController {

    override func viewDidLoad() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "mess", style: .plain, target: self, action: #selector(showChatController))
        
    }
    
    func showChatController() {
        let vc = FriendTableViewController()
        let nv = UINavigationController(rootViewController: vc)
        present(nv, animated: true, completion: nil)
    }
}

