//
//  CustomCalloutView.swift
//  CustomCalloutView
//
//  Created by Malek T. on 3/10/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import UIKit
import Firebase

class CustomCalloutView: UIView {

    @IBOutlet var postImage: UIImageView!
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var postTime: UILabel!
    @IBOutlet var postDescription: UILabel!
    
    var mapVC: MapController?
    
    var post: Post? {

        didSet {
            
            postTitle.text = post?.title
            postTime.text = post?.productOnShelfTime
            postDescription.text = post?.productDescription
            
            //
//            let button = UIButton(frame: calloutView.starbucksPhone.frame)
            //        button.addTarget(self, action: #selector(ViewController.callPhoneNumber(sender:)), for: .touchUpInside)
//            calloutView.addSubview(button)
            
            postImage.sd_setImage(with: URL(string: (post?.productImageURL!)!), placeholderImage: nil)
            
            userId = post?.user
            
        }

    }
    
    var userId: String?

    @IBAction func chat(_ sender: Any) {
        
        let user = User()
        
        let ref = Database.database().reference()
        
        ref.child("users").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:Any] {
                
                user.setValuesForKeys(dictionary)
                
                self.showChatControllerForUser(user: user)
                
            }
            
        }, withCancel: nil)

    }
    
    @IBAction func check(_ sender: Any) {
    
        print(Auth.auth().currentUser?.uid)
        
        print(userId)
        
        print(post?.key)
        
        let ref = Database.database().reference()
        
        ref.child("trackings")
        
    }
    
    
    func showChatControllerForUser(user: User) {
        
        let vc = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        
        vc.user = user
        
        let nv = UINavigationController(rootViewController: vc)
        
        mapVC?.present(nv, animated: true)
    }


}
