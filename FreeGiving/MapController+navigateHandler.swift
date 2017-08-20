//
//  MapViewController_handler.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/28.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import Firebase

extension MapController {

    func handleLogout() {

        do {

            try Auth.auth().signOut()

        } catch let logoutError {

            print(logoutError)

        }

        // swiftlint:disable force_cast
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginPage") as! LoginController
        // swiftlint:enable force_cast

        vc.mapViewController = self

        self.present(vc, animated: true, completion: nil)

    }

    func handleUpload() {

        // swiftlint:disable force_cast
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "uploadPage") as! UINavigationController
        // swiftlint:enable force_cast

        self.present(vc, animated: true, completion: nil)
    }

}
