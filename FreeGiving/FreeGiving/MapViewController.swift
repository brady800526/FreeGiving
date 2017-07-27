//
//  ViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/26.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import Firebase

class MapViewController: UIViewController {

    @IBOutlet weak var logoutButtonItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(handleUpload))

        if Auth.auth().currentUser?.uid == nil {
            
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            handleLogout()
        }
    }
 
    func handleLogout() {
        
        do {

            try Auth.auth().signOut()

        } catch let logoutError {

            print(logoutError)

        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginPage") as! LoginViewController

        self.present(vc, animated: true, completion: nil)

    }
    
    func handleUpload() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "uploadPage") as! ImageUploadViewController
        
        self.present(vc, animated: true, completion: nil)
    }
}

