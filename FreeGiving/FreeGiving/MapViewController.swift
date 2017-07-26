//
//  ViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/26.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var logoutButtonItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
    }
 
    func handleLogout() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginPage") as! LoginViewController
        self.present(vc, animated: true, completion: nil)

    }
    
}

