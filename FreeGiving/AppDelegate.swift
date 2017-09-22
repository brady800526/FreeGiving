//
//  AppDelegate.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/26.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.makeKeyAndVisible()
        
        UITabBar.appearance().tintColor = UIColor.orange
        
        UINavigationBar.appearance().tintColor = UIColor.white
        
        if let font = UIFont(name: "Marker Felt", size: 20) {
            
            UINavigationBar.appearance().titleTextAttributes = [

                NSForegroundColorAttributeName: UIColor.white,

                NSFontAttributeName: font
            ]
            
        }
        
        IQKeyboardManager.sharedManager().enable = true
        
        GMSServices.provideAPIKey("AIzaSyAKYy2EjtJfJFI2RgRFLwa0Q-OwDHjVr4M")
        
        GMSPlacesClient.provideAPIKey("AIzaSyAKYy2EjtJfJFI2RgRFLwa0Q-OwDHjVr4M")
        
        Fabric.with([Crashlytics.self])
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let userDefaults = UserDefaults.standard

        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {

            userDefaults.setValue(true, forKey: "appFirstTimeOpend")

            do {
                
                try Auth.auth().signOut()
                
            } catch let logoutError {
                
                print(logoutError)
                
            }
            
        }
        
        window?.rootViewController = MainTabBarController()
        
        return true
    }
    
}
