//
//  OwnerPostCell.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/14.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import Firebase

class OwnerPostCell: UITableViewCell {
    
    var tracking: PostStatus?
    var post: ProductPost?
    
    @IBOutlet weak var deal: UIButton!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var trackerNameLabel: UILabel!
    @IBOutlet weak var postMessage: UITextView!

    @IBAction func deal(_ sender: Any) {
        
        let trackingRef = Database.database().reference().child("trackings")
        
        trackingRef.observeSingleEvent(of: .value, with: {(snapshot) in
            
            guard let value = snapshot.value as? [String: Any] else { return }
            
            for item in value {
                
                let postStatus = PostStatus()
                
                postStatus.setValuesForKeys(item.value as! [String : Any])
                
                if postStatus.postKey == self.tracking?.postKey && postStatus.fromId == self.tracking?.fromId {
                    
                    trackingRef.child(item.key).updateChildValues(["checked": "true"])
                    
                }
                
            }
            
            let givenRef = Database.database().reference().child("givens")
            
            givenRef.updateChildValues([(self.tracking?.postKey)!: 1])
            
        })
        
        
        
//        let trackingRef = Database.database().reference().child("trackings")
//        
//        trackingRef.observeSingleEvent(of: .value, with: {(snapshot) in
//
//            guard let value = snapshot.value as? [String: Any] else { return }
//            
//            for item in value {
//                
//                print(item.value)
//                
//                let postStatus = PostStatus()
//                
//                postStatus.setValuesForKeys(item.value as! [String : Any])
//                
//                if postStatus.postKey == self.tracking?.postKey && postStatus.fromId == self.tracking?.fromId {
//                    
//                    trackingRef.child(item.key).updateChildValues(["checked": "true"])
//                    
//                }
//                
//            }
//            
//            let givenRef = Database.database().reference().child("givens")
//            
//            givenRef.updateChildValues([(self.tracking?.postKey)!: 1])
//            
////            self.postBeGiven.append(self.tracking.postKey!)
//            
//        })

    }
}
