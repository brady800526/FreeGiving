//
//  MapViewController_handler.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/28.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import Firebase

extension MapViewController {
    
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
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "uploadPage") as! UINavigationController
        
        self.present(vc, animated: true, completion: nil)
    }

    
}
